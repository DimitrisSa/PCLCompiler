module SemsIR where
import Control.Monad.Trans.Either (right)
import Common (Sems,Expr(..),Id(..),Frml,TyOper,Type(..),Callable(..),RVal(..),LVal(..)
              ,DispType(..),New(..),ArrSize(..),Stmt(..),Header(..),Body(..),Program(..)
              ,Local(..),(>=>),errAtId,searchCallableInSymTabs,(>>>),TyOperBool
              ,searchVarInSymTabs,lookupInLabelMap,toTType,errPos,put,get,modifyMod
              ,getLabelMap,toList,emptySymbolTable,getCallableMap,toName,emptyCodegen
              ,modifyCodegen,variableMap,VariableMap,PassBy(..),getVariableMap)
import InitSymTab (initSymTab)
import LocalsSemsIR (varsWithTypeListSemsIR,insToSymTabLabels,forwardSems
                    ,headerParentSems,headerChildSems,checkResult)
import ValSemsIR (binOpNumCases,comparisonCases,binOpBoolCases
                 ,binOpIntCases,unaryOpNumCases,notCases,dereferenceCases,indexingCases
                 ,resultTypeOper)
import StmtSemsIR (dispWithSems,dispWithoutSems,newNoExprSemsIR,newExprSemsIR
                  ,assignmentSemsIR',boolCases,labelCases,goToCases,returnIR)
import SemsCodegen (cons,call,store,load,getElemPtr',alloca,setBlock,br
                   ,cbr,addBlock,fresh,retVoid,defineFun,ret,getElemPtrInt)
import LLVM.AST (Operand,moduleName,Name)
import LLVM.AST.Type (void)
import Data.String.Transform (toShortByteString)
import Data.Char (ord)
import Data.List.Index (indexed)
import BodySemsIRHelpers (callRValueSemsIR',callStmtSemsIR')
import LLVM.AST.Float as F (SomeFloat(..))
import qualified LLVM.AST.Constant as C (Constant(..))

programSemsIR :: Program -> Sems ()
programSemsIR (P id body) = do
  modifyMod $ \mod -> mod { moduleName = toShortByteString $ idString id }
  initSymTab
  defineFun "main" void [] $ do
    entry <- addBlock "entry"
    setBlock entry
    bodySemsIR body
    retVoid

bodySemsIR :: Body -> Sems ()
bodySemsIR (Body locals stmts) = do
  localsSemsIR (reverse locals) 
  stmtsSemsIR (reverse stmts) 
  getLabelMap >>= toList >>> (mapM_ $ \case
    (id,False) -> errAtId "Label declared but not used: " id
    _          -> return ())

localsSemsIR :: [Local] -> Sems ()
localsSemsIR locals = do
  mapM_ localSemsIR locals 
  getCallableMap >>= toList >>> mapM_ (\case
    (id,(ProcDclr _  ,_)) -> errAtId "No definition for procedure declaration: " id
    (id,(FuncDclr _ _,_)) -> errAtId "No definition for function declaration: " id
    _                     -> return ())

localSemsIR :: Local -> Sems ()
localSemsIR = \case
  VarsWithTypeList vwtl -> varsWithTypeListSemsIR $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySemsIR h b
  Forward h             -> forwardSems h

functionBodySemsIR :: Body -> Sems ()
functionBodySemsIR b = do
  bodySemsIR b
  returnIR

headerBodySemsIR :: Header -> Body -> Sems ()
headerBodySemsIR h b = do
  parentVarMap <- getVariableMap
  let parentFormals = toParFrmls (toList parentVarMap) h
  headerParentSems parentFormals h
  (e,sms,m,cgen) <- get
  put $ (e,emptySymbolTable:sms,m,cgen)
  let codegen = do
                  entry <- addBlock "entry"
                  setBlock entry
                  headerChildSems parentFormals h
                  functionBodySemsIR b
  case h of
    ProcHeader id fs   ->
      defineFun (idString id) void (reverse fs ++ parentFormals) codegen 
    FuncHeader id fs t ->
      defineFun (idString id) (toTType t) (reverse fs ++ parentFormals) codegen
  checkResult
  (_,_,m',_) <- get
  put (e,sms,m',cgen)

toParFrmls :: [(Id,TyOperBool)] -> Header -> [Frml]
toParFrmls varmaplist = \case
  ProcHeader id fs   -> toParFrmls' $ filter (not . isInTrueFrmls fs) varmaplist
  FuncHeader id fs t -> toParFrmls' $ filter (not . isInTrueFrmls fs) varmaplist

toParFrmls' :: [(Id,TyOperBool)] -> [Frml]
toParFrmls' = map toParFrml

toParFrml :: (Id,TyOperBool) -> Frml 
toParFrml (id,(ty,op,_)) = (Ref,[id],ty)

isInTrueFrmls :: [Frml] -> (Id,TyOperBool) -> Bool
isInTrueFrmls fs (id,_) = elem id $ concat $ map (\(_,ids,_) -> ids) fs

stmtsSemsIR :: [Stmt] -> Sems ()
stmtsSemsIR ss = mapM_ stmtSemsIR ss

stmtSemsIR :: Stmt -> Sems ()
stmtSemsIR = \case
  Empty                      -> return ()
  Assignment posn lVal expr  -> assignmentSemsIR posn lVal expr
  Block stmts                -> stmtsSemsIR $ reverse stmts
  CallS (id,exprs)           -> callStmtSemsIR id $ reverse exprs
  IfThen posn e s            -> ifThenSemsIR posn e s
  IfThenElse posn e s1 s2    -> ifThenElseSemsIR posn e s1 s2
  While posn e stmt          -> whileSemsIR posn e stmt
  Label id stmt              -> labelSemsIR id stmt
  GoTo id                    -> gotoSemsIR id
  Return                     -> returnIR
  New posn new lVal          -> newSemsIR posn new lVal
  Dispose posn disptype lVal -> disposeSemsIR posn disptype lVal

assignmentSemsIR :: (Int,Int) -> LVal -> Expr -> Sems ()
assignmentSemsIR posn = \case
  StrLiteral str -> \_ -> errPos posn $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypeOpers lVal >=> assignmentSemsIR' posn

lValExprTypeOpers lVal expr = do
  lto <- lValTypeOper lVal 
  eto <- exprTypeOper expr
  return (lto,eto)

callStmtSemsIR :: Id -> [Expr] -> Sems ()
callStmtSemsIR id exprs = searchCallableInSymTabs id >>= \case
  (ProcDclr fs,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs 
  (Proc     fs,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs
  _               -> errAtId "Use of function in call statement: " id

ifThenSemsIR :: (Int,Int) -> Expr -> Stmt -> Sems ()
ifThenSemsIR posn e s = do
  cond <- boolCases posn "if-then" =<< exprTypeOper e

  ifthen <- addBlock "if.then"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifexit

  setBlock ifthen
  stmtSemsIR s
  br ifexit              

  setBlock ifexit

ifThenElseSemsIR :: (Int,Int) -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseSemsIR posn e s1 s2 = do
  cond <- boolCases posn "if-then-else" =<< exprTypeOper e

  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifelse

  setBlock ifthen
  stmtSemsIR s1
  br ifexit     

  setBlock ifelse
  stmtSemsIR s2
  br ifexit     

  setBlock ifexit

whileSemsIR :: (Int,Int) -> Expr -> Stmt -> Sems ()
whileSemsIR posn expr stmt = do
  while     <- addBlock "while"
  whileExit <- addBlock "while.exit"

  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock while
  stmtSemsIR stmt          
  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock whileExit

labelSemsIR :: Id -> Stmt -> Sems ()
labelSemsIR id stmt = do
  bool <- lookupInLabelMap id
  labelCases id bool
  label <- addBlock $ idString id
  br label 
  
  setBlock label
  stmtSemsIR stmt

gotoSemsIR :: Id -> Sems ()
gotoSemsIR id = do
  bool <- lookupInLabelMap id 
  goToCases id bool
  br $ toName $ idString id
  i <- fresh
  nextBlock <- addBlock $ "next" ++ show i
  setBlock nextBlock

newSemsIR :: (Int,Int) -> New -> LVal -> Sems ()
newSemsIR posn = \case
  NewNoExpr -> lValTypeOper >=> newNoExprSemsIR posn
  NewExpr e -> exprLValTypeOpers e >=> newExprSemsIR posn

exprLValTypeOpers expr lVal = do
  eto <- exprTypeOper expr
  lto <- lValTypeOper lVal
  return (eto,lto)

disposeSemsIR :: (Int,Int) -> DispType -> LVal -> Sems ()
disposeSemsIR posn = \case
  Without -> lValTypeOper >=> dispWithoutSems posn
  With    -> lValTypeOper >=> dispWithSems posn

toTyOper :: TyOperBool -> Sems TyOper
toTyOper = \case
  (ty,op,True)  -> load op >>= \op' -> return (ty,op')
  (ty,op,False) -> return (ty,op)

exprTypeOper :: Expr -> Sems TyOper
exprTypeOper = exprTypeOperBool >=> toTyOper

exprTypeOperBool :: Expr -> Sems TyOperBool
exprTypeOperBool = \case
  LVal lval -> lValTypeOper lval >>= \(ty,op) -> return (ty,op,True)
  RVal rval -> rValTypeOper rval >>= \(ty,op) -> return (ty,op,False)

lValTypeOper :: LVal -> Sems (Type,Operand)
lValTypeOper = \case
  IdL         id             -> searchVarInSymTabs id >>= \(ty,op,_) -> return (ty,op)
  Result      posn           -> resultTypeOper posn
  StrLiteral  str            -> strLiteralSemsIR str
  Indexing    posn lVal expr -> lValExprTypeOpers lVal expr >>= indexingCases posn
  Dereference posn expr      -> exprTypeOper expr >>= dereferenceCases posn
  ParenL      lVal           -> lValTypeOper lVal

strLiteralSemsIR :: String -> Sems TyOper
strLiteralSemsIR string = do
  let n = length string + 1
  let t = Array (Size n) CharT
  strOper <- alloca $ toTType t
  mapM_ (cgenStrLitChar strOper) $ indexed $ string ++ ['\0']
  return (t,strOper)

cgenStrLitChar :: Operand -> (Int,Char) -> Sems ()
cgenStrLitChar strOper (ind,char) = do
  charPtr <- getElemPtrInt strOper ind
  store charPtr $ cons $ C.Int 8 $ toInteger $ ord char

rValTypeOper :: RVal -> Sems (Type,Operand)
rValTypeOper = \case
  IntR    int        -> right (IntT,cons $ C.Int 16 $ toInteger int)
  TrueR              -> right (BoolT,cons $ C.Int 1 1)
  FalseR             -> right (BoolT,cons $ C.Int 1 0)
  RealR   double     -> right (RealT,cons $ C.Float $ F.Double double) --X86_FP80
  CharR   char       -> right (CharT,cons $ C.Int 8 $ toInteger $ ord char)
  ParenR  rVal       -> rValTypeOper rVal
  NilR               -> right (Nil,cons $ C.Int 1 0)
  CallR   (id,exprs) -> callRValueSemsIR id $ reverse exprs
  Papaki  lVal       -> lValTypeOper lVal >>= \(ty,op) -> right (Pointer ty,op)
  Not     posn expr  -> exprTypeOper expr >>= notCases posn
  Pos     posn expr  -> exprTypeOper expr >>= unaryOpNumCases posn "'+'"
  Neg     posn expr  -> exprTypeOper expr >>= unaryOpNumCases posn "'-'"
  Plus    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'+'"
  Mul     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'*'"
  Minus   posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'-'"
  RealDiv posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn RealT RealT "'/'"
  Div     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpIntCases posn "'div'"
  Mod     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpIntCases posn "'mod'"
  Or      posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpBoolCases posn "'or'"
  And     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpBoolCases posn "'and'"
  Eq      posn e1 e2 -> exprsTypeOpers e1 e2 >>= comparisonCases posn "'='"
  Diff    posn e1 e2 -> exprsTypeOpers e1 e2 >>= comparisonCases posn "'<>'"
  Less    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'<'"
  Greater posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'>'"
  Greq    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'>='"
  Smeq    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'<='"

exprsTypeOpers exp1 exp2 = mapM exprTypeOper [exp1,exp2]

callRValueSemsIR :: Id -> [Expr] -> Sems (Type,Operand)
callRValueSemsIR id exprs = searchCallableInSymTabs id >>= \case
  (FuncDclr fs t,_) -> mapM exprTypeOperBool exprs >>= callRValueSemsIR' id fs t 
  (Func  fs t   ,_) -> mapM exprTypeOperBool exprs >>= callRValueSemsIR' id fs t
  _                 -> errAtId "Use of procedure where a return value is required: " id

