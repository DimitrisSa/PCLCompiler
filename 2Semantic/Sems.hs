module Main where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import Common hiding (map)
import InitSymTab (initSymTab)
import VarsWithTypeListSems (varsWithTypeListSems)
import InsToSymTabLabels (insToSymTabLabels)
import ForwardSems (forwardSems)
import CheckUndefDeclarationSems (checkUndefDeclarationSems)
import CheckUnusedLabels (checkUnusedLabels)
import HeaderParentSems (headerParentSems)
import HeaderChildSems (headerChildSems)

-- same name of fun inside of other fun?
main :: IO ()
main = sems

sems :: IO ()
sems = parserErrOrAstSems . parser =<< getContents

parserErrOrAstSems :: Either Error Program -> IO ()
parserErrOrAstSems = \case 
  Left e -> die e
  Right ast -> astSems ast

astSems :: Program -> IO ()
astSems ast =
  let runProgramSems = evalState . runEitherT . programSems
  in case runProgramSems ast [emptySymbolTable] of
    Right _  -> hPutStrLn stdout "good" >> exitSuccess
    Left s   -> die s

programSems :: Program -> Sems ()
programSems (P _ body) = do
  initSymTab
  bodySems body

bodySems :: Body -> Sems ()
bodySems (Body locals (Stmts stmts)) = do
  localsSems $ reverse locals
  stmtsSems $ reverse stmts
  checkUnusedLabels

localsSems :: [Local] -> Sems ()
localsSems locals = do
  mapM_ localSems locals
  checkUndefDeclarationSems

localSems :: Local -> Sems ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSems $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySems h b
  Forward h             -> forwardSems h

headerBodySems :: Header -> Body -> Sems ()
headerBodySems h b = do
  headerParentSems h
  sms <- get
  put $ emptySymbolTable:sms
  headerChildSems h
  bodySems b
  checkresult h
  put sms

stmtsSems :: [Stmt] -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  Empty                             -> return ()
  Equal li co lVal expr             -> equalStmtSems li co expr lVal
  Block (Stmts ss)                  -> stmtsSems $ reverse ss
  CallStmt (CId id exprs)               -> callStmtSems id $ reverse exprs
  IfThenStmt  li co  expr stmt          -> ifThenStmtSems li co expr stmt
  IfThenElseStmt li co expr stmt1 stmt2 -> ifThenElseStmtSems li co expr stmt1 stmt2
  WhileStmt li co expr stmt             -> whileStmtSems li co expr stmt
  LabelStmt id stmt                     -> checkId id >> stmtSems stmt
  GoToStmt id                           -> checkGoTo id
  ReturnStmt                            -> return ()
  NewStmt li co new lVal                -> newStmtSems li co new lVal
  DisposeStmt li co disptype lVal       -> disposeStmtSems li co disptype lVal

equalStmtSems :: Int -> Int -> Expr -> LVal -> Sems ()
equalStmtSems li co expr = \case
  StrLiteral str -> left $ errPos li co ++ strAssignmentErr ++ str
  lVal           -> do
    lt <- lValType lVal
    et <- exprType expr
    if symbatos lt et then return ()
    else left $ errPos li co ++ assTypeMisErr

--symbatos' :: Type -> Type -> Error -> Sems ()
--symbatos' (PointerT (ArrayT NoSize t1)) (PointerT (ArrayT (Size _) t2)) = case t1 == t2 of
--  True -> return ()
--  _    -> left $ 
--symbatos' lt et = case (lt == et && checkFullType lt) || (lt == Treal && et == Tint) of
--  True -> return ()
--  _    ->

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = concat . map formalToType

formalToType :: Formal -> [(PassBy,Type)]
formalToType (pb,in1,myt) = map (\_ -> (pb,myt)) in1

checkresult :: Header -> Sems ()
checkresult = \case
  FuncHeader i _ _ -> checkresultById i
  _                -> return ()

checkresultById :: Id -> Sems ()
checkresultById i = checkresultById' i . lookup (dummy "while") =<< getVariableMap

checkresultById' :: Id -> Maybe Type -> Sems ()
checkresultById' i = \case
  Nothing -> errAtId noResInFunErr i
  _       -> return ()

-- to check if func/proc with forward is defined
searchCallSM :: Id -> SymbolTable -> Maybe Callable
searchCallSM id st = lookup id $ callableMap st

searchCallSMs1 :: Id -> [SymbolTable] -> Maybe Callable
searchCallSMs1 id = \case
  sm:sms -> searchCallSMs2 id sms $ searchCallSM id sm
  []     -> Nothing

searchCallSMs2 id sms = \case
  Nothing -> searchCallSMs1 id sms
  x       -> x

searchVarSMs :: Id -> [SymbolTable] -> Maybe Type
searchVarSMs id = \case
  sm:sms -> case searchVarSM id sm of
    Nothing -> searchVarSMs id sms
    x       -> x
  []     -> Nothing

searchVarSM :: Id -> SymbolTable -> Maybe Type
searchVarSM id st = lookup id $ variableMap st

checkBoolExpr :: Expr -> String -> Sems ()
checkBoolExpr expr stmtDesc = do
  et <- exprType expr
  if et == Tbool then return ()
  else left $ nonBoolErr ++ stmtDesc

checkGoTo :: Id -> Sems ()
checkGoTo id = do
  lm <- getLabelMap
  case lookup id lm of
    Just _  -> return ()
    Nothing -> errAtId undefLabErr id

checkId :: Id -> Sems ()
checkId id = do
  st:sts <- get
  case lookup id $ labelMap st of
    Just False -> put $ st { labelMap = insert id True $ labelMap st }:sts
    Just True  -> errAtId dupLabErr id
    Nothing    -> errAtId undefLabErr id

checkpointer :: LVal -> Error -> Sems Type
checkpointer lVal err = lValType lVal >>= \case
  PointerT t -> return t
  _          -> left err

callStmtSems :: Id -> Exprs -> Sems ()
callStmtSems id exprs = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> callSem id t exprs
    Nothing -> errAtId callErr id

ifThenStmtSems :: Int -> Int -> Expr -> Stmt -> Sems ()
ifThenStmtSems li co expr stmt = do
  checkBoolExpr expr (errPos li co ++ "if-then")
  stmtSems stmt

ifThenElseStmtSems :: Int -> Int -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseStmtSems li co expr s1 s2 = do
  checkBoolExpr expr (errPos li co ++ "if-then-else")
  stmtSems s1
  stmtSems s2

whileStmtSems :: Int -> Int -> Expr -> Stmt -> Sems ()
whileStmtSems li co expr stmt = do
  checkBoolExpr expr (errPos li co ++ "while")
  stmtSems stmt

newStmtSems :: Int -> Int -> New -> LVal -> Sems ()
newStmtSems li co new lVal = do
  modify ( \(st:sts) -> st { newMap = insert lVal () $ newMap st } : sts )
  t <- checkpointer lVal $ errPos li co ++ nonPointNewErr
  case (new,checkFullType t) of
    (NewEmpty,True)   -> return ()
    (NewExpr e,False) -> exprType e >>= \case
      Tint -> return ()
      _    -> left $ errPos li co ++ nonIntNewErr
    _ -> left $ errPos li co ++ badPointNewErr

disposeStmtSems :: Int -> Int -> DispType -> LVal -> Sems ()
disposeStmtSems li co disptype lVal = do
  st:sts <- get
  newnm <- deleteNewMap lVal (newMap st) $ errPos li co ++ dispNullPointErr
  put $ st:sts
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

goodArgs :: Id -> [Formal] -> Exprs -> Sems ()
goodArgs id as exprs =
  argsExprsSems 1 id (formalsToTypes as) =<< mapM exprType exprs

exprType :: Expr -> Sems Type
exprType = \case
  L lval -> lValType lval
  R rval -> rValType rval

lValType :: LVal -> Sems Type
lValType = \case
  LId id                         -> idLValType id
  LResult (li,co)                -> resultLValType li co
  StrLiteral str              -> right $ ArrayT (Size $ length str + 1) Tchar
  LValExpr (li,co) lVal expr -> lValExprLValType li co lVal expr
  LExpr (li,co) expr             -> exprLValType li co expr
  LParen lVal                  -> lValType lVal

idLValType :: Id -> Sems Type
idLValType id = do
  sms <- get
  case searchVarSMs id sms of
    Just t  -> return t
    Nothing -> errAtId varErr id

resultLValType :: Int -> Int -> Sems Type
resultLValType li co = do
  st:sts <- get
  case lookup (dummy "result") (variableMap st) of
    Just v  ->
      put ( st { variableMap = insert (dummy "while") v $ variableMap st }:sts )
      >> return v
    Nothing -> left $ errPos li co ++ resultNoFunErr

lValExprLValType :: Int -> Int -> LVal -> Expr -> Sems Type
lValExprLValType li co lVal expr = exprType expr >>= \case
  Tint -> lValType lVal >>= \case
    ArrayT _ t -> right t
    _          -> left $ errPos li co ++ arrErr
  _    -> left $ errPos li co ++ indErr

exprLValType :: Int -> Int -> Expr -> Sems Type 
exprLValType li co expr =  exprType expr >>= \case
  PointerT t -> right t
  _          -> left $ errPos li co ++ pointErr

checkposneg :: (Int,Int) -> Expr -> String -> Sems Type
checkposneg (li,co) expr a = exprType expr >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ errPos li co ++ nonNumAfErr ++ a

checkarithmetic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkarithmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ errPos li co ++ nonNumAfErr ++ a
  Treal -> exprType exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ errPos li co ++ nonNumAfErr ++ a
  _     -> left $ errPos li co ++ nonNumBefErr ++ a

checkinthmetic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkinthmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ errPos li co ++ nonIntAfErr ++ a
  _     -> left $ errPos li co ++ nonIntBefErr ++ a

checklogic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checklogic (li,co) exp1 exp2 a = exprType exp1 >>= \case
    Tbool  -> exprType exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ errPos li co ++ nonBoolAfErr ++ a
    _     -> left $ errPos li co ++ nonBoolBefErr ++ a

checkcompare :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkcompare (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> arithmeticbool exp2 (errPos li co ++ mismTypesErr ++ a) (right Tbool)
  Treal -> arithmeticbool exp2 (errPos li co ++ mismTypesErr ++ a) (right Tbool)
  Tbool -> exprType exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ errPos li co ++ mismTypesErr ++ a
  Tchar -> exprType exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ errPos li co ++ mismTypesErr ++ a
  PointerT _ -> pointersbool exp2 (errPos li co ++ mismTypesErr ++ a)
  Tnil       -> pointersbool exp2 (errPos li co ++ mismTypesErr ++ a)
  _     -> left $ errPos li co ++ mismTypesErr ++ a

checknumcomp :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checknumcomp (li,co) exp1 exp2 a =
  arithmeticbool exp1 (nonNumBefErr ++ a)
  (arithmeticbool exp2 (nonNumAfErr ++ a) (right Tbool))

arithmeticbool :: Expr -> String -> Sems Type -> Sems Type
arithmeticbool expr errmsg f = exprType expr >>= \case
  Tint   -> f
  Treal  -> f
  _     -> left errmsg

pointersbool :: Expr -> String -> Sems Type
pointersbool expr a = exprType expr >>= \case
  PointerT _  -> right Tbool
  Tnil        -> right Tbool
  _           -> left a

rValType :: RVal -> Sems Type
rValType = \case
  RInt _                     -> right Tint
  RTrue                      -> right Tbool
  RFalse                     -> right Tbool
  RReal _                    -> right Treal
  RChar _                    -> right Tchar
  RParen rVal                -> rValType rVal
  RNil                       -> right Tnil
  RCall (CId id exprs)       -> callRValType id exprs
  RPapaki  posn lVal         -> lValType lVal >>= right . PointerT
  RNot     (li,co) expr      -> notRValType li co expr
  RPos     posn expr         -> checkposneg posn expr "'+'"
  RNeg     posn expr         -> checkposneg posn expr "'-'"
  RPlus    posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'+'"
  RMul     posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'*'"
  RMinus   posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'-'"
  RRealDiv (li,co) exp1 exp2 -> realDivRValType li co exp1 exp2
  RDiv     posn exp1 exp2    -> checkinthmetic posn exp1 exp2 "'div'"
  RMod     posn exp1 exp2    -> checkinthmetic posn exp1 exp2 "'mod'"
  ROr      posn exp1 exp2    -> checklogic   posn exp1 exp2 "'or'"
  RAnd     posn exp1 exp2    -> checklogic   posn exp1 exp2 "'and'"
  REq      posn exp1 exp2    -> checkcompare posn exp1 exp2 "'='"
  RDiff    posn exp1 exp2    -> checkcompare posn exp1 exp2 "'<>'"
  RLess    posn exp1 exp2    -> checknumcomp posn exp1 exp2 "'<'"
  RGreater posn exp1 exp2    -> checknumcomp posn exp1 exp2 "'>'"
  RGreq    posn exp1 exp2    -> checknumcomp posn exp1 exp2 "'>='"
  RSmeq    posn exp1 exp2    -> checknumcomp posn exp1 exp2 "'<='"

callRValType :: Id -> Exprs -> Sems Type
callRValType id exprs = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> funCallSem id t $ reverse exprs
    Nothing -> errAtId callErr id

notRValType :: Int -> Int -> Expr -> Sems Type
notRValType li co expr = exprType expr >>= \case
  Tbool -> right Tbool
  _     -> left $ errPos li co ++ nonBoolAfErr ++ "not"

realDivRValType :: Int -> Int -> Expr -> Expr -> Sems Type
realDivRValType li co exp1 exp2 =
  arithmeticbool exp1 (errPos li co ++ nonNumBefErr ++ "'/'")
  (arithmeticbool exp2 (errPos li co ++ nonNumAfErr ++ "'/'")
                   (right Treal))

funCallSem :: Id -> Callable -> Exprs -> Sems Type
funCallSem id = \case
  FuncDeclaration as t -> \exprs -> goodArgs id as exprs >> right t
  Func  as t -> \exprs -> goodArgs id as exprs >> right t
  _          -> \_ -> errAtId callSemErr id

errorAtArg error i (Id str li co) =
  left $ errPos li co ++ error i str

argsExprsSems :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
argsExprsSems i id ((Value,t1):t1s) (t2:t2s)
  | symbatos t1 t2 = argsExprsSems (i+1) id t1s t2s
  | otherwise = errorAtArg badArgErr i id 
argsExprsSems i id ((Reference,t1):t1s) (t2:t2s)
  | symbatos (PointerT t1) (PointerT t2) = argsExprsSems (i+1) id t1s t2s
  | otherwise = errorAtArg badArgErr i id 
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ = errAtId argsExprsErr id
