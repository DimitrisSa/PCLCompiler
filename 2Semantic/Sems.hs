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

-----
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
  _         -> left $ errPos li co ++ pointErr
-----

rValType :: RVal -> Sems Type
rValType = \case
  IntR _                  -> right IntT
  TrueR                   -> right BoolT
  FalseR                  -> right BoolT
  RealR _                 -> right RealT
  CharR _                 -> right CharT
  ParenR  rVal            -> rValType rVal
  NilR                    -> right Nil
  CallR   (id,exprs)      -> callRValType id $ reverse exprs
  Papaki  _ _ lVal        -> lValType lVal >>= Pointer >>> right
  Not     li co expr      -> notRValType li co expr
  Pos     li co expr      -> checkposneg li co expr "'+'"
  Neg     li co expr      -> checkposneg li co expr "'-'"
  Plus    li co exp1 exp2 -> checkarithmetic li co exp1 exp2 "'+'"
  Mul     li co exp1 exp2 -> checkarithmetic li co exp1 exp2 "'*'"
  Minus   li co exp1 exp2 -> checkarithmetic li co exp1 exp2 "'-'"
  RealDiv li co exp1 exp2 -> realDivRValType li co exp1 exp2
  Div     li co exp1 exp2 -> checkinthmetic li co exp1 exp2 "'div'"
  Mod     li co exp1 exp2 -> checkinthmetic li co exp1 exp2 "'mod'"
  Or      li co exp1 exp2 -> checklogic   li co exp1 exp2 "'or'"
  And     li co exp1 exp2 -> checklogic   li co exp1 exp2 "'and'"
  Eq      li co exp1 exp2 -> checkcompare li co exp1 exp2 "'='"
  Diff    li co exp1 exp2 -> checkcompare li co exp1 exp2 "'<>'"
  Less    li co exp1 exp2 -> checknumcomp li co exp1 exp2 "'<'"
  Greater li co exp1 exp2 -> checknumcomp li co exp1 exp2 "'>'"
  Greq    li co exp1 exp2 -> checknumcomp li co exp1 exp2 "'>='"
  Smeq    li co exp1 exp2 -> checknumcomp li co exp1 exp2 "'<='"

callRValType :: Id -> Exprs -> Sems Type
callRValType id exprs = 
  get >>= snd >>> searchCallableInSymTabs id (errAtId callErr id) >>= \cal ->
  funcCallSems id cal exprs

funcCallSems :: Id -> Callable -> Exprs -> Sems Type
funcCallSems id = \case
  FuncDeclaration as t -> \exprs -> goodArgs id as exprs >> right t
  Func  as t           -> \exprs -> goodArgs id as exprs >> right t
  _                    -> \_     -> errAtId callSemErr id

goodArgs :: Id -> [Formal] -> Exprs -> Sems ()
goodArgs id as exprs = mapM exprType exprs >>= argsExprsSems 1 id (formalsToTypes as)

argsExprsSems :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
argsExprsSems i id ((Value,t1):t1s) (t2:t2s) = argsExprsSems' i id t1 t2 t1s t2s
argsExprsSems i id ((Reference,t1):t1s) (t2:t2s) =
  argsExprsSems' i id (Pointer t1) (Pointer t2) t1s t2s
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ = errAtId argsExprsErr id

argsExprsSems' i id t1 t2 t1s t2s = do
  symbatos' t1 t2 $ errorAtArg badArgErr i id 
  argsExprsSems (i+1) id t1s t2s

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = map formalToType >>> concat

formalToType :: Formal -> [(PassBy,Type)]
formalToType (pb,in1,myt) = map (\_ -> (pb,myt)) in1

checkResult :: Sems ()
checkResult = getEnv >>= \case
  InFunc id _ False -> errAtId noResInFunErr id
  _                 -> return ()

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
  ProcDeclaration as -> goodArgs id as
  Proc  as -> goodArgs id as
  _        -> \_ -> errAtId callSemErr id

checkposneg :: Int -> Int -> Expr -> String -> Sems Type
checkposneg li co expr a = exprType expr >>= \case
    IntT  -> right IntT
    RealT -> right RealT
    _     -> left $ errPos li co ++ nonNumAfErr ++ a

checkarithmetic :: Int -> Int -> Expr -> Expr -> String -> Sems Type
checkarithmetic li co exp1 exp2 a = exprType exp1 >>= \case
  IntT  -> exprType exp2 >>= \case
    IntT  -> right IntT
    RealT -> right RealT
    _     -> left $ errPos li co ++ nonNumAfErr ++ a
  RealT -> exprType exp2 >>= \case
    RealT -> right RealT
    IntT  -> right RealT
    _     -> left $ errPos li co ++ nonNumAfErr ++ a
  _     -> left $ errPos li co ++ nonNumBefErr ++ a

checkinthmetic :: Int -> Int -> Expr -> Expr -> String -> Sems Type
checkinthmetic li co exp1 exp2 a = exprType exp1 >>= \case
  IntT  -> exprType exp2 >>= \case
    IntT  -> right IntT
    _     -> left $ errPos li co ++ nonIntAfErr ++ a
  _     -> left $ errPos li co ++ nonIntBefErr ++ a

checklogic :: Int -> Int -> Expr -> Expr -> String -> Sems Type
checklogic li co exp1 exp2 a = exprType exp1 >>= \case
    BoolT  -> exprType exp2 >>= \case
      BoolT  -> right BoolT
      _     -> left $ errPos li co ++ nonBoolAfErr ++ a
    _     -> left $ errPos li co ++ nonBoolBefErr ++ a

checkcompare :: Int -> Int -> Expr -> Expr -> String -> Sems Type
checkcompare li co exp1 exp2 a = exprType exp1 >>= \case
  IntT  -> arithmeticbool exp2 (errPos li co ++ mismTypesErr ++ a) (right BoolT)
  RealT -> arithmeticbool exp2 (errPos li co ++ mismTypesErr ++ a) (right BoolT)
  BoolT -> exprType exp2 >>= \case
    BoolT  -> right BoolT
    _      -> left $ errPos li co ++ mismTypesErr ++ a
  CharT -> exprType exp2 >>= \case
    CharT  -> right BoolT
    _      -> left $ errPos li co ++ mismTypesErr ++ a
  Pointer _ -> pointersbool exp2 (errPos li co ++ mismTypesErr ++ a)
  Nil       -> pointersbool exp2 (errPos li co ++ mismTypesErr ++ a)
  _     -> left $ errPos li co ++ mismTypesErr ++ a

checknumcomp :: Int -> Int -> Expr -> Expr -> String -> Sems Type
checknumcomp li co exp1 exp2 a =
  arithmeticbool exp1 (nonNumBefErr ++ a)
  (arithmeticbool exp2 (nonNumAfErr ++ a) (right BoolT))

arithmeticbool :: Expr -> String -> Sems Type -> Sems Type
arithmeticbool expr errmsg f = exprType expr >>= \case
  IntT   -> f
  RealT  -> f
  _     -> left errmsg

pointersbool :: Expr -> String -> Sems Type
pointersbool expr a = exprType expr >>= \case
  Pointer _  -> right BoolT
  Nil        -> right BoolT
  _           -> left a

notRValType :: Int -> Int -> Expr -> Sems Type
notRValType li co expr = exprType expr >>= \case
  BoolT -> right BoolT
  _     -> left $ errPos li co ++ nonBoolAfErr ++ "not"

realDivRValType :: Int -> Int -> Expr -> Expr -> Sems Type
realDivRValType li co exp1 exp2 =
  arithmeticbool exp1 (errPos li co ++ nonNumBefErr ++ "'/'")
  (arithmeticbool exp2 (errPos li co ++ nonNumAfErr ++ "'/'")
                   (right RealT))

errorAtArg err i (Id str li co) = errPos li co ++ err i str

