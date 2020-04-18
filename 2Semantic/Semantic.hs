module Main where
import Parser
import Control.Monad.State
import Control.Monad.Trans.Either
import qualified Data.Map as M

data Callable =
  Proc Args          |
  Func Args Type     |
  FProc Args         |
  FFunc Args Type    
  deriving(Show,Eq)

type VarMap   = M.Map Id Type
type LabelMap = M.Map Id Bool
type CallMap  = M.Map Id Callable
type SymbolMap = (VarMap,LabelMap,CallMap)
type Error = String
type Semantics a = EitherT Error (State [SymbolMap]) a

main = do
  ast <- parser
  let processAst = evalState . runEitherT . program
  let emptySymbolTable = [(M.empty,M.empty,M.empty)]
  putStrLn $
    case (\x -> x emptySymbolTable) $ processAst ast of
      Right _  -> "good"
      Left s   -> s

-- process ast
program :: Program -> Semantics ()
program (P _ body) = initSymbolTable >> bodySems body

-- process body
bodySems :: Body -> Semantics ()
bodySems (B locals (Bl s)) =
  flocals (reverse locals) >> fblock (reverse s)
bodysems (B locals _ ) = flocals (reverse locals)

-- process locals (vars, labels, headbod, forward)
flocals :: [Local] -> Semantics ()
flocals = mapM_ flocal

flocal :: Local -> Semantics ()
flocal = \case
  LoVar vars     -> toSems vars
  LoLabel labels -> insertLabels labels
  LoHeadBod h b  -> headBodF h b
  LoForward h    -> forwardF h

insertLabels :: Ids -> Semantics ()
insertLabels = mapM_ insertLabel

insertLabel :: Id -> Semantics ()
insertLabel l = do
  (vm,lm,fm):sms <- get
  case M.lookup l lm of
    Just _  -> left $ "Duplicate label declaration: " ++ l
    Nothing -> put $ (vm,M.insert l False lm,fm):sms

headBodF :: Header -> Body -> Semantics ()
headBodF h bod = do
  headF h
  sms <- get
  headArgsF h
  bodySems bod
  put sms

headArgsF :: Header -> Semantics ()
headArgsF = \case 
  Procedure i a   -> insertArgsInTm a
  Function  i a t -> insertArgsInTm a

insertArgsInTm :: Args -> Semantics ()
insertArgsInTm _ = return ()

-- to check if func/proc with forward is defined
parErr = "Parameter missmatch between " ++
         "forward and declaration for: "
dupErr = "Duplicate Variable: "

insertheader :: Id -> Callable -> Bool -> Semantics ()
insertheader i t expr = do
  (vm,lm,fm):sms <- get
  if expr then put $ (vm,lm,M.insert i t fm):sms
  else left $ parErr ++ i

searchCallSMs :: Id -> [SymbolMap] -> Maybe Callable
searchCallSMs id = \case
  sm:sms -> case searchCallSM id sm of
    Nothing -> searchCallSMs id sms
    x       -> x
  []     -> Nothing

searchCallSM :: Id -> SymbolMap -> Maybe Callable
searchCallSM id sm = M.lookup id $ (\(_,_,fm) -> fm) sm

searchVarSMs :: Id -> [SymbolMap] -> Maybe Type
searchVarSMs id = \case
  sm:sms -> case searchVarSM id sm of
    Nothing -> searchVarSMs id sms
    x       -> x
  []     -> Nothing

searchVarSM :: Id -> SymbolMap -> Maybe Type
searchVarSM id sm = M.lookup id $ (\(vm,_,_) -> vm) sm

headF :: Header -> Semantics ()
headF h = do
  sms <- get
  case h of
    Procedure i a   ->
      let a' = reverse a in
      case searchCallSMs i sms of
        Just (FProc b) ->
          insertheader i (Proc a')
              (formalsToTypes a' == formalsToTypes b)
        Nothing -> checkArgsAndPut i a' $ Proc a'
        _       -> left $ dupErr ++ i
    Function  i a t ->
      let a' = reverse a in
      case searchCallSMs i sms of
        Just (FFunc b t2) ->
          case t2 of
            ArrayT _ _ -> left $ "Function cant have a return type of array " ++ i
            _          -> insertheader i (Func a' t) (t==t2 && formalsToTypes a' == formalsToTypes b)
        Nothing -> checkArgsAndPut i a' $ Func a' t
        _       -> left $ dupErr ++ i

checkArgsAndPut :: Id -> Args -> Callable -> Semantics ()
checkArgsAndPut i as t = do
  (vm,lm,fm):sms <- get
  if all argOk as then put $ (vm,lm,M.insert i t fm):sms
  else left $ "Can't pass array by value in: " ++ i

argOk :: Formal -> Bool
argOk = \case
  (Value,_,ArrayT _ _) -> False
  _                    -> True

insertforward :: Id -> Args -> Callable -> Semantics ()
insertforward i as t = do
  sms <- get
  case searchCallSMs i sms of
    Just _ -> left $ dupErr ++ i
    Nothing -> checkArgsAndPut i as t

forwardF :: Header -> Semantics ()
forwardF h =
  case h of
    Procedure i a   -> insertforward i a (FProc $ reverse a)
    Function  i a t -> 
      case t of 
        ArrayT _ _ -> left $ "Function cant have a return type of array " ++ i
        _          -> insertforward i a (FFunc (reverse a) t)

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
  (vm,lm,fm):sms <- get
  case searchVarSMs v ((vm,lm,fm):sms) of
    Just _  -> left $ dupErr ++ v
    Nothing -> if checkFullType t then 
                 put ((M.insert v t vm,lm,fm):sms) >>
                 myinsert xs
               else left "Can't use 'array of' in local vars"
myinsert [] = return ()

fblock :: Stmts -> Semantics ()
fblock ss = mapM_ fstatement ss

-- Check that label exists in the program (not done)
-- Check that forward is declared afterwards (not done)
-- write particular argument of type mismatch
-- string-literal
-- result in scopes (how to handle it in the ST)
-- result exists in function
-- anathesi array diaforetikoy megethous?
-- check an dispose exei ginei new
-- check that labels are used at most once

gotoErr = "Undeclared Label: "
callErr = "Undeclared function or procedure in call: "
checkBoolExpr :: Expr -> String -> Semantics ()
checkBoolExpr expr stmtDesc = do
  et <- totype expr
  if et == Tbool then return ()
  else left $ "Non-boolean expression in " ++ stmtDesc

checkGoTo :: String -> Semantics ()
checkGoTo id = do
  (vm,lm,fm):_ <- get
  case M.lookup id lm of
    Just _  -> return ()
    Nothing -> left $ "undefined label: " ++ id

checkId :: String -> Semantics ()
checkId id = do
  (vm,lm,fm):sms <- get
  case M.lookup id lm of
    Just False -> put $ (vm,M.insert id True lm,fm):sms
    Just True  -> left $ "duplicate label: " ++ id
    Nothing    -> left $ "undefined label: " ++ id

checkpointer :: LValue -> Error -> Semantics Type
checkpointer lValue err = totypel lValue >>= \case
  PointerT t -> return t
  _          -> left err

fstatement :: Stmt -> Semantics ()
fstatement = \case
  SEmpty                   -> return ()
  SEqual lValue expr       -> do
                              lt <- totypel lValue
                              et <- totype  expr
                              if symbatos lt et then return ()
                              else left "type mismatch in assignment"
  SBlock (Bl ss)           -> fblock ss
  SCall (CId id exprs)     -> do
                              sms <- get
                              case searchCallSMs id sms of
                                Just t  -> callSem id t $ reverse exprs
                                Nothing -> left $ callErr ++ id
  SIT  expr stmt           -> checkBoolExpr expr "if-then" >>
                              fstatement stmt
  SITE expr s1 s2          -> checkBoolExpr expr "if-then-else" >>
                              fstatement s1 >> fstatement s2
  SWhile expr stmt         -> checkBoolExpr expr "while" >>
                              fstatement stmt
  SId id stmt              -> checkId   id >> fstatement stmt
  SGoto id                 -> checkGoTo id
  SReturn                  -> return ()
  SNew new lValue          -> do
    t <- checkpointer lValue "non-pointer in new statement"
    case (new,checkFullType t) of
      (NewEmpty,True)   -> return ()
      (NewExpr e,False) -> totype e >>= \case
        Tint -> return ()
        _    -> left "non-integer expression in new statement"
      _ -> left "bad pointer type in new expression"
  SDispose disptype lValue -> do
    t <- checkpointer lValue "non-pointer in dispose statement"
    case (disptype,checkFullType t) of
      (With,False)   -> return ()
      (Without,True) -> return ()
      _ -> left "bad pointer type in dispose expression"

checkFullType :: Type -> Bool
checkFullType = \case
  ArrayT NoSize _ -> False
  _               -> True

symbatos :: Type -> Type -> Bool
symbatos (PointerT (ArrayT NoSize t1))
         (PointerT (ArrayT (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) ||
                 (lt == Treal && et == Tint)

callSemErr = "Wrong type of identifier in call: "
callSem :: String -> Callable -> Exprs -> Semantics ()
callSem id = \case
  FProc as   -> goodArgs id as
  Proc  as   -> goodArgs id as
  _           -> \_ -> left $ callSemErr ++ id

goodArgs :: Id -> Args -> Exprs -> Semantics ()
goodArgs id as exprs =
  mapM forcalltype exprs >>=
  argsExprsSems id (formalsToTypes as)

forcalltype :: Expr -> Semantics (PassBy,Type)
forcalltype = \case
  L lval -> do
    a <- totypel lval
    return (Reference,a)
  R rval -> do
    b <- totyper rval
    return (Value,b)

totype :: Expr -> Semantics Type
totype = \case
  L lval -> totypel lval
  R rval -> totyper rval

varErr = "Undeclared variable: "
retErr = "'return' in function argument"
indErr = "index not integer"
arrErr = "indexing something that is not an array"
pointErr = "dereferencing non-pointer"

totypel :: LValue -> Semantics Type
totypel = \case
  LId id                 -> do
    sms <- get
    case searchVarSMs id sms of
      Just t  -> return t
      Nothing -> left $ varErr ++ id
  LResult                -> do
    sms <- get
    case searchVarSMs "result" sms of
      Just t  -> return t
      Nothing -> left $ varErr ++ "result"
  LString string         -> right $ ArrayT NoSize Tchar
  LValueExpr lValue expr -> totype expr >>= \case
    Tint -> totypel lValue >>= \case
      ArrayT _ t -> right t
      _          -> left arrErr
    _    -> left indErr
  LExpr expr             -> totype expr >>= \case
    PointerT t -> right t
    _          -> left pointErr
  LParen lValue          -> totypel lValue

checkposneg :: Expr -> String -> Semantics Type
checkposneg expr a = totype expr >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ "non-number expression after " ++ a

checkarithmetic :: Expr -> Expr -> String -> Semantics Type
checkarithmetic exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ "non-number expression after "++a
  Treal -> totype exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ "non-number expression after "++a
  _     -> left $ "non-number expression before "++a

checkinthmetic :: Expr -> Expr -> String -> Semantics Type
checkinthmetic exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ "non-integer expression after "++a
  _     -> left $ "non-integer expression before "++a

checklogic :: Expr -> Expr -> String -> Semantics Type
checklogic exp1 exp2 a = totype exp1 >>= \case
    Tbool  -> totype exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ "non-boolean expression after "++a
    _     -> left $ "non-boolean expression before "++a

checkcompare :: Expr -> Expr -> String -> Semantics Type
checkcompare exp1 exp2 a = totype exp1 >>= \case
  Tint  -> arithmeticbool exp2 ("mismatched types at "++a)
                          (right Tbool)
  Treal -> arithmeticbool exp2 ("mismatched types at "++a)
                          (right Tbool)
  Tbool -> totype exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ "mismatched types at "++a
  Tchar -> totype exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ "mismatched types at "++a
  PointerT _ -> pointersbool exp2 ("mismatched types at "++a)
  Tnil       -> pointersbool exp2 ("mismatched types at "++a)
  _     -> left $ "mismatched types at "++a

checknumcomp :: Expr -> Expr -> String -> Semantics Type
checknumcomp exp1 exp2 a =
  arithmeticbool exp1 ("non-number expression before " ++ a)
  (arithmeticbool exp2 ("non-number expression after " ++ a)
                  (right Tbool))

--polymorphic function on what to do and
--  the error msg is used for all numeric
--comparisons and numeric functions
--  with one return type in case of correct
--semantic analysis
arithmeticbool :: Expr -> String -> Semantics Type -> Semantics Type
arithmeticbool expr errmsg f =
  totype expr >>= \case
    Tint   -> f
    Treal  -> f
    _     -> left errmsg

pointersbool :: Expr -> String -> Semantics Type
pointersbool expr a =
  totype expr >>= \case
    PointerT _  -> right Tbool
    Tnil        -> right Tbool
    _           -> left a

totyper :: RValue -> Semantics Type
totyper = \case
  RInt _              -> right Tint
  RTrue               -> right Tbool
  RFalse              -> right Tbool
  RReal _             -> right Treal
  RChar _             -> right Tchar
  RParen rValue       -> totyper rValue
  RNil                -> right Tnil
  RCall (CId id exprs) -> do
    (vm,lm,fm):_ <- get
    case M.lookup id fm of
      Just t  -> funCallSem id t $ reverse exprs
      Nothing -> left $ callErr ++ id
  RPapaki  lValue     -> totypel lValue >>= right . PointerT
  RNot     expr       -> totype expr >>= \case
    Tbool -> right Tbool
    _     -> left "non-boolean expression after not"
  RPos     expr       -> checkposneg expr "'+'"
  RNeg     expr       -> checkposneg expr "'-'"
  RPlus    exp1 exp2  -> checkarithmetic exp1 exp2 "'+'"
  RMul     exp1 exp2  -> checkarithmetic exp1 exp2 "'*'"
  RMinus   exp1 exp2  -> checkarithmetic exp1 exp2 "'-'"
  RRealDiv exp1 exp2  ->
    arithmeticbool exp1 ("non-number expression before '/'")
    (arithmeticbool exp2 ("non-number expression after '/'")
                    (right Treal))
  RDiv     exp1 exp2  -> checkinthmetic exp1 exp2 "'div'"
  RMod     exp1 exp2  -> checkinthmetic exp1 exp2 "'mod'"
  ROr      exp1 exp2  -> checklogic exp1 exp2 "'or'"
  RAnd     exp1 exp2  -> checklogic exp1 exp2 "'and'"
  REq      exp1 exp2  -> checkcompare exp1 exp2 "'='"
  RDiff    exp1 exp2  -> checkcompare exp1 exp2 "'<>'"
  RLess    exp1 exp2  -> checknumcomp exp1 exp2 "'<'"
  RGreater exp1 exp2  -> checknumcomp exp1 exp2 "'>'"
  RGreq    exp1 exp2  -> checknumcomp exp1 exp2 "'>='"
  RSmeq    exp1 exp2  -> checknumcomp exp1 exp2 "'<='"

funCallSem :: Id -> Callable -> Exprs -> Semantics Type
funCallSem id = \case
  FFunc as t -> \exprs -> goodArgs id as exprs >> right t
  Func  as t -> \exprs -> goodArgs id as exprs >> right t
  _           -> \_ -> left $ callSemErr ++ id

argsExprsErr = "Wrong number of args for: "
typeExprsErr = "Type mismatch of args for: "

argsExprsSems :: Id -> [(PassBy,Type)] -> [(PassBy,Type)] -> Semantics ()
argsExprsSems id ((_,t1):t1s) ((_,t2):t2s)
  | symbatos t1 t2 = argsExprsSems id t1s t2s
  | otherwise = left $ "Bad argument in: " ++ id
argsExprsSems _ [] [] = return ()
argsExprsSems id _ _ = left $ argsExprsErr ++ id

--initialize Symbol Table with predefined procedures
initSymbolTable :: Semantics ()
initSymbolTable = do
  helpprocs "writeInteger" [(Value,["n"],Tint)]
  helpprocs "writeBoolean" [(Value,["b"],Tbool)]
  helpprocs "writeChar" [(Value,["c"],Tchar)]
  helpprocs "writeReal" [(Value,["r"],Treal)]
  helpprocs "writeString" [(Reference,["s"],ArrayT NoSize Tchar)]
  helpfunc "readInteger" [] Tint
  helpfunc "readBoolean" [] Tbool
  helpfunc "readChar" [] Tchar
  helpfunc "readReal" [] Treal
  helpprocs "readString" [(Value,["size"],Tint),
                           (Reference,["s"],ArrayT NoSize Tchar)]
  helpfunc "abs" [(Value,["n"],Tint)] Tint
  helpfunc "fabs" [(Value,["r"],Treal)] Treal
  helpfunc "sqrt" [(Value,["r"],Treal)] Treal
  helpfunc "sin" [(Value,["r"],Treal)] Treal
  helpfunc "cos" [(Value,["r"],Treal)] Treal
  helpfunc "tan" [(Value,["r"],Treal)] Treal
  helpfunc "arctan" [(Value,["r"],Treal)] Treal
  helpfunc "exp" [(Value,["r"],Treal)] Treal
  helpfunc "ln" [(Value,["r"],Treal)] Treal
  helpfunc "pi" [] Treal
  helpfunc "trunc" [(Value,["r"],Treal)] Tint
  helpfunc "round" [(Value,["r"],Treal)] Tint
  helpfunc "ord" [(Value,["r"],Tchar)] Tint
  helpfunc "chr" [(Value,["r"],Tint)] Tchar
  return ()

--helper function to insert the predefined procedures
--  to the symbol table
helpprocs :: String->Args->Semantics ()
helpprocs name myArgs = do
  (vm,lm,fm):sms <- get
  put $ (vm,lm,M.insert name (Proc myArgs) fm):sms

--helper function to insert
--  the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics ()
helpfunc name myArgs myType = do
  (vm,lm,fm):sms <- get
  put $ (vm,lm,M.insert name (Func myArgs myType) fm):sms
