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
import HeaderSems (headerSems)

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
bodySems (Body locals (Block statements)) = do
  localsSems $ reverse locals
  stmtsSems $ reverse statements
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
  headerSems h
  sms <- get
  put $ emptySymbolTable:sms
  headArgsF h
  bodySems b
  checkresult h
  put sms

headArgsF :: Header -> Sems ()
headArgsF = \case
  ProcHeader _ formals    -> insertArgsInTm formals
  FuncHeader _ formals ty -> insertArgsInTm formals >> insertResult ty

insertResult :: Type -> Sems ()
insertResult t = insToVariableMap (dummy "result") t

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = concat . map formalToType

formalToType :: Formal -> [(PassBy,Type)]
formalToType (pb,in1,myt) = map (\_ -> (pb,myt)) in1

checkresult :: Header -> Sems ()
checkresult = \case
  FuncHeader i _ _ -> checkresultById i
  _              -> return ()

checkresultById :: Id -> Sems ()
checkresultById i = do
  vm <- getVariableMap
  case lookup (dummy "while") vm of
    Nothing -> errAtId noResInFunErr i
    _       -> return ()

insertArgsInTm :: [Formal] -> Sems ()
insertArgsInTm = mapM_ insertFormalInTm

insertFormalInTm :: Formal -> Sems ()
insertFormalInTm (_,ids,t) = mapM_ (insertIdInTm' t) ids

insertIdInTm' :: Type -> Id -> Sems ()
insertIdInTm' ty id = afterIdLookup ty id . lookup id =<< getVariableMap 

afterIdLookup ty id = \case
  Nothing -> insToVariableMap id ty 
  _       -> errAtId dupArgErr id

insertIdInTm :: Type -> Id -> Sems ()
insertIdInTm t id = do
  st:sts <- get
  case lookup id $ variableMap st of
    Nothing -> put $ st { variableMap = insert id t $ variableMap st }:sts
    _       -> errAtId dupArgErr id

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

stmtsSems :: Stmts -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

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

checkpointer :: LValue -> Error -> Sems Type
checkpointer lValue err = lValueType lValue >>= \case
  PointerT t -> return t
  _          -> left err

equalStmtSems :: Int -> Int -> LValue -> Expr -> Sems ()
equalStmtSems line column lValue expression = case lValue of
  LString _ -> left $ strAssErr ++ errPos line column
  _         -> do
    lt <- lValueType lValue
    et <- exprType  expression
    if symbatos lt et then return ()
    else left $ assTypeMisErr ++ errPos line column

callStmtSems :: Id -> Exprs -> Sems ()
callStmtSems id expressions = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> callSem id t $ reverse expressions
    Nothing -> errAtId callErr id

ifThenStmtSems :: Int -> Int -> Expr -> Stmt -> Sems ()
ifThenStmtSems line column expression statement = do
  checkBoolExpr expression ("if-then" ++ errPos line column)
  stmtSems statement

ifThenElseStmtSems :: Int -> Int -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseStmtSems li co expr s1 s2 = do
  checkBoolExpr expr ("if-then-else" ++ errPos li co)
  stmtSems s1
  stmtSems s2

whileStmtSems :: Int -> Int -> Expr -> Stmt -> Sems ()
whileStmtSems li co expr stmt = do
  checkBoolExpr expr ("while" ++ errPos li co)
  stmtSems stmt

newStmtSems :: Int -> Int -> New -> LValue -> Sems ()
newStmtSems li co new lVal = do
  modify ( \(st:sts) -> st { newMap = insert lVal () $ newMap st } : sts )
  t <- checkpointer lVal $ nonPointNewErr ++ errPos li co
  case (new,checkFullType t) of
    (NewEmpty,True)   -> return ()
    (NewExpr e,False) -> exprType e >>= \case
      Tint -> return ()
      _    -> left $ nonIntNewErr ++ errPos li co
    _ -> left $ badPointNewErr ++ errPos li co

disposeStmtSems :: Int -> Int -> DispType -> LValue -> Sems ()
disposeStmtSems li co disptype lVal = do
  st:sts <- get
  newnm <- deleteNewMap lVal (newMap st) $ dispNullPointErr ++ errPos li co
  put $ st:sts
  t <- checkpointer lVal $ dispNonPointErr ++ errPos li co
  case (disptype,checkFullType t) of
    (With,False)   -> return ()
    (Without,True) -> return ()
    _ -> left $ badPointDispErr ++ errPos li co

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  SEmpty                         -> return ()
  SEqual (li,co) lValue expr     -> equalStmtSems li co lValue expr
  SBlock (Block ss)              -> stmtsSems $ reverse ss
  SCall (CId id exprs)           -> callStmtSems id exprs
  SIT  (li,co) expr stmt         -> ifThenStmtSems li co expr stmt
  SITE (li,co) expr s1 s2        -> ifThenElseStmtSems li co expr s1 s2
  SWhile (li,co) expr stmt       -> whileStmtSems li co expr stmt
  SId id stmt                    -> checkId id >> stmtSems stmt
  GoToStatement id               -> checkGoTo id
  SReturn                        -> return ()
  SNew (li,co) new lVal          -> newStmtSems li co new lVal
  SDispose (li,co) disptype lVal -> disposeStmtSems li co disptype lVal

deleteNewMap :: LValue -> NewMap -> String -> Sems NewMap
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
  L lval -> lValueType lval
  R rval -> rValueType rval

lValueType :: LValue -> Sems Type
lValueType = \case
  LId id                         -> idLValueType id
  LResult (li,co)                -> resultLValueType li co
  LString string                 -> right $ ArrayT NoSize Tchar
  LValueExpr (li,co) lValue expr -> lValueExprLValueType li co lValue expr
  LExpr (li,co) expr             -> exprLValueType li co expr
  LParen lValue                  -> lValueType lValue

idLValueType :: Id -> Sems Type
idLValueType id = do
  sms <- get
  case searchVarSMs id sms of
    Just t  -> return t
    Nothing -> errAtId varErr id

resultLValueType :: Int -> Int -> Sems Type
resultLValueType li co = do
  st:sts <- get
  case lookup (dummy "result") (variableMap st) of
    Just v  ->
      put ( st { variableMap = insert (dummy "while") v $ variableMap st }:sts )
      >> return v
    Nothing -> left $ resultNoFunErr ++ errPos li co

lValueExprLValueType :: Int -> Int -> LValue -> Expr -> Sems Type
lValueExprLValueType li co lValue expr = exprType expr >>= \case
  Tint -> lValueType lValue >>= \case
    ArrayT _ t -> right t
    _          -> left $ arrErr ++ errPos li co
  _    -> left $ indErr ++ errPos li co

exprLValueType :: Int -> Int -> Expr -> Sems Type 
exprLValueType li co expr =  exprType expr >>= \case
  PointerT t -> right t
  _          -> left $ pointErr ++ errPos li co

checkposneg :: (Int,Int) -> Expr -> String -> Sems Type
checkposneg (li,co) expr a = exprType expr >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errPos li co

checkarithmetic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkarithmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errPos li co
  Treal -> exprType exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errPos li co
  _     -> left $ nonNumBefErr ++ a ++ errPos li co

checkinthmetic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkinthmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ nonIntAfErr ++ a ++ errPos li co
  _     -> left $ nonIntBefErr ++ a ++ errPos li co

checklogic :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checklogic (li,co) exp1 exp2 a = exprType exp1 >>= \case
    Tbool  -> exprType exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ nonBoolAfErr ++ a ++ errPos li co
    _     -> left $ nonBoolBefErr ++ a ++ errPos li co

checkcompare :: (Int,Int) -> Expr -> Expr -> String -> Sems Type
checkcompare (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> arithmeticbool exp2 (mismTypesErr ++ a ++ errPos li co) (right Tbool)
  Treal -> arithmeticbool exp2 (mismTypesErr ++ a ++ errPos li co) (right Tbool)
  Tbool -> exprType exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ mismTypesErr ++ a ++ errPos li co
  Tchar -> exprType exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ mismTypesErr ++ a ++ errPos li co
  PointerT _ -> pointersbool exp2 (mismTypesErr ++ a ++ errPos li co)
  Tnil       -> pointersbool exp2 (mismTypesErr ++ a ++ errPos li co)
  _     -> left $ mismTypesErr ++ a ++ errPos li co

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

rValueType :: RValue -> Sems Type
rValueType = \case
  RInt _                     -> right Tint
  RTrue                      -> right Tbool
  RFalse                     -> right Tbool
  RReal _                    -> right Treal
  RChar _                    -> right Tchar
  RParen rValue              -> rValueType rValue
  RNil                       -> right Tnil
  RCall (CId id exprs)       -> callRValueType id exprs
  RPapaki  posn lValue       -> lValueType lValue >>= right . PointerT
  RNot     (li,co) expr      -> notRValueType li co expr
  RPos     posn expr         -> checkposneg posn expr "'+'"
  RNeg     posn expr         -> checkposneg posn expr "'-'"
  RPlus    posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'+'"
  RMul     posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'*'"
  RMinus   posn exp1 exp2    -> checkarithmetic posn exp1 exp2 "'-'"
  RRealDiv (li,co) exp1 exp2 -> realDivRValueType li co exp1 exp2
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

callRValueType :: Id -> Exprs -> Sems Type
callRValueType id exprs = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> funCallSem id t $ reverse exprs
    Nothing -> errAtId callErr id

notRValueType :: Int -> Int -> Expr -> Sems Type
notRValueType li co expr = exprType expr >>= \case
  Tbool -> right Tbool
  _     -> left $ nonBoolAfErr ++ "not" ++ errPos li co

realDivRValueType :: Int -> Int -> Expr -> Expr -> Sems Type
realDivRValueType li co exp1 exp2 =
  arithmeticbool exp1 (nonNumBefErr ++ "'/'" ++ errPos li co)
  (arithmeticbool exp2 (nonNumAfErr ++ "'/'" ++ errPos li co)
                   (right Treal))

funCallSem :: Id -> Callable -> Exprs -> Sems Type
funCallSem id = \case
  FuncDeclaration as t -> \exprs -> goodArgs id as exprs >> right t
  Func  as t -> \exprs -> goodArgs id as exprs >> right t
  _          -> \_ -> errAtId callSemErr id

errorAtArg error i (Id string line column) =
  left $ error i string ++ errPos line column

argsExprsSems :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
argsExprsSems i id ((Value,t1):t1s) (t2:t2s)
  | symbatos t1 t2 = argsExprsSems (i+1) id t1s t2s
  | otherwise = errorAtArg badArgErr i id 
argsExprsSems i id ((Reference,t1):t1s) (t2:t2s)
  | symbatos (PointerT t1) (PointerT t2) = argsExprsSems (i+1) id t1s t2s
  | otherwise = errorAtArg badArgErr i id 
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ = errAtId argsExprsErr id
