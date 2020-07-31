module Main where
import SemTypes
import Parser as P
import Control.Monad.State
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import SemErrors
import qualified Data.Map as M

-- same name of fun inside of other fun?
main :: IO ()
main = semantics

semantics :: IO ()
semantics = getContents >>= parserErrorOrAstSemantics . parser 

parserErrorOrAstSemantics :: Either Error Program -> IO ()
parserErrorOrAstSemantics = \case 
  Left e -> die e
  Right ast -> astSemantics ast

astSemantics :: Program -> IO ()
astSemantics ast =
  let runProgramSemantics = evalState . runEitherT . programSemantics
  in case runProgramSemantics ast [emptySymbolTable]  of
  Right _  -> hPutStrLn stdout "good" >> exitSuccess
  Left s   -> die s

programSemantics :: Program -> Semantics ()
programSemantics (P _ body) = initSymbolTable >> bodySemantics body

bodySemantics :: Body -> Semantics ()
bodySemantics (Body locals (Block statements)) = do
  localsSemantics $ reverse locals
  statementsSemantics $ reverse statements
  checkUnusedLabels

checkUnusedLabels :: Semantics ()
checkUnusedLabels = getLabelMap >>= checkFalseLabelValueInList . M.toList

checkFalseLabelValueInList :: [(Id,Bool)] -> Semantics ()
checkFalseLabelValueInList = mapM_ $ \case
  (id,False) -> errAtId unusedLabelErr id
  _          -> return ()

errAtId :: String -> Id -> Semantics a
errAtId err (Id string line column) = left $ concat [err,string,errorend line column]

getVariableMap :: Semantics VariableMap
getVariableMap = get >>= return . variableMap . head

getLabelMap :: Semantics LabelMap
getLabelMap = get >>= return . labelMap . head

getCallableMap :: Semantics CallableMap
getCallableMap = get >>= return . callableMap . head

-- process locals + unimplemented forward
localsSemantics :: [Local] -> Semantics ()
localsSemantics locals = do
  mapM_ localSemantics locals
  checkUndefinedDeclaredCallable

-- check functions that are declared but not defined
checkUndefinedDeclaredCallable :: Semantics ()
checkUndefinedDeclaredCallable =
  getCallableMap >>= checkUndefinedDeclaredCallableCMList . M.toList 

checkUndefinedDeclaredCallableCMList :: [(Id,Callable)] -> Semantics ()
checkUndefinedDeclaredCallableCMList = \case
  (id,ProcedureDeclaration _  ):_ -> errAtId forwardErr id
  (id,FunctionDeclaration _ _):_ -> errAtId forwardErr id
  _:cml            -> checkUndefinedDeclaredCallableCMList cml
  []               -> return ()

-- Pattern match and call appropriate fun
localSemantics :: Local -> Semantics ()
localSemantics = \case
  LoVar vars     -> toSems vars
  LoLabel labels -> insertLabels labels
  LoHeadBod h b  -> headBodF h b
  LoForward h    -> forwardF h

insertLabels :: Ids -> Semantics ()
insertLabels = mapM_ insertLabel

insertLabel :: Id -> Semantics ()
insertLabel l = do
  st:sts <- get
  case M.lookup l $ labelMap st of
    Just _  -> errAtId dupLabDecErr l
    Nothing -> put $ st { labelMap = M.insert l False $ labelMap st }:sts

-- headerSems + newSymTab + argsInNewSymTab + bodySemantics + 
-- existsResult
headBodF :: Header -> Body -> Semantics ()
headBodF h bod = do
  headF h
  sms <- get
  put $ emptySymbolTable:sms
  headArgsF h
  bodySemantics bod
  checkresult h
  put sms

checkresult :: Header -> Semantics ()
checkresult = \case
  FunctionHeader i _ _ -> checkresultById i
  _              -> return ()

checkresultById :: Id -> Semantics ()
checkresultById i = do
  vm <- getVariableMap
  case M.lookup (dummy "while") vm of
    Nothing -> errAtId noResInFunErr i
    _       -> return ()

headArgsF :: Header -> Semantics ()
headArgsF = \case
  ProcedureHeader _ a   -> insertArgsInTm a
  FunctionHeader  _ a t -> insertArgsInTm a >> insertResult t

insertResult :: P.Type -> Semantics ()
insertResult t = do
  modify (\(st:sts) ->
    st { variableMap = M.insert (dummy "result") t $ variableMap st }:sts) 

insertArgsInTm :: Args -> Semantics ()
insertArgsInTm = mapM_ insertFormalInTm

insertFormalInTm :: Formal -> Semantics ()
insertFormalInTm (_,ids,t) = mapM_ (insertIdInTm t) ids

insertIdInTm :: P.Type -> Id -> Semantics ()
insertIdInTm t id = do
  st:sts <- get
  case M.lookup id $ variableMap st of
    Nothing -> put $ st { variableMap = M.insert id t $ variableMap st }:sts
    _       -> errAtId dupArgErr id

-- to check if func/proc with forward is defined
insertheader :: Id -> Callable -> Bool -> Semantics ()
insertheader i t expr = do
  st:sts <- get
  if expr then put $ st { callableMap = M.insert i t $ callableMap st }:sts
  else errAtId parErr i

searchCallSMs1 :: Id -> [SymbolTable] -> Maybe Callable
searchCallSMs1 id = \case
  sm:sms -> searchCallSMs2 id sms $ searchCallSM id sm
  []     -> Nothing

searchCallSMs2 id sms = \case
  Nothing -> searchCallSMs1 id sms
  x       -> x

searchCallSM :: Id -> SymbolTable -> Maybe Callable
searchCallSM id st = M.lookup id $ callableMap st

searchVarSMs :: Id -> [SymbolTable] -> Maybe P.Type
searchVarSMs id = \case
  sm:sms -> case searchVarSM id sm of
    Nothing -> searchVarSMs id sms
    x       -> x
  []     -> Nothing

searchVarSM :: Id -> SymbolTable -> Maybe P.Type
searchVarSM id st = M.lookup id $ variableMap st

sameTypes a b = (\[a,b] -> a == b) $ map formalsToTypes [a,b]

headProcedureF :: Id -> Args -> [SymbolTable] -> Semantics ()
headProcedureF i a sms =
  let a' = reverse a in
  case searchCallSM i (head sms) of
    Just (ProcedureDeclaration b) -> insertheader i (Procedure a') $ sameTypes a' b
    Nothing        -> checkArgsAndPut i a' $ Procedure a'
    _              -> errAtId dupProcErr i

headFunctionF :: Id -> Args -> P.Type -> [SymbolTable] -> Semantics ()
headFunctionF i a t sms =
  let a' = reverse a in
  case searchCallSM i (head sms) of
    Just (FunctionDeclaration b t2) -> insertheader i (Function a' t) (t==t2 && sameTypes a' b)
    Nothing -> headFunFNothing t i a'
    _       -> errAtId dupFunErr i

headFunFNothing t i a = case t of
  ArrayT _ _ -> errAtId funErr i
  _          -> checkArgsAndPut i a $ Function a t

headF :: Header -> Semantics ()
headF h = get >>= \sms -> case h of
  ProcedureHeader i a   -> headProcedureF i a sms
  FunctionHeader  i a t -> headFunctionF i a t sms

checkArgsAndPut :: Id -> Args -> Callable -> Semantics ()
checkArgsAndPut i as t = do
  st:sts <- get
  if all argOk as then put $ st { callableMap = M.insert i t $ callableMap st }:sts 
  else errAtId arrByValErr i

argOk :: Formal -> Bool
argOk = \case
  (Value,_,ArrayT _ _) -> False
  _                    -> True

insertforward :: Id -> Args -> Callable -> Semantics ()
insertforward i as t = do
  sms <- get
  case searchCallSM i (head sms) of
    Just _ -> errAtId dupErr i
    Nothing -> checkArgsAndPut i as t

forwardF :: Header -> Semantics ()
forwardF h = case h of
  ProcedureHeader i a   -> insertforward i a (ProcedureDeclaration $ reverse a)
  FunctionHeader  i a t -> case t of
    ArrayT _ _ -> errAtId funErr i
    _          -> insertforward i a (FunctionDeclaration (reverse a) t)

toSems :: Variables -> Semantics ()
toSems = mapM_ (myinsert . makelist) . reverse

makelist :: (Ids,Type) -> [(Id,Type)]
makelist (in1,myt) = Prelude.map (\x -> (x,myt)) $ reverse in1

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = concat . map makelisthelp

makelisthelp :: Formal -> [(PassBy,Type)]
makelisthelp (pb,in1,myt) = Prelude.map (\_ -> (pb,myt)) in1

myinsert :: [(Id,Type)] -> Semantics ()
myinsert ((v,t):xs) = do
  st:sts <- get
  case M.lookup v $ variableMap st of
    Just _  -> errAtId dupErr v
    Nothing -> if checkFullType t then
                 put (st { variableMap = M.insert v t $ variableMap st }:sts) >> 
                 myinsert xs
               else errAtId arrayOfErr v
myinsert [] = return ()

statementsSemantics :: Stmts -> Semantics ()
statementsSemantics ss = mapM_ fstatement ss

checkBoolExpr :: Expr -> String -> Semantics ()
checkBoolExpr expr stmtDesc = do
  et <- totype expr
  if et == Tbool then return ()
  else left $ nonBoolErr ++ stmtDesc

checkGoTo :: Id -> Semantics ()
checkGoTo id = do
  lm <- getLabelMap
  case M.lookup id lm of
    Just _  -> return ()
    Nothing -> errAtId undefLabErr id

checkId :: Id -> Semantics ()
checkId id = do
  st:sts <- get
  case M.lookup id $ labelMap st of
    Just False -> put $ st { labelMap = M.insert id True $ labelMap st }:sts
    Just True  -> errAtId dupLabErr id
    Nothing    -> errAtId undefLabErr id

checkpointer :: LValue -> Error -> Semantics P.Type
checkpointer lValue err = totypel lValue >>= \case
  PointerT t -> return t
  _          -> left err

fstatement :: Stmt -> Semantics ()
fstatement = \case
  SEmpty                   -> return ()
  SEqual (li,co) lValue expr       -> case lValue of
    LString _ -> left $ strAssErr ++ errorend li co
    _         -> do
      lt <- totypel lValue
      et <- totype  expr
      if symbatos lt et then return ()
      else left $ assTypeMisErr ++ errorend li co
  SBlock (Block ss)           -> statementsSemantics $ reverse ss
  SCall (CId id exprs)     -> do
                              sms <- get
                              case searchCallSMs1 id sms of
                                Just t  -> callSem id t $
                                           reverse exprs
                                Nothing -> errAtId callErr id
  SIT  (li,co) expr stmt -> checkBoolExpr expr ("if-then" ++ errorend li co) >>
                              fstatement stmt
  SITE (li,co) expr s1 s2 -> checkBoolExpr expr ("if-then-else" ++ errorend li co)
                              >> fstatement s1 >> fstatement s2
  SWhile (li,co) expr stmt -> checkBoolExpr expr ("while" ++ errorend li co) >>
                              fstatement stmt
  SId id stmt              -> checkId   id >> fstatement stmt
  GoToStatement id                 -> checkGoTo id
  SReturn                  -> return ()
  SNew (li,co) new lVal          -> do
    modify ( \(st:sts) -> st { newMap = M.insert lVal () $ newMap st } : sts )
    t <- checkpointer lVal $ nonPointNewErr ++ errorend li co
    case (new,checkFullType t) of
      (NewEmpty,True)   -> return ()
      (NewExpr e,False) -> totype e >>= \case
        Tint -> return ()
        _    -> left $ nonIntNewErr ++ errorend li co
      _ -> left $ badPointNewErr ++ errorend li co
  SDispose (li,co) disptype lVal -> do
    sts <- get
    newnm <- deleteNewMap lVal (newMap $ head sts) $ dispNullPointErr ++ errorend li co
    put sts
    t <- checkpointer lVal $ dispNonPointErr ++ errorend li co
    case (disptype,checkFullType t) of
      (With,False)   -> return ()
      (Without,True) -> return ()
      _ -> left $ badPointDispErr ++ errorend li co

deleteNewMap :: LValue -> NewMap -> String -> Semantics NewMap
deleteNewMap l nm errmsg = case M.lookup l nm of
  Nothing -> left errmsg
  _       -> right $ M.delete l nm

checkFullType :: P.Type -> Bool
checkFullType = \case
  ArrayT NoSize _ -> False
  _               -> True

symbatos :: P.Type -> P.Type -> Bool
symbatos (PointerT (ArrayT NoSize t1))
         (PointerT (ArrayT (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) ||
                 (lt == Treal && et == Tint)

callSem :: Id -> Callable -> Exprs -> Semantics ()
callSem id = \case
  ProcedureDeclaration as -> goodArgs id as
  Procedure  as -> goodArgs id as
  _        -> \_ -> errAtId callSemErr id

goodArgs :: Id -> Args -> Exprs -> Semantics ()
goodArgs id as exprs =
  mapM forcalltype exprs >>=
  argsExprsSems 1 id (formalsToTypes as)

forcalltype :: Expr -> Semantics (PassBy,Type)
forcalltype = \case
  L lval -> totypel lval >>= \a -> return (Reference,a)
  R rval -> totyper rval >>= \b -> return (Value,b)

totype :: Expr -> Semantics P.Type
totype = \case
  L lval -> totypel lval
  R rval -> totyper rval

totypel :: LValue -> Semantics P.Type
totypel = \case
  LId id                 -> do
    sms <- get
    case searchVarSMs id sms of
      Just t  -> return t
      Nothing -> errAtId varErr id
  LResult (li,co)        -> do
    st:sts <- get
    case M.lookup (dummy "result") (variableMap st) of
      Just v  ->
        put ( st { variableMap = M.insert (dummy "while") v $ variableMap st }:sts )
        >> return v
      Nothing -> left $ resultNoFunErr ++ errorend li co
  LString string         -> right $ ArrayT NoSize Tchar
  LValueExpr (li,co) lValue expr -> totype expr >>= \case
    Tint -> totypel lValue >>= \case
      ArrayT _ t -> right t
      _          -> left $ arrErr ++ errorend li co
    _    -> left $ indErr ++ errorend li co
  LExpr (li,co) expr     -> totype expr >>= \case
    PointerT t -> right t
    _          -> left $ pointErr ++ errorend li co
  LParen lValue          -> totypel lValue

checkposneg :: (Int,Int) -> Expr -> String -> Semantics P.Type
checkposneg (li,co) expr a = totype expr >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorend li co

checkarithmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkarithmetic (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorend li co
  Treal -> totype exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ nonNumAfErr ++ a ++ errorend li co
  _     -> left $ nonNumBefErr ++ a ++ errorend li co

checkinthmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkinthmetic (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ nonIntAfErr ++ a ++ errorend li co
  _     -> left $ nonIntBefErr ++ a ++ errorend li co

checklogic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checklogic (li,co) exp1 exp2 a = totype exp1 >>= \case
    Tbool  -> totype exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ nonBoolAfErr ++ a ++ errorend li co
    _     -> left $ nonBoolBefErr ++ a ++ errorend li co

checkcompare :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkcompare (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> arithmeticbool exp2 (mismTypesErr ++ a ++ errorend li co) (right Tbool)
  Treal -> arithmeticbool exp2 (mismTypesErr ++ a ++ errorend li co) (right Tbool)
  Tbool -> totype exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ mismTypesErr ++ a ++ errorend li co
  Tchar -> totype exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ mismTypesErr++a ++ errorend li co
  PointerT _ -> pointersbool exp2 (mismTypesErr ++ a ++ errorend li co)
  Tnil       -> pointersbool exp2 (mismTypesErr ++ a ++ errorend li co)
  _     -> left $ mismTypesErr ++ a ++ errorend li co

checknumcomp :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checknumcomp (li,co) exp1 exp2 a =
  arithmeticbool exp1 (nonNumBefErr ++ a)
  (arithmeticbool exp2 (nonNumAfErr ++ a) (right Tbool))

--polymorphic function on what to do and
--  the error msg is used for all numeric
--comparisons and numeric functions
--  with one return type in case of correct
--semantic analysis
type SemType = Semantics P.Type
arithmeticbool :: Expr -> String -> SemType -> SemType
arithmeticbool expr errmsg f = totype expr >>= \case
  Tint   -> f
  Treal  -> f
  _     -> left errmsg

pointersbool :: Expr -> String -> Semantics P.Type
pointersbool expr a = totype expr >>= \case
  PointerT _  -> right Tbool
  Tnil        -> right Tbool
  _           -> left a

totyper :: RValue -> Semantics P.Type
totyper = \case
  RInt _              -> right Tint
  RTrue               -> right Tbool
  RFalse              -> right Tbool
  RReal _             -> right Treal
  RChar _             -> right Tchar
  RParen rValue       -> totyper rValue
  RNil                -> right Tnil
  RCall (CId id exprs) -> do
    sms <- get
    case searchCallSMs1 id sms of
      Just t  -> funCallSem id t $ reverse exprs
      Nothing -> errAtId callErr id
  RPapaki  posn lValue     -> totypel lValue >>=
                              right . PointerT
  RNot     (li,co) expr       -> totype expr >>= \case
    Tbool -> right Tbool
    _     -> left $ nonBoolAfErr ++ "not" ++ errorend li co
  RPos     posn expr       -> checkposneg posn expr "'+'"
  RNeg     posn expr       -> checkposneg posn expr "'-'"
  RPlus    posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'+'"
  RMul     posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'*'"
  RMinus   posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'-'"
  RRealDiv (li,co) exp1 exp2  ->
    arithmeticbool exp1 (nonNumBefErr ++ "'/'" ++ errorend li co)
    (arithmeticbool exp2 (nonNumAfErr ++ "'/'" ++ errorend li co)
                     (right Treal))
  RDiv     posn exp1 exp2  -> checkinthmetic posn exp1 exp2 "'div'"
  RMod     posn exp1 exp2  -> checkinthmetic posn exp1 exp2 "'mod'"
  ROr      posn exp1 exp2  -> checklogic   posn exp1 exp2 "'or'"
  RAnd     posn exp1 exp2  -> checklogic   posn exp1 exp2 "'and'"
  REq      posn exp1 exp2  -> checkcompare posn exp1 exp2 "'='"
  RDiff    posn exp1 exp2  -> checkcompare posn exp1 exp2 "'<>'"
  RLess    posn exp1 exp2  -> checknumcomp posn exp1 exp2 "'<'"
  RGreater posn exp1 exp2  -> checknumcomp posn exp1 exp2 "'>'"
  RGreq    posn exp1 exp2  -> checknumcomp posn exp1 exp2 "'>='"
  RSmeq    posn exp1 exp2  -> checknumcomp posn exp1 exp2 "'<='"

funCallSem :: Id -> Callable -> Exprs -> Semantics P.Type
funCallSem id = \case
  FunctionDeclaration as t -> \exprs -> goodArgs id as exprs >> right t
  Function  as t -> \exprs -> goodArgs id as exprs >> right t
  _          -> \_ -> errAtId callSemErr id

errAtArg err i (Id string line column) = left $ err i string ++ errorend line column

type PTs = [(PassBy,Type)]
argsExprsSems :: Int -> Id -> PTs -> PTs -> Semantics ()
argsExprsSems i id ((Reference,_):_) ((Value,_):_) =
    errAtArg refErr i id
argsExprsSems i id ((_,t1):t1s) ((_,t2):t2s)
  | symbatos t1 t2 = argsExprsSems (i+1) id t1s t2s
  | otherwise = errAtArg badArgErr i id 
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ = errAtId argsExprsErr id

--initialize Symbol Table with predefined procedures
initSymbolTable :: Semantics ()
initSymbolTable = do
  helpprocs "writeInteger" [(Value,[dummy "n"],Tint)]
  helpprocs "writeBoolean" [(Value,[dummy "b"],Tbool)]
  helpprocs "writeChar" [(Value,[dummy "c"],Tchar)]
  helpprocs "writeReal" [(Value,[dummy "r"],Treal)]
  helpprocs "writeString" [(Reference,
                           [dummy "s"],ArrayT NoSize Tchar)]
  helpfunc "readInteger" [] Tint
  helpfunc "readBoolean" [] Tbool
  helpfunc "readChar" [] Tchar
  helpfunc "readReal" [] Treal
  helpprocs "readString" [(Value,[dummy "size"],Tint),
                           (Reference,[dummy "s"],
                            ArrayT NoSize Tchar)]
  helpfunc "abs" [(Value,[dummy "n"],Tint)] Tint
  helpfunc "fabs" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "sqrt" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "sin" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "cos" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "tan" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "arctan" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "exp" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "ln" [(Value,[dummy "r"],Treal)] Treal
  helpfunc "pi" [] Treal
  helpfunc "trunc" [(Value,[dummy "r"],Treal)] Tint
  helpfunc "round" [(Value,[dummy "r"],Treal)] Tint
  helpfunc "ord" [(Value,[dummy "r"],Tchar)] Tint
  helpfunc "chr" [(Value,[dummy "r"],Tint)] Tchar
  return ()

dummy :: String -> Id
dummy s = Id s 0 0 

--helper function to insert the predefined procedures
--  to the symbol table
helpprocs :: String->Args->Semantics ()
helpprocs name myArgs = do
  modify (\(st:sts) ->
    st {
    callableMap = M.insert (dummy name) (Procedure myArgs) $ callableMap st }:sts) 

--helper function to insert
--  the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics ()
helpfunc name myArgs myType = do
  modify (\(st:sts) ->
    st {
    callableMap = M.insert (dummy name) (Function myArgs myType) $ callableMap st }:sts) 
