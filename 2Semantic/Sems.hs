module Main where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import Data.Function
import Common hiding (map)
import InitSymTab (initSymTab)
import VarsWithTypeListSems (varsWithTypeListSems)
import InsToSymTabLabels (insToSymTabLabels)
import ForwardSems (forwardSems)
import CheckUndefDeclarationSems (checkUndefDeclarationSems)
import CheckUnusedLabels (checkUnusedLabels)
import HeaderParentSems (headerParentSems)
import HeaderChildSems (headerChildSems)
import LValTypes (idType,resultType)
import CheckResult (checkResult)

-- same name of fun inside of other fun?

main :: IO ()
main = sems

sems :: IO ()
sems = getContents >>= parser >>> parserErrOrAstSems

parserErrOrAstSems :: Either Error Program -> IO ()
parserErrOrAstSems = \case 
  Left e -> die e
  Right ast -> astSems ast

astSems :: Program -> IO ()
astSems ast =
  let runProgramSems = programSems >>> runEitherT >>> evalState
  in case runProgramSems ast initState of
    Right _  -> hPutStrLn stdout "good" >> exitSuccess
    Left s   -> die s

programSems :: Program -> Sems ()
programSems (P _ body) = initSymTab >> bodySems body

bodySems :: Body -> Sems ()
bodySems (Body locals stmts) = do
  localsSems $ reverse locals
  stmtsSems $ reverse stmts
  checkUnusedLabels

localsSems :: [Local] -> Sems ()
localsSems locals = mapM_ localSems locals >> checkUndefDeclarationSems

localSems :: Local -> Sems ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSems $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySems h b
  Forward h             -> forwardSems h

headerBodySems :: Header -> Body -> Sems ()
headerBodySems h b = do
  headerParentSems h
  (e,sms) <- get
  put $ (e,emptySymbolTable:sms)
  headerChildSems h
  bodySems b
  checkResult
  put (e,sms)

stmtsSems :: [Stmt] -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  Empty                             -> return ()
  Equal li co lVal expr             -> equalSems li co expr lVal
  Block stmts                       -> stmtsSems $ reverse stmts
  CallS (id,exprs)                  -> callSems id $ reverse exprs
  IfThen  li co  expr stmt          -> ifThenSems li co expr stmt
  IfThenElse li co expr stmt1 stmt2 -> ifThenElseSems li co expr stmt1 stmt2
  While li co expr stmt             -> whileSems li co expr stmt
  Label id stmt                     -> checkId id >> stmtSems stmt
  GoTo id                           -> checkGoTo id
  Return                            -> return ()
  New li co new lVal                -> newSems li co new lVal
  Dispose li co disptype lVal       -> disposeSems li co disptype lVal

equalSems :: Int -> Int -> Expr -> LVal -> Sems ()
equalSems li co expr = \case
  StrLiteral str -> left $ errPos li co ++ strAssignmentErr ++ str
  lVal           -> notStrLiteralEqualSems li co lVal expr

notStrLiteralEqualSems li co lVal expr = do
  lt <- lValType lVal
  et <- exprType expr
  symbatos' lt et $ errPos li co ++ assTypeMisErr

exprType :: Expr -> Sems Type
exprType = \case
  LVal lval -> lValType lval
  RVal rval -> rValType rval

--lstart
lValType :: LVal -> Sems Type
lValType = \case
  IdL id                   -> idType id
  Result li co             -> resultType li co
  StrLiteral str           -> right $ Array (Size $ length str + 1) CharT
  Indexing li co lVal expr -> indexingType li co lVal expr
  Dereference li co expr   -> dereferenceType li co expr
  ParenL lVal              -> lValType lVal

indexingType :: Int -> Int -> LVal -> Expr -> Sems Type
indexingType li co lVal expr = exprType expr >>= \case
  IntT -> lValType lVal >>= \case Array _ t -> right t; _ -> left $ errPos li co ++ arrErr
  _    -> left $ errPos li co ++ indErr

dereferenceType :: Int -> Int -> Expr -> Sems Type 
dereferenceType li co expr = exprType expr >>= \case
  Pointer t -> right t
  Nil       -> left $ errPos li co ++ "dereferencing Nil pointer"
  _         -> left $ errPos li co ++ pointErr
--lend

--rstart
rValType :: RVal -> Sems Type
rValType = \case
  IntR _                  -> right IntT
  TrueR                   -> right BoolT
  FalseR                  -> right BoolT
  RealR _                 -> right RealT
  CharR _                 -> right CharT
  ParenR  rVal            -> rValType rVal
  NilR                    -> right Nil
  CallR   (id,exprs)      -> callType id $ reverse exprs
  Papaki  _ _ lVal        -> lValType lVal >>= Pointer >>> right
  Not     li co expr      -> notType li co expr
  Pos     li co expr      -> unaryOpNumType li co expr "'+'"
  Neg     li co expr      -> unaryOpNumType li co expr "'-'"
  Plus    li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 IntT RealT "'+'"
  Mul     li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 IntT RealT "'*'"
  Minus   li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 IntT RealT "'-'"
  RealDiv li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 RealT RealT "'/'"
  Div     li co exp1 exp2 -> binaryOpIntType li co exp1 exp2 "'div'"
  Mod     li co exp1 exp2 -> binaryOpIntType li co exp1 exp2 "'mod'"
  Or      li co exp1 exp2 -> binaryOpBoolType li co exp1 exp2 "'or'"
  And     li co exp1 exp2 -> binaryOpBoolType li co exp1 exp2 "'and'"
  Eq      li co exp1 exp2 -> comparisonType li co exp1 exp2 "'='"
  Diff    li co exp1 exp2 -> comparisonType li co exp1 exp2 "'<>'"
  Less    li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 BoolT BoolT "'<'"
  Greater li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 BoolT BoolT "'>'"
  Greq    li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 BoolT BoolT "'>='"
  Smeq    li co exp1 exp2 -> binaryOpNumType li co exp1 exp2 BoolT BoolT "'<='"

callType :: Id -> Exprs -> Sems Type
callType id exprs = 
  get >>= snd >>> searchCallableInSymTabs id (errAtId callErr id) >>= \case
    Func  fs t           -> formalsExprsMatch id fs exprs >> right t
    FuncDeclaration fs t -> error "Should not happen"
    _                    -> errAtId callSemErr id

formalsExprsMatch :: Id -> [Formal] -> Exprs -> Sems ()
formalsExprsMatch id fs exprs =
  mapM exprType exprs >>= formalsExprsTypesMatch 1 id (formalsToTypes fs)

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId argsExprsErr id

formalExprTypeMatch i id t1 t2 t1s t2s = do
  symbatos' t1 t2 $ errorAtArg badArgErr i id 
  formalsExprsTypesMatch (i+1) id t1s t2s

comparisonType :: Int -> Int -> Expr -> Expr -> String -> Sems Type
comparisonType li co exp1 exp2 a = mapM exprType [exp1,exp2] >>= \case
  [IntT,IntT]           -> right BoolT
  [IntT,RealT]          -> right BoolT
  [RealT,IntT]          -> right BoolT
  [RealT,RealT]         -> right BoolT
  [BoolT,BoolT]         -> right BoolT
  [CharT,CharT]         -> right BoolT
  [Pointer _,Pointer _] -> right BoolT
  [Pointer _,Nil]       -> right BoolT
  [Nil,Pointer _]       -> right BoolT
  [Nil,Nil]             -> right BoolT
  _                     -> left $ errPos li co ++ mismTypesErr ++ a

binaryOpBoolType :: Int -> Int -> Expr -> Expr -> String -> Sems Type
binaryOpBoolType li co exp1 exp2 a = mapM exprType [exp1,exp2] >>= \case
  [BoolT,BoolT] -> right BoolT
  [BoolT,_]     -> left $ errPos li co ++ nonBoolAfErr ++ a
  _             -> left $ errPos li co ++ nonBoolBefErr ++ a

binaryOpIntType :: Int -> Int -> Expr -> Expr -> String -> Sems Type
binaryOpIntType li co exp1 exp2 a = mapM exprType [exp1,exp2] >>= \case
  [IntT,IntT] -> right IntT
  [IntT,_]    -> left $ errPos li co ++ nonIntAfErr ++ a
  _           -> left $ errPos li co ++ nonIntBefErr ++ a

binaryOpNumType :: Int -> Int -> Expr -> Expr -> Type -> Type-> String -> Sems Type
binaryOpNumType li co exp1 exp2 intIntType restType a = mapM exprType [exp1,exp2] >>= \case
  [IntT,IntT]   -> right intIntType
  [IntT,RealT]  -> right restType
  [RealT,IntT]  -> right restType
  [RealT,RealT] -> right restType
  [IntT,_]      -> left $ errPos li co ++ nonNumAfErr ++ a
  [RealT,_]     -> left $ errPos li co ++ nonNumAfErr ++ a
  _             -> left $ errPos li co ++ nonNumBefErr ++ a

unaryOpNumType :: Int -> Int -> Expr -> String -> Sems Type
unaryOpNumType li co expr a = exprType expr >>= \case
  IntT  -> right IntT
  RealT -> right RealT
  _     -> left $ errPos li co ++ nonNumAfErr ++ a

notType :: Int -> Int -> Expr -> Sems Type
notType li co expr = exprType expr >>= \case
  BoolT -> right BoolT
  _     -> left $ errPos li co ++ nonBoolAfErr ++ "not"

-- to check if func/proc with forward is defined
checkBoolExpr :: Expr -> String -> Sems ()
checkBoolExpr expr stmtDesc = do
  et <- exprType expr
  if et == BoolT then return ()
  else left $ nonBoolErr ++ stmtDesc

checkGoTo :: Id -> Sems ()
checkGoTo id = do
  lm <- getLabelMap
  case lookup id lm of
    Just _  -> return ()
    Nothing -> errAtId undefLabErr id

checkId :: Id -> Sems ()
checkId id = do
  (e,st:sts) <- get
  case lookup id $ labelMap st of
    Just False -> put $ (e,st { labelMap = insert id True $ labelMap st }:sts)
    Just True  -> errAtId dupLabErr id
    Nothing    -> errAtId undefLabErr id

checkpointer :: LVal -> Error -> Sems Type
checkpointer lVal err = lValType lVal >>= \case
  Pointer t -> return t
  _          -> left err

callSems :: Id -> Exprs -> Sems ()
callSems id exprs =
  get >>= snd >>> searchCallableInSymTabs id (errAtId callErr id) >>= \t ->
  callSem id t exprs

ifThenSems :: Int -> Int -> Expr -> Stmt -> Sems ()
ifThenSems li co expr stmt = do
  checkBoolExpr expr (errPos li co ++ "if-then")
  stmtSems stmt

ifThenElseSems :: Int -> Int -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseSems li co expr s1 s2 = do
  checkBoolExpr expr (errPos li co ++ "if-then-else")
  stmtSems s1
  stmtSems s2

whileSems :: Int -> Int -> Expr -> Stmt -> Sems ()
whileSems li co expr stmt = do
  checkBoolExpr expr (errPos li co ++ "while")
  stmtSems stmt

newSems :: Int -> Int -> New -> LVal -> Sems ()
newSems li co new lVal = do
  insToNewMap lVal ()
  t <- checkpointer lVal $ errPos li co ++ nonPointNewErr
  case (new,checkFullType t) of
    (NewEmpty,True)   -> return ()
    (NewExpr e,False) -> exprType e >>= \case
      IntT -> return ()
      _    -> left $ errPos li co ++ nonIntNewErr
    _ -> left $ errPos li co ++ badPointNewErr

disposeSems :: Int -> Int -> DispType -> LVal -> Sems ()
disposeSems li co disptype lVal = do
  (e,st:sts) <- get
  newnm <- deleteNewMap lVal (newMap st) $ errPos li co ++ dispNullPointErr
  put $ (e,st:sts)
  t <- checkpointer lVal $ errPos li co ++ dispNonPointErr
  case (disptype,checkFullType t) of
    (With,False)   -> return ()
    (Without,True) -> return ()
    _ -> left $ errPos li co ++ badPointDispErr

deleteNewMap :: LVal -> NewMap -> String -> Sems NewMap
deleteNewMap l nm errmsg = case lookup l nm of
  Nothing -> left errmsg
  _       -> right $ delete l nm

callSem :: Id -> Callable -> Exprs -> Sems ()
callSem id = \case
  ProcDeclaration as -> formalsExprsMatch id as
  Proc  as           -> formalsExprsMatch id as
  _                  -> \_ -> errAtId callSemErr id

errorAtArg err i (Id str li co) = errPos li co ++ err i str
