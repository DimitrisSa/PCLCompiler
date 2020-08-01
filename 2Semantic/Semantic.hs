module Main where
import Prelude hiding (lookup)
import SemTypes
import Parser 
import Control.Monad.State
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import SemErrs
import Data.Map hiding (map)

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

programSems :: Program -> Semantics ()
programSems (P _ body) = do
  initSymTab
  bodySems body

bodySems :: Body -> Semantics ()
bodySems (Body locals (Block statements)) = do
  localsSems $ reverse locals
  stmtsSems $ reverse statements
  checkUnusedLabels

checkUnusedLabels :: Semantics ()
checkUnusedLabels = checkFalseLabelValueInList . toList =<< getLabelMap

checkFalseLabelValueInList :: [(Id,Bool)] -> Semantics ()
checkFalseLabelValueInList = mapM_ $ \case
  (id,False) -> errAtId unusedLabelErr id
  _          -> return ()

errAtId :: String -> Id -> Semantics a
errAtId error (Id string line column) = errAtPosition error string line column

errAtPosition :: Error -> String -> Int -> Int -> Semantics a
errAtPosition error string line column =
  left $ concat [error,string,errorPosition line column]

getVariableMap :: Semantics VariableMap
getVariableMap = return . variableMap . head =<< get

getLabelMap :: Semantics LabelMap
getLabelMap = return . labelMap . head =<< get

getCallableMap :: Semantics CallableMap
getCallableMap = return . callableMap . head =<< get

localsSems :: [Local] -> Semantics ()
localsSems locals = do
  mapM_ localSems locals
  checkUndefinedDeclaration

checkUndefinedDeclaration :: Semantics ()
checkUndefinedDeclaration =  checkUndefinedDeclarationInList . toList =<< getCallableMap

checkUndefinedDeclarationInList :: [(Id,Callable)] -> Semantics ()
checkUndefinedDeclarationInList = \case
  (id,ProcDeclaration _  ):_ -> errAtId undefinedDeclarationErr id
  (id,FuncDeclaration _ _):_ -> errAtId undefinedDeclarationErr id
  _:l                        -> checkUndefinedDeclarationInList l
  []                         -> return ()

localSems :: Local -> Semantics ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSems $ reverse vwtl
  Labels ls             -> insertLabelsToSymTab $ reverse ls
  HeaderBody h b        -> headerBodySems h b
  Forward h             -> forwardSems h

varsWithTypeListSems :: [([Id],Type)] -> Semantics ()
varsWithTypeListSems = mapM_ insertVarsWithTypeToSymTab 

insertVarsWithTypeToSymTab :: ([Id],Type) -> Semantics ()
insertVarsWithTypeToSymTab (vars,ty) = mapM_ (insertVarWithTypeToSymTab ty) $ reverse vars
  
insertVarWithTypeToSymTab :: Type -> Id -> Semantics ()
insertVarWithTypeToSymTab ty var = afterVarLookup ty var . lookup var =<< getVariableMap

afterVarLookup :: Type -> Id -> Maybe Type -> Semantics ()
afterVarLookup ty var = \case 
  Just _  -> errAtId duplicateVariableErr var
  Nothing -> afterVarLookupOk ty var

afterVarLookupOk :: Type -> Id -> Semantics ()
afterVarLookupOk ty var = case checkFullType ty of
  True -> modify $ \(st:sts) -> st { variableMap = insert var ty $ variableMap st }:sts
  _    -> errAtId arrayOfDeclarationErr var

insertLabelsToSymTab :: [Id] -> Semantics ()
insertLabelsToSymTab = mapM_ insertLabelToSymTab

insertLabelToSymTab :: Id -> Semantics ()
insertLabelToSymTab label = afterlabelLookup label . lookup label =<< getLabelMap 

afterlabelLookup :: Id -> Maybe Bool -> Semantics ()
afterlabelLookup label = \case 
  Just _  -> errAtId duplicateLabelDeclarationErr label
  Nothing -> modify $ \(st:sts) -> st { labelMap = insert label False $ labelMap st }:sts

headerBodySems :: Header -> Body -> Semantics ()
headerBodySems h b = do
  headerSems h
  sms <- get
  put $ emptySymbolTable:sms
  headArgsF h
  bodySems b
  checkresult h
  put sms

headerSems :: Header -> Semantics ()
headerSems = \case
  ProcHeader id args    -> headerProcSems id (reverse args)
  FuncHeader id args ty -> headerFuncSems id (reverse args) ty

headerProcSems :: Id -> [Formal] -> Semantics ()
headerProcSems id args = afterProcIdLookup id args . lookup id =<< getCallableMap

afterProcIdLookup id args = \case
  Just (ProcDeclaration args') -> insertToSymTabIfGoodArgs id args args'
  Nothing                      -> checkArgsAndPut id args $ Proc args
  _                            -> errAtId dupplicateCallableErr id

insertToSymTabIfGoodArgs id args args' =
  insertToSymTabIfGood id (Proc args) $ sameTypes args args'

headerFuncSems :: Id -> [Formal] -> Type -> Semantics ()
headerFuncSems id args ty = afterFuncIdLookup id args ty . lookup id =<< getCallableMap

afterFuncIdLookup id args ty = \case
  Just (FuncDeclaration args' ty') -> insertToSymTabIfGoodArgsAndTy id args args' ty ty'
  Nothing                          -> headFunFNothing ty id args
  _                                -> errAtId dupplicateCallableErr id

insertToSymTabIfGoodArgsAndTy id args args' ty ty' = 
  insertToSymTabIfGood id (Func args ty) $ ty==ty' && sameTypes args args'

insertToSymTabIfGood :: Id -> Callable -> Bool -> Semantics ()
insertToSymTabIfGood id cal = \case
  True -> modify $ \(st:sts) -> st { callableMap = insert id cal $ callableMap st }:sts
  _    -> errAtId typeMismatchErr id

sameTypes :: [Formal] -> [Formal] -> Bool
sameTypes a b = (\[a,b] -> a == b) $ map formalsToTypes [a,b]

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = concat . map makelisthelp

makelisthelp :: Formal -> [(PassBy,Type)]
makelisthelp (pb,in1,myt) = map (\_ -> (pb,myt)) in1

checkresult :: Header -> Semantics ()
checkresult = \case
  FuncHeader i _ _ -> checkresultById i
  _              -> return ()

checkresultById :: Id -> Semantics ()
checkresultById i = do
  vm <- getVariableMap
  case lookup (dummy "while") vm of
    Nothing -> errAtId noResInFunErr i
    _       -> return ()

headArgsF :: Header -> Semantics ()
headArgsF = \case
  ProcHeader _ a   -> insertArgsInTm a
  FuncHeader  _ a t -> insertArgsInTm a >> insertResult t

insertResult :: Type -> Semantics ()
insertResult t = do
  modify (\(st:sts) ->
    st { variableMap = insert (dummy "result") t $ variableMap st }:sts) 

insertArgsInTm :: [Formal] -> Semantics ()
insertArgsInTm = mapM_ insertFormalInTm

insertFormalInTm :: Formal -> Semantics ()
insertFormalInTm (_,ids,t) = mapM_ (insertIdInTm t) ids

insertIdInTm :: Type -> Id -> Semantics ()
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

headFunFNothing t i a = case t of
  ArrayT _ _ -> errAtId funErr i
  _          -> checkArgsAndPut i a $ Func a t

checkArgsAndPut :: Id -> [Formal] -> Callable -> Semantics ()
checkArgsAndPut i as t = do
  st:sts <- get
  if all argOk as then put $ st { callableMap = insert i t $ callableMap st }:sts 
  else errAtId arrByValErr i

argOk :: Formal -> Bool
argOk = \case
  (Value,_,ArrayT _ _) -> False
  _                    -> True

insertforward :: Id -> [Formal] -> Callable -> Semantics ()
insertforward i as t = do
  sms <- get
  case searchCallSM i (head sms) of
    Just _ -> errAtId duplicateVariableErr i
    Nothing -> checkArgsAndPut i as t

forwardSems :: Header -> Semantics ()
forwardSems h = case h of
  ProcHeader i a   -> insertforward i a (ProcDeclaration $ reverse a)
  FuncHeader i a t -> case t of
    ArrayT _ _ -> errAtId funErr i
    _          -> insertforward i a (FuncDeclaration (reverse a) t)

stmtsSems :: Stmts -> Semantics ()
stmtsSems ss = mapM_ stmtSems ss

checkBoolExpr :: Expr -> String -> Semantics ()
checkBoolExpr expr stmtDesc = do
  et <- exprType expr
  if et == Tbool then return ()
  else left $ nonBoolErr ++ stmtDesc

checkGoTo :: Id -> Semantics ()
checkGoTo id = do
  lm <- getLabelMap
  case lookup id lm of
    Just _  -> return ()
    Nothing -> errAtId undefLabErr id

checkId :: Id -> Semantics ()
checkId id = do
  st:sts <- get
  case lookup id $ labelMap st of
    Just False -> put $ st { labelMap = insert id True $ labelMap st }:sts
    Just True  -> errAtId dupLabErr id
    Nothing    -> errAtId undefLabErr id

checkpointer :: LValue -> Error -> Semantics Type
checkpointer lValue err = lValueType lValue >>= \case
  PointerT t -> return t
  _          -> left err

equalStmtSems :: Int -> Int -> LValue -> Expr -> Semantics ()
equalStmtSems line column lValue expression = case lValue of
  LString _ -> left $ strAssErr ++ errorPosition line column
  _         -> do
    lt <- lValueType lValue
    et <- exprType  expression
    if symbatos lt et then return ()
    else left $ assTypeMisErr ++ errorPosition line column

callStmtSems :: Id -> Exprs -> Semantics ()
callStmtSems id expressions = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> callSem id t $ reverse expressions
    Nothing -> errAtId callErr id

ifThenStmtSems :: Int -> Int -> Expr -> Stmt -> Semantics ()
ifThenStmtSems line column expression statement = do
  checkBoolExpr expression ("if-then" ++ errorPosition line column)
  stmtSems statement

ifThenElseStmtSems :: Int -> Int -> Expr -> Stmt -> Stmt -> Semantics ()
ifThenElseStmtSems li co expr s1 s2 = do
  checkBoolExpr expr ("if-then-else" ++ errorPosition li co)
  stmtSems s1
  stmtSems s2

whileStmtSems :: Int -> Int -> Expr -> Stmt -> Semantics ()
whileStmtSems li co expr stmt = do
  checkBoolExpr expr ("while" ++ errorPosition li co)
  stmtSems stmt

newStmtSems :: Int -> Int -> New -> LValue -> Semantics ()
newStmtSems li co new lVal = do
  modify ( \(st:sts) -> st { newMap = insert lVal () $ newMap st } : sts )
  t <- checkpointer lVal $ nonPointNewErr ++ errorPosition li co
  case (new,checkFullType t) of
    (NewEmpty,True)   -> return ()
    (NewExpr e,False) -> exprType e >>= \case
      Tint -> return ()
      _    -> left $ nonIntNewErr ++ errorPosition li co
    _ -> left $ badPointNewErr ++ errorPosition li co

disposeStmtSems :: Int -> Int -> DispType -> LValue -> Semantics ()
disposeStmtSems li co disptype lVal = do
  st:sts <- get
  newnm <- deleteNewMap lVal (newMap st) $ dispNullPointErr ++ errorPosition li co
  put $ st:sts
  t <- checkpointer lVal $ dispNonPointErr ++ errorPosition li co
  case (disptype,checkFullType t) of
    (With,False)   -> return ()
    (Without,True) -> return ()
    _ -> left $ badPointDispErr ++ errorPosition li co

stmtSems :: Stmt -> Semantics ()
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

deleteNewMap :: LValue -> NewMap -> String -> Semantics NewMap
deleteNewMap l nm errmsg = case lookup l nm of
  Nothing -> left errmsg
  _       -> right $ delete l nm

checkFullType :: Type -> Bool
checkFullType = \case
  ArrayT NoSize _ -> False
  _               -> True

symbatos :: Type -> Type -> Bool
symbatos (PointerT (ArrayT NoSize t1)) (PointerT (ArrayT (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) || (lt == Treal && et == Tint)

callSem :: Id -> Callable -> Exprs -> Semantics ()
callSem id = \case
  ProcDeclaration as -> goodArgs id as
  Proc  as -> goodArgs id as
  _        -> \_ -> errAtId callSemErr id

goodArgs :: Id -> [Formal] -> Exprs -> Semantics ()
goodArgs id as exprs =
  mapM forcalltype exprs >>=
  argsExprsSems 1 id (formalsToTypes as)

forcalltype :: Expr -> Semantics (PassBy,Type)
forcalltype = \case
  L lval -> lValueType lval >>= \a -> return (Reference,a)
  R rval -> rValueType rval >>= \b -> return (Value,b)

exprType :: Expr -> Semantics Type
exprType = \case
  L lval -> lValueType lval
  R rval -> rValueType rval

lValueType :: LValue -> Semantics Type
lValueType = \case
  LId id                         -> idLValueType id
  LResult (li,co)                -> resultLValueType li co
  LString string                 -> right $ ArrayT NoSize Tchar
  LValueExpr (li,co) lValue expr -> lValueExprLValueType li co lValue expr
  LExpr (li,co) expr             -> exprLValueType li co expr
  LParen lValue                  -> lValueType lValue

idLValueType :: Id -> Semantics Type
idLValueType id = do
  sms <- get
  case searchVarSMs id sms of
    Just t  -> return t
    Nothing -> errAtId varErr id

resultLValueType :: Int -> Int -> Semantics Type
resultLValueType li co = do
  st:sts <- get
  case lookup (dummy "result") (variableMap st) of
    Just v  ->
      put ( st { variableMap = insert (dummy "while") v $ variableMap st }:sts )
      >> return v
    Nothing -> left $ resultNoFunErr ++ errorPosition li co

lValueExprLValueType :: Int -> Int -> LValue -> Expr -> Semantics Type
lValueExprLValueType li co lValue expr = exprType expr >>= \case
  Tint -> lValueType lValue >>= \case
    ArrayT _ t -> right t
    _          -> left $ arrErr ++ errorPosition li co
  _    -> left $ indErr ++ errorPosition li co

exprLValueType :: Int -> Int -> Expr -> Semantics Type 
exprLValueType li co expr =  exprType expr >>= \case
  PointerT t -> right t
  _          -> left $ pointErr ++ errorPosition li co

checkposneg :: (Int,Int) -> Expr -> String -> Semantics Type
checkposneg (li,co) expr a = exprType expr >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorPosition li co

checkarithmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics Type
checkarithmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorPosition li co
  Treal -> exprType exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorPosition li co
  _     -> left $ nonNumBefErr ++ a ++ errorPosition li co

checkinthmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics Type
checkinthmetic (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> exprType exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ nonIntAfErr ++ a ++ errorPosition li co
  _     -> left $ nonIntBefErr ++ a ++ errorPosition li co

checklogic :: (Int,Int) -> Expr -> Expr -> String -> Semantics Type
checklogic (li,co) exp1 exp2 a = exprType exp1 >>= \case
    Tbool  -> exprType exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ nonBoolAfErr ++ a ++ errorPosition li co
    _     -> left $ nonBoolBefErr ++ a ++ errorPosition li co

checkcompare :: (Int,Int) -> Expr -> Expr -> String -> Semantics Type
checkcompare (li,co) exp1 exp2 a = exprType exp1 >>= \case
  Tint  -> arithmeticbool exp2 (mismTypesErr ++ a ++ errorPosition li co) (right Tbool)
  Treal -> arithmeticbool exp2 (mismTypesErr ++ a ++ errorPosition li co) (right Tbool)
  Tbool -> exprType exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ mismTypesErr ++ a ++ errorPosition li co
  Tchar -> exprType exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ mismTypesErr ++ a ++ errorPosition li co
  PointerT _ -> pointersbool exp2 (mismTypesErr ++ a ++ errorPosition li co)
  Tnil       -> pointersbool exp2 (mismTypesErr ++ a ++ errorPosition li co)
  _     -> left $ mismTypesErr ++ a ++ errorPosition li co

checknumcomp :: (Int,Int) -> Expr -> Expr -> String -> Semantics Type
checknumcomp (li,co) exp1 exp2 a =
  arithmeticbool exp1 (nonNumBefErr ++ a)
  (arithmeticbool exp2 (nonNumAfErr ++ a) (right Tbool))

arithmeticbool :: Expr -> String -> Semantics Type -> Semantics Type
arithmeticbool expr errmsg f = exprType expr >>= \case
  Tint   -> f
  Treal  -> f
  _     -> left errmsg

pointersbool :: Expr -> String -> Semantics Type
pointersbool expr a = exprType expr >>= \case
  PointerT _  -> right Tbool
  Tnil        -> right Tbool
  _           -> left a

rValueType :: RValue -> Semantics Type
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

callRValueType :: Id -> Exprs -> Semantics Type
callRValueType id exprs = do
  sms <- get
  case searchCallSMs1 id sms of
    Just t  -> funCallSem id t $ reverse exprs
    Nothing -> errAtId callErr id

notRValueType :: Int -> Int -> Expr -> Semantics Type
notRValueType li co expr = exprType expr >>= \case
  Tbool -> right Tbool
  _     -> left $ nonBoolAfErr ++ "not" ++ errorPosition li co

realDivRValueType :: Int -> Int -> Expr -> Expr -> Semantics Type
realDivRValueType li co exp1 exp2 =
  arithmeticbool exp1 (nonNumBefErr ++ "'/'" ++ errorPosition li co)
  (arithmeticbool exp2 (nonNumAfErr ++ "'/'" ++ errorPosition li co)
                   (right Treal))

funCallSem :: Id -> Callable -> Exprs -> Semantics Type
funCallSem id = \case
  FuncDeclaration as t -> \exprs -> goodArgs id as exprs >> right t
  Func  as t -> \exprs -> goodArgs id as exprs >> right t
  _          -> \_ -> errAtId callSemErr id

errorAtArg error i (Id string line column) =
  left $ error i string ++ errorPosition line column

type PTs = [(PassBy,Type)]
argsExprsSems :: Int -> Id -> PTs -> PTs -> Semantics ()
argsExprsSems i id ((Reference,_):_) ((Value,_):_) =
    errorAtArg refErr i id
argsExprsSems i id ((_,t1):t1s) ((_,t2):t2s)
  | symbatos t1 t2 = argsExprsSems (i+1) id t1s t2s
  | otherwise = errorAtArg badArgErr i id 
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ = errAtId argsExprsErr id

--initialize Symbol Table with predefined procedures
initSymTab :: Semantics ()
initSymTab = do
  insertProcToSymTab "writeInteger" [(Value,[dummy "n"],Tint)]
  insertProcToSymTab "writeBoolean" [(Value,[dummy "b"],Tbool)]
  insertProcToSymTab "writeChar" [(Value,[dummy "c"],Tchar)]
  insertProcToSymTab "writeReal" [(Value,[dummy "r"],Treal)]
  insertProcToSymTab "writeString" [(Reference, [dummy "s"],ArrayT NoSize Tchar)]
  insertFuncToSymTab "readInteger" [] Tint
  insertFuncToSymTab "readBoolean" [] Tbool
  insertFuncToSymTab "readChar" [] Tchar
  insertFuncToSymTab "readReal" [] Treal
  insertProcToSymTab "readString" [(Value,[dummy "size"],Tint), (Reference,[dummy "s"],
                                   ArrayT NoSize Tchar)]
  insertFuncToSymTab "abs" [(Value,[dummy "n"],Tint)] Tint
  insertFuncToSymTab "fabs" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "sqrt" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "sin" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "cos" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "tan" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "arctan" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "exp" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "ln" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "pi" [] Treal
  insertFuncToSymTab "trunc" [(Value,[dummy "r"],Treal)] Tint
  insertFuncToSymTab "round" [(Value,[dummy "r"],Treal)] Tint
  insertFuncToSymTab "ord" [(Value,[dummy "r"],Tchar)] Tint
  insertFuncToSymTab "chr" [(Value,[dummy "r"],Tint)] Tchar

dummy :: String -> Id
dummy s = Id s 0 0 

insertProcToSymTab :: String -> [Formal] -> Semantics ()
insertProcToSymTab name myArgs = modify (\(st:sts) ->
  st { callableMap = insert (dummy name) (Proc myArgs) $ callableMap st }:sts) 

insertFuncToSymTab :: String -> [Formal] -> Type -> Semantics ()
insertFuncToSymTab name myArgs myType = modify (\(st:sts) ->
  st { callableMap = insert (dummy name) (Func myArgs myType) $ callableMap st }:sts) 
