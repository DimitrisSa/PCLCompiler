module Sems where
import Control.Monad.Trans.Either
import System.IO as S
import System.Exit
import Common
import InitSymTab (initSymTab)
import LocalsSems 
import ValTypes
import StmtSems
import LLVM.Context
import LLVM.Module
import Emit (codegen)
import SemsCodegen
import qualified LLVM.AST as AST
import qualified LLVM.AST.Type as T
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import Data.String.Transform
import Data.Char (ord)
import Data.List.Index
import System.Process
import Data.ByteString.Char8 (unpack)

process :: IO ()
process = sems'

codegen' :: AST.Module -> IO ()
codegen' m =
  withContext $ \context -> withModuleFromAST context m $ \m -> do
    llstr <- moduleLLVMAssembly m
    --putStrLn $ unpack llstr
    writeFile "llvmhs.ll" $ unpack llstr
    callCommand "./usefulHs.sh"

sems' :: IO ()
sems' = do
  c <- S.getContents
  putStrLn c
  parserCases' $ parser c

parserCases' :: Either Error Program -> IO ()
parserCases' = \case 
  Left e    -> die e
  Right ast -> astSems' ast

astSems' :: Program -> IO ()
astSems' ast =
  let runProgramSems = programSems >>> runEitherT >>> runState
  in case runProgramSems ast initState of
    (Right _,(_,_,m,_)) -> codegen' m
    (Left e,_)          -> die e

-- same name of fun inside of other fun?
sems :: IO Program
sems = do
  c <- S.getContents
  putStrLn c
  p <- parserCases $ parser c
  --print p
  return p

parserCases :: Either Error Program -> IO Program
parserCases = \case 
  Left e    -> die e
  Right ast -> astSems ast

astSems :: Program -> IO Program
astSems ast =
  let runProgramSems = programSems >>> runEitherT >>> runState
  in case runProgramSems ast initState of
    (Right _,_) -> return ast
    (Left e,_)  -> die e

programSems :: Program -> Sems ()
programSems (P id body) = do
  modifyMod $ \mod -> mod { AST.moduleName = idToShort id }
  initSymTab
  defineFun "main" T.void [] $ mainCodegen body

idToShort = idString >>> toShortByteString

mainCodegen :: Body -> Sems ()
mainCodegen body = do
  entry <- addBlock "entry"
  setBlock entry
  bodySems body
  retVoid

bodySems :: Body -> Sems ()
bodySems (Body locals stmts) = do
  localsSems (reverse locals) 
  stmtsSems (reverse stmts) 
  checkUnusedLabels

checkUnusedLabels :: Sems ()
checkUnusedLabels = getLabelMap >>= toList >>> (mapM_ $ \case
  (id,False) -> errAtId "Label declared but not used: " id
  _          -> return ())

localsSems :: [Local] -> Sems ()
localsSems locals = mapM_ localSems locals >> checkUndefDclrs

localSems :: Local -> Sems ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSemsIR $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySems h b
  Forward h             -> forwardSems h

varsWithTypeListSemsIR rvwtl = do
  varsWithTypeListSems rvwtl
  mapM_ cgenVars rvwtl

cgenVars :: ([Id],Type) -> Sems ()
cgenVars (ids,ty) = mapM_ (cgenVar ty) $ reverse ids

cgenVar :: Type -> Id -> Sems ()
cgenVar ty id = do 
  var <- alloca $ toTType ty
  assign (idString id) var

headerBodySems :: Header -> Body -> Sems ()
headerBodySems h b = do
  headerParentSems h
  (e,sms,m,cgen) <- get
  put $ (e,emptySymbolTable:sms,m,cgen)
  headerChildSems h
  bodySems b
  checkResult
  put (e,sms,m,cgen)

stmtsSems :: [Stmt] -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  Empty                      -> return ()
  Assignment posn lVal expr  -> assignmentSems posn lVal expr
  Block stmts                -> stmtsSems $ reverse stmts
  CallS (id,exprs)           -> callSems id $ reverse exprs
  IfThen posn e s            -> exprTypeOper e >>= boolCases posn "if-then" >>= 
                                cgenIfThen s
  IfThenElse posn e s1 s2    -> exprTypeOper e >>= boolCases posn "if-then-else" >>=
                                cgenIfThenElse s1 s2
  While posn e stmt          -> whileSemsIR posn e stmt
  Label lab stmt             -> lookupInLabelMap lab >>= labelCases lab >> stmtSems stmt
  GoTo lab                   -> lookupInLabelMap lab >>= goToCases lab
  Return                     -> return ()
  New posn new lVal          -> newSemsIR posn new lVal
  Dispose posn disptype lVal -> disposeSems posn disptype lVal

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


cgenIfThenElse :: Stmt -> Stmt -> AST.Operand -> Sems ()
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


cgenIfThen :: Stmt -> AST.Operand -> Sems ()
cgenIfThen stmt cond = do
  ifthen <- addBlock "if.then"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifexit

  setBlock ifthen
  stmtSems stmt          
  br ifexit              

  setBlock ifexit

callSems :: Id -> [Expr] -> Sems ()
callSems id exprs = searchCallableInSymTabs id >>= \case
  ProcDclr fs -> formalsExprsMatch id fs exprs >> cgenCallStmt id exprs 
  Proc     fs -> formalsExprsMatch id fs exprs >> cgenCallStmt id exprs 
  _           -> errAtId "Use of function in call statement: " id

idToName :: Id -> AST.Name
idToName = idString >>> toName

cgenCallStmt :: Id -> [Expr] -> Sems ()
cgenCallStmt id exprs = do
  args <- mapM (exprTypeOper >=> snd >>> return) exprs
  callVoid (idToFunOper id) args

idToFunOper = idString >>> \case
  "writeInteger" -> writeInteger
  "writeChar"    -> writeChar 
  "writeReal"    -> writeReal
  "writeString"  -> writeString 
  _ -> undefined

assignmentSems :: (Int,Int) -> LVal -> Expr -> Sems ()
assignmentSems posn = \case
  StrLiteral str -> \_ -> errPos posn $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypeOpers lVal >=> notStrLiteralSems posn

newSemsIR :: (Int,Int) -> New -> LVal -> Sems ()
newSemsIR posn = \case
  NewNoExpr -> lValTypeOper >=> newNoExprSemsIR posn
  NewExpr e -> exprLValTypeOpers e >=> newExprSems posn

disposeSems :: (Int,Int) -> DispType -> LVal -> Sems ()
disposeSems posn = \case
  Without -> lValTypeOper >=> dispWithoutSems posn
  With    -> lValTypeOper >=> dispWithSems posn

exprTypeOper :: Expr -> Sems (Type,AST.Operand)
exprTypeOper = \case
  LVal lval -> lValTypeOper lval >>= \(ty,op) -> load op >>= \op' -> return (ty,op')
  RVal rval -> rValTypeOper rval

lValTypeOper :: LVal -> Sems (Type,AST.Operand)
lValTypeOper = \case
  IdL         id             -> do
    ty <- searchVarInSymTabs id
    oper <- getvar $ idString id 
    return (ty,oper)
  Result      posn           -> resultType posn
  StrLiteral  str            -> strLiteralSemsIR str
  Indexing    posn lVal expr -> lValExprTypeOpers lVal expr >>= indexingCases posn
  Dereference posn expr      -> exprTypeOper expr >>= dereferenceCases posn
  ParenL      lVal           -> lValTypeOper lVal

strLiteralSemsIR :: String -> Sems TyOper
strLiteralSemsIR string = do
  (_,num) <- rValTypeOper $ IntR $ length string + 1
  strPtrOper <- alloca $ toTType $ Pointer CharT
  strOper <- allocaNum num $ toTType CharT
  mapM_ (cgenStrLitChar strOper) $ indexed $ string ++ ['\0']
  store strPtrOper strOper
  return (Array (Size $ length string + 1) CharT,strPtrOper)

cgenStrLitChar :: AST.Operand -> (Int,Char) -> Sems ()
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

rValTypeOper :: RVal -> Sems (Type,AST.Operand)
rValTypeOper = \case
  IntR    int        -> right (IntT,cons $ C.Int 16 $ toInteger int)
  TrueR              -> right (BoolT,cons $ C.Int 1 1)
  FalseR             -> right (BoolT,cons $ C.Int 1 0)
  RealR   double     -> right (RealT,cons $ C.Float $ F.Double double) --X86_FP80
  CharR   char       -> right (CharT,cons $ C.Int 8 $ toInteger $ ord char)
  ParenR  rVal       -> rValTypeOper rVal
  NilR               -> right (Nil,cons $ C.Int 1 0)
  CallR   (id,exprs) -> callType id $ reverse exprs
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

callType :: Id -> [Expr] -> Sems (Type,AST.Operand)
callType id exprs = do
  callable <- searchCallableInSymTabs id 
  case callable of
    FuncDclr fs t -> formalsExprsMatch id fs exprs >> right (t,undefined)
    Func  fs t    -> formalsExprsMatch id fs exprs >> right (t,undefined)
    _             -> errAtId "Use of procedure where a return value is required: " id

formalsExprsMatch :: Id -> [Frml] -> [Expr] -> Sems ()
formalsExprsMatch id fs exprs = do
  types <- mapM (exprTypeOper >=> return . fst) exprs 
  formalsExprsTypesMatch 1 id (formalsToTypes fs) types
