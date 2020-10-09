module SemsIR where
import Control.Monad.Trans.Either (right)
import Common (Sems,Expr(..),Id(..),Frml,TyOper,Type(..),Callable(..),RVal(..),LVal(..)
              ,DispType(..),New(..),ArrSize(..),Stmt(..),Header(..),Body(..),Program(..)
              ,Local(..),(>=>),errAtId,searchCallableInSymTabs,(>>>),TyOperBool
              ,searchVarInSymTabs,lookupInLabelMap,toTType,errPos,put,get,modifyMod
              ,getLabelMap,toList,emptySymbolTable,getCallableMap,toName,Env(..)
              ,lookupInVariableMap,getEnv)
import InitSymTab (initSymTab,dummy)
import LocalsSemsIR (varsWithTypeListSemsIR,insToSymTabLabels,forwardSems
                    ,headerParentSems,headerChildSems,checkResult)
import ValSemsIR (binOpNumCases,comparisonCases,binOpBoolCases
                 ,binOpIntCases,unaryOpNumCases,notCases,dereferenceCases,indexingCases
                 ,resultTypeOper)
import StmtSemsIR (dispWithSems,dispWithoutSems,newNoExprSemsIR,newExprSemsIR
                  ,assignmentSemsIR',boolCases,labelCases,goToCases)
import SemsCodegen (cons,call,store,load,getElemPtr',allocaNum,setBlock,br
                   ,cbr,addBlock,fresh,retVoid,defineFun,ret)
import LLVM.AST (Operand,moduleName,Name)
import LLVM.AST.Type (void)
import Data.String.Transform (toShortByteString)
import Data.Char (ord)
import Data.List.Index (indexed)
import BodySemsIRHelpers (callRValueSemsIR',callStmtSemsIR')
import LLVM.AST.Float as F (SomeFloat(..))
import qualified LLVM.AST.Constant as C (Constant(..))

programSems :: Program -> Sems ()
programSems (P id body) = do
  modifyMod $ \mod -> mod { moduleName = toShortByteString $ idString id }
  initSymTab
  defineFun "main" void [] $ (mainCodegen body >> retVoid)

mainCodegen :: Body -> Sems ()
mainCodegen body = do
  entry <- addBlock "entry"
  setBlock entry
  bodySems body

bodySems :: Body -> Sems ()
bodySems (Body locals stmts) = do
  localsSems (reverse locals) 
  stmtsSems (reverse stmts) 
  getLabelMap >>= toList >>> (mapM_ $ \case
    (id,False) -> errAtId "Label declared but not used: " id
    _          -> return ())

localsSems :: [Local] -> Sems ()
localsSems locals = do
  mapM_ localSems locals 
  getCallableMap >>= toList >>> mapM_ (\case
    (id,(ProcDclr _  ,_)) -> errAtId "No definition for procedure declaration: " id
    (id,(FuncDclr _ _,_)) -> errAtId "No definition for function declaration: " id
    _                     -> return ())

localSems :: Local -> Sems ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSemsIR $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySemsIR h b
  Forward h             -> forwardSems h

headerBodySemsIR :: Header -> Body -> Sems ()
headerBodySemsIR h b = do
  headerParentSems h
  (e,sms,m,cgen) <- get
  put $ (e,emptySymbolTable:sms,m,cgen)
  headerChildSems h
  case h of
    ProcHeader id fs   -> defineFun (idString id) void fs $ mainCodegen b
    FuncHeader id fs t -> defineFun (idString id) (toTType t) fs $ mainCodegen b
  checkResult
  (_,_,m',_) <- get
  put (e,sms,m',cgen)

stmtsSems :: [Stmt] -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  Empty                      -> return ()
  Assignment posn lVal expr  -> assignmentSemsIR posn lVal expr
  Block stmts                -> stmtsSems $ reverse stmts
  CallS (id,exprs)           -> callStmtSemsIR id $ reverse exprs
  IfThen posn e s            -> exprTypeOper e >>= boolCases posn "if-then" >>= 
                                cgenIfThen s
  IfThenElse posn e s1 s2    -> exprTypeOper e >>= boolCases posn "if-then-else" >>=
                                cgenIfThenElse s1 s2
  While posn e stmt          -> whileSemsIR posn e stmt
  Label id stmt              -> labelSemsIR id stmt
  GoTo id                    -> gotoSemsIR id
  Return                     -> getEnv >>= \case
                                  InProc            -> retVoid
                                  InFunc id ty bool -> do
                                    op <- lookupInVariableMap (dummy "result") >>= \case
                                      Just (_,op) -> return op
                                      Nothing     -> error "Shouldn't happen"
                                    op <- load op
                                    ret op
  New posn new lVal          -> newSemsIR posn new lVal
  Dispose posn disptype lVal -> disposeSems posn disptype lVal

assignmentSemsIR :: (Int,Int) -> LVal -> Expr -> Sems ()
assignmentSemsIR posn = \case
  StrLiteral str -> \_ -> errPos posn $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypeOpers lVal >=> assignmentSemsIR' posn

callStmtSemsIR :: Id -> [Expr] -> Sems ()
callStmtSemsIR id exprs = searchCallableInSymTabs id >>= \case
  (ProcDclr fs,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs 
  (Proc     fs,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs
  _               -> errAtId "Use of function in call statement: " id

gotoSemsIR :: Id -> Sems ()
gotoSemsIR id = do
  bool <- lookupInLabelMap id 
  goToCases id bool
  br $ toName $ idString id
  i <- fresh
  nextBlock <- addBlock $ "next" ++ show i
  setBlock nextBlock

labelSemsIR :: Id -> Stmt -> Sems ()
labelSemsIR id stmt = do
  bool <- lookupInLabelMap id
  labelCases id bool
  label <- addBlock $ idString id
  br label 
  
  setBlock label
  stmtSems stmt

whileSemsIR :: (Int,Int) -> Expr -> Stmt -> Sems ()
whileSemsIR posn expr stmt = do
  while     <- addBlock "while"
  whileExit <- addBlock "while.exit"

  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock while
  stmtSems stmt          
  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock whileExit


cgenIfThenElse :: Stmt -> Stmt -> Operand -> Sems ()
cgenIfThenElse stmt1 stmt2 cond = do
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifelse

  setBlock ifthen
  stmtSems stmt1
  br ifexit     

  setBlock ifelse
  stmtSems stmt2
  br ifexit     

  setBlock ifexit


cgenIfThen :: Stmt -> Operand -> Sems ()
cgenIfThen stmt cond = do
  ifthen <- addBlock "if.then"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifexit

  setBlock ifthen
  stmtSems stmt          
  br ifexit              

  setBlock ifexit

newSemsIR :: (Int,Int) -> New -> LVal -> Sems ()
newSemsIR posn = \case
  NewNoExpr -> lValTypeOper >=> newNoExprSemsIR posn
  NewExpr e -> exprLValTypeOpers e >=> newExprSemsIR posn

disposeSems :: (Int,Int) -> DispType -> LVal -> Sems ()
disposeSems posn = \case
  Without -> lValTypeOper >=> dispWithoutSems posn
  With    -> lValTypeOper >=> dispWithSems posn

toTyOper :: TyOperBool -> Sems TyOper
toTyOper = \case
  (ty,op,True)  -> do
    op' <- load op
    return (ty,op')
  (ty,op,False) -> return (ty,op)

exprTypeOper :: Expr -> Sems TyOper
exprTypeOper = exprTypeOperBool >=> toTyOper

exprTypeOperBool :: Expr -> Sems TyOperBool
exprTypeOperBool = \case
  LVal lval -> lValTypeOper lval >>= \(ty,op) -> return (ty,op,True)
  RVal rval -> rValTypeOper rval >>= \(ty,op) -> return (ty,op,False)

lValTypeOper :: LVal -> Sems (Type,Operand)
lValTypeOper = \case
  IdL         id             -> searchVarInSymTabs id
  Result      posn           -> resultTypeOper posn
  StrLiteral  str            -> strLiteralSemsIR str
  Indexing    posn lVal expr -> lValExprTypeOpers lVal expr >>= indexingCases posn
  Dereference posn expr      -> exprTypeOper expr >>= dereferenceCases posn
  ParenL      lVal           -> lValTypeOper lVal

strLiteralSemsIR :: String -> Sems TyOper
strLiteralSemsIR string = do
  (_,num) <- rValTypeOper $ IntR $ length string + 1
  strOper <- allocaNum num $ toTType CharT
  mapM_ (cgenStrLitChar strOper) $ indexed $ string ++ ['\0']
  return (Array NoSize CharT,strOper)

cgenStrLitChar :: Operand -> (Int,Char) -> Sems ()
cgenStrLitChar strOper (ind,char) = do
  charPtr <- getElemPtr' strOper ind
  store charPtr $ cons $ C.Int 8 $ toInteger $ ord char

exprLValTypeOpers expr lVal = do
  eto <- exprTypeOper expr
  lto <- lValTypeOper lVal
  return (eto,lto)

lValExprTypeOpers lVal expr = do
  lto <- lValTypeOper lVal 
  eto <- exprTypeOper expr
  return (lto,eto)

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

