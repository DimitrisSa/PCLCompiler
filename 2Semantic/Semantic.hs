module Main where
import Parser
import Control.Monad.State
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import qualified Data.Map as M

-- new/dispose
-- checkbool
-- sequal

data Callable =
  Proc Args          |
  Func Args Type     |
  FProc Args         |
  FFunc Args Type    
  deriving(Show,Eq)

type VarMap   = M.Map Id Type
type LabelMap = M.Map Id Bool
type CallMap  = M.Map Id Callable
type NewMap   = M.Map LValue ()
type SymbolMap = (VarMap,LabelMap,CallMap,NewMap)
type Error = String
type Semantics a = EitherT Error (State [SymbolMap]) a

emptySymbolMap = (M.empty,M.empty,M.empty,M.empty)
main = do
  s    <- getContents
  case parser s of
    Left e -> die e
    Right ast -> do
      let processAst = evalState . runEitherT . program
      let emptySymbolTable = [emptySymbolMap]
      case (\x -> x emptySymbolTable) $ processAst ast of
        Right _  -> hPutStrLn stdout "good" >> exitSuccess
        Left s   -> die s 

-- process ast
program :: Program -> Semantics ()
program (P _ body) = initSymbolTable >> bodySems body

-- process body
bodySems :: Body -> Semantics ()
bodySems (B locals (Bl s)) =
  flocals (reverse locals) >> fblock (reverse s) >>
  checkDangledGoTos (reverse s)

checkDangledGoTos :: Stmts -> Semantics ()
checkDangledGoTos = mapM_ checkDangledGoTo

dangledGotoErr = "goto label declared but not used: "
checkDangledGoTo :: Stmt -> Semantics ()
checkDangledGoTo = \case
  SGoto id -> do
    (_,lm,_,_):_ <- get
    let idv = idValue id
        (li,co) = idPosn id
    case M.lookup id lm of
      Just False -> left $ dangledGotoErr ++ idv ++
                    errorend li co
      _          -> return ()
  SBlock (Bl ss) -> checkDangledGoTos $ reverse ss
  _              -> return ()

-- process locals (vars, labels, headbod, forward)
flocals :: [Local] -> Semantics ()
flocals ls = mapM_ flocal ls >> checkNoForward

checkNoForward :: Semantics ()
checkNoForward = get >>= \((_,_,fm,_):_) ->
  checkNoForwardFMList $ M.toList fm

forwardErr = "no implementation for forward declaration: "
checkNoForwardFMList :: [(Id,Callable)] -> Semantics ()
checkNoForwardFMList = \case
  (id,FProc _  ):_ -> let idv = idValue id
                          (li,co) = idPosn id
                      in left $ forwardErr ++ idv
                                ++ errorend li co
  (id,FFunc _ _):_ -> let idv = idValue id
                          (li,co) = idPosn id
                      in left $ forwardErr ++ idv
                                ++ errorend li co
  _:fml            -> checkNoForwardFMList fml
  []               -> return ()

flocal :: Local -> Semantics ()
flocal = \case
  LoVar vars     -> toSems vars
  LoLabel labels -> insertLabels labels
  LoHeadBod h b  -> headBodF h b
  LoForward h    -> forwardF h

insertLabels :: Ids -> Semantics ()
insertLabels = mapM_ insertLabel

errorend l c = " at line " ++ show l ++ ", column " ++ show c
insertLabel :: Id -> Semantics ()
insertLabel l = do
  (vm,lm,fm,nm):sms <- get
  let lv = idValue l
      (li,co) = idPosn l
  case M.lookup l lm of
    Just _  -> left $ "Duplicate label declaration: " ++ lv ++
                      errorend li co
    Nothing -> put $ (vm,M.insert l False lm,fm,nm):sms

headBodF :: Header -> Body -> Semantics ()
headBodF h bod = do
  headF h
  sms <- get
  put $ emptySymbolMap:sms
  headArgsF h
  bodySems bod
  checkresult h
  put sms

checkresult :: Header -> Semantics ()
checkresult = \case
  Function i _ _ -> do
    (vm,_,_,_):_ <- get
    let idv = idValue i
        (li,co) = idPosn i
    case M.lookup (dummy "while") vm of
      Nothing -> left $ "Result not set for function: " ++ idv
                        ++ errorend li co
      _       -> return () 
  _ -> return ()

headArgsF :: Header -> Semantics ()
headArgsF = \case 
  Procedure _ a   -> insertArgsInTm a
  Function  _ a t -> insertArgsInTm a >> insertResult t

insertResult :: Type -> Semantics ()
insertResult t = do
  (vm,lm,fm,nm):sms <- get
  put $ (M.insert (dummy "result") t vm,lm,fm,nm):sms 

insertArgsInTm :: Args -> Semantics ()
insertArgsInTm = mapM_ insertFormalInTm

insertFormalInTm :: Formal -> Semantics ()
insertFormalInTm (_,ids,t) = mapM_ (insertIdInTm t) ids

insertIdInTm :: Type -> Id -> Semantics ()
insertIdInTm t id = do
  (vm,lm,fm,nm):sms <- get
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id vm of
    Nothing -> put $ (M.insert id t vm,lm,fm,nm):sms
    _       -> left $ "duplicate argument: " ++ idv 
                        ++ errorend li co

-- to check if func/proc with forward is defined
parErr = "Parameter missmatch between " ++
         "forward and declaration for: "
dupErr = "Duplicate Variable: "

insertheader :: Id -> Callable -> Bool -> Semantics ()
insertheader i t expr = do
  (vm,lm,fm,nm):sms <- get
  let idv = idValue i
      (li,co) = idPosn i
  if expr then put $ (vm,lm,M.insert i t fm,nm):sms
  else left $ parErr ++ idv ++ errorend li co

searchCallSMs :: Id -> [SymbolMap] -> Maybe Callable
searchCallSMs id = \case
  sm:sms -> case searchCallSM id sm of
    Nothing -> searchCallSMs id sms
    x       -> x
  []     -> Nothing

searchCallSM :: Id -> SymbolMap -> Maybe Callable
searchCallSM id sm = M.lookup id $ (\(_,_,fm,_) -> fm) sm

searchVarSMs :: Id -> [SymbolMap] -> Maybe Type
searchVarSMs id = \case
  sm:sms -> case searchVarSM id sm of
    Nothing -> searchVarSMs id sms
    x       -> x
  []     -> Nothing

searchVarSM :: Id -> SymbolMap -> Maybe Type
searchVarSM id sm = M.lookup id $ (\(vm,_,_,_) -> vm) sm

headProcedureF :: Id -> Args -> [SymbolMap] -> Semantics ()
headProcedureF i a sms =
  let a' = reverse a 
      idv = idValue i
      (li,co) = idPosn i
  in
  case searchCallSMs i sms of
    Just (FProc b) -> let aTypes = formalsToTypes a'
                          bTypes = formalsToTypes b
                          sameTypes = aTypes == bTypes
                          p = Proc a'
                      in insertheader i p sameTypes
    Nothing        -> checkArgsAndPut i a' $ Proc a'
    _              -> left $ dupErr ++ idv ++ errorend li co

funErr = "Function can't have a return type of array "
type SemUnit = Semantics ()
headFunctionF ::Id -> Args -> Type -> [SymbolMap] -> SemUnit
headFunctionF i a t sms =
  let a' = reverse a
      idv = idValue i
      (li,co) = idPosn i in
  case searchCallSMs i sms of
    Just (FFunc b t2) -> let aTypes = formalsToTypes a'
                             bTypes = formalsToTypes b
                             sameTypes = aTypes == bTypes
                             f = Func a' t
                      in insertheader i f (t==t2 && sameTypes)
    Nothing -> case t of
      ArrayT _ _ -> left $ funErr ++ idv ++ errorend li co
      _          -> checkArgsAndPut i a' $ Func a' t
    _       -> left $ dupErr ++ idv ++ errorend li co

headF :: Header -> Semantics ()
headF h = get >>= \sms -> case h of
  Procedure i a   -> headProcedureF i a sms 
  Function  i a t -> headFunctionF i a t sms

checkArgsAndPut :: Id -> Args -> Callable -> Semantics ()
checkArgsAndPut i as t = do
  (vm,lm,fm,nm):sms <- get
  let idv = idValue i
      (li,co) = idPosn i
  if all argOk as then put $ (vm,lm,M.insert i t fm,nm):sms
  else left $ "Can't pass array by value in: " ++ idv
              ++ errorend li co

argOk :: Formal -> Bool
argOk = \case
  (Value,_,ArrayT _ _) -> False
  _                    -> True

insertforward :: Id -> Args -> Callable -> Semantics ()
insertforward i as t = do
  sms <- get
  let idv = idValue i
      (li,co) = idPosn i
  case searchCallSMs i sms of
    Just _ -> left $ dupErr ++ idv ++ errorend li co
    Nothing -> checkArgsAndPut i as t

forwardF :: Header -> Semantics ()
forwardF h = case h of
  Procedure i a   -> insertforward i a (FProc $ reverse a)
  Function  i a t -> case t of 
    ArrayT _ _ -> let idv = idValue i
                      (li,co) = idPosn i
                  in left $ funErr ++ idv ++ errorend li co
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
  (vm,lm,fm,nm):sms <- get
  let idv = idValue v
      (li,co) = idPosn v
  case searchVarSMs v ((vm,lm,fm,nm):sms) of
    Just _  -> left $ dupErr ++ idv ++ errorend li co
    Nothing -> if checkFullType t then 
                 put ((M.insert v t vm,lm,fm,nm):sms) >>
                 myinsert xs
               else left $ "Can't use 'array of' at: "
                           ++ idv ++ errorend li co
myinsert [] = return ()

fblock :: Stmts -> Semantics ()
fblock ss = mapM_ fstatement ss

gotoErr = "Undeclared Label: "
callErr = "Undeclared function or procedure in call: "
checkBoolExpr :: Expr -> String -> Semantics ()
checkBoolExpr expr stmtDesc = do
  et <- totype expr
  if et == Tbool then return ()
  else left $ "Non-boolean expression in " ++ stmtDesc

checkGoTo :: Id -> Semantics ()
checkGoTo id = do
  (_,lm,_,_):_ <- get
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id lm of
    Just _  -> return ()
    Nothing -> left $ "undefined label: " ++ idv
                      ++ errorend li co

checkId :: Id -> Semantics ()
checkId id = do
  (vm,lm,fm,nm):sms <- get
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id lm of
    Just False -> put $ (vm,M.insert id True lm,fm,nm):sms
    Just True  -> left $ "duplicate label: " ++ idv
                         ++ errorend li co
    Nothing    -> left $ "undefined label: " ++ idv
                         ++ errorend li co

checkpointer :: LValue -> Error -> Semantics Type
checkpointer lValue err = totypel lValue >>= \case
  PointerT t -> return t
  _          -> left err

fstatement :: Stmt -> Semantics ()
fstatement = \case
  SEmpty                   -> return ()
  SEqual lValue expr       -> case lValue of
    LString _ -> left "assignment to string"
    _         -> do
      lt <- totypel lValue
      et <- totype  expr
      if symbatos lt et then return ()
      else left "type mismatch in assignment"
  SBlock (Bl ss)           -> fblock $ reverse ss
  SCall (CId id exprs)     -> do
                              sms <- get
                              let idv = idValue id
                                  (li,co) = idPosn id
                              case searchCallSMs id sms of
                                Just t  -> callSem id t $
                                           reverse exprs
                                Nothing -> left $ callErr ++
                                           idv ++
                                           errorend li co
  SIT  expr stmt           -> checkBoolExpr expr "if-then" >>
                              fstatement stmt
  SITE expr s1 s2          -> checkBoolExpr expr "if-then-else"
                              >> fstatement s1 >> fstatement s2
  SWhile expr stmt         -> checkBoolExpr expr "while" >>
                              fstatement stmt
  SId id stmt              -> checkId   id >> fstatement stmt
  SGoto id                 -> checkGoTo id
  SReturn                  -> return ()
  SNew new lValue          -> do
    (vm,lm,fm,nm):sms <- get
    put $ (vm,lm,fm,M.insert lValue () nm):sms 
    t <- checkpointer lValue "non-pointer in new statement"
    case (new,checkFullType t) of
      (NewEmpty,True)   -> return ()
      (NewExpr e,False) -> totype e >>= \case
        Tint -> return ()
        _    -> left "non-integer expression in new statement"
      _ -> left "bad pointer type in new expression"
  SDispose disptype lValue -> do
    (vm,lm,fm,nm):sms <- get
    newnm <- deleteNewMap lValue nm
    put $ (vm,lm,fm,newnm):sms 
    t <- checkpointer lValue "non-pointer in dispose statement"
    case (disptype,checkFullType t) of
      (With,False)   -> return ()
      (Without,True) -> return ()
      _ -> left "bad pointer type in dispose expression"

deleteNewMap :: LValue -> NewMap -> Semantics NewMap
deleteNewMap l nm = case M.lookup l nm of
  Nothing -> left $ "disposing null pointer"
  _       -> right $ M.delete l nm

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
callSem :: Id -> Callable -> Exprs -> Semantics ()
callSem id = \case
  FProc as -> goodArgs id as
  Proc  as -> goodArgs id as
  _        -> let idv = idValue id
                  (li,co) = idPosn id
              in \_ -> left $ callSemErr ++ idv
                              ++ errorend li co

goodArgs :: Id -> Args -> Exprs -> Semantics ()
goodArgs id as exprs =
  mapM forcalltype exprs >>=
  argsExprsSems 1 id (formalsToTypes as) 

forcalltype :: Expr -> Semantics (PassBy,Type)
forcalltype = \case
  L lval -> totypel lval >>= \a -> return (Reference,a)
  R rval -> totyper rval >>= \b -> return (Value,b)

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
    let idv = idValue id
        (li,co) = idPosn id
    case searchVarSMs id sms of
      Just t  -> return t
      Nothing -> left $ varErr ++ idv ++ errorend li co
  LResult                -> do
    (vm,lm,fm,nm):sms <- get
    case M.lookup (dummy "result") vm of
      Just t  -> put ((M.insert (dummy "while") t vm,
                       lm,fm,nm):sms) >> return t
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
type SemType = Semantics Type
arithmeticbool :: Expr -> String -> SemType -> SemType
arithmeticbool expr errmsg f = totype expr >>= \case
  Tint   -> f
  Treal  -> f
  _     -> left errmsg

pointersbool :: Expr -> String -> Semantics Type
pointersbool expr a = totype expr >>= \case
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
    sms <- get
    let idv = idValue id
        (li,co) = idPosn id
    case searchCallSMs id sms of
      Just t  -> funCallSem id t $ reverse exprs
      Nothing -> left $ callErr ++ idv ++ errorend li co
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
  _           -> let idv = idValue id
                     (li,co) = idPosn id
                 in \_ -> left $ callSemErr ++ idv
                                 ++ errorend li co

argsExprsErr = "Wrong number of args for: "
typeExprsErr = "Type mismatch of args for: "
badArgErr id i = concat ["Type mismatch at argument ",show i,
                         " in call of: ", id]
type PTs = [(PassBy,Type)]
refErr i id = concat
  ["Argument ",show i, " in call of \"",
   id,"\" cannot be passed by reference"]

argsExprsSems :: Int -> Id -> PTs -> PTs -> Semantics ()
argsExprsSems i id ((Reference,_):_) ((Value,_):_) =
    let idv = idValue id
        (li,co) = idPosn id
    in left $ refErr i idv ++ errorend li co
argsExprsSems i id ((_,t1):t1s) ((_,t2):t2s)
  | symbatos t1 t2 = argsExprsSems (i+1) id t1s t2s
  | otherwise =
    let idv = idValue id
        (li,co) = idPosn id
    in left $ badArgErr idv i ++ errorend li co
argsExprsSems _ _ [] [] = return ()
argsExprsSems _ id _ _ =
    let idv = idValue id
        (li,co) = idPosn id
    in left $ argsExprsErr ++ idv ++ errorend li co

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
dummy s = Id s (0,0)

--helper function to insert the predefined procedures
--  to the symbol table
helpprocs :: String->Args->Semantics ()
helpprocs name myArgs = do
  (vm,lm,fm,nm):sms <- get
  put $ (vm,lm,M.insert (dummy name) (Proc myArgs) fm,nm):sms

--helper function to insert
--  the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics ()
helpfunc name myArgs myType = do
  (vm,lm,fm,nm):sms <- get
  put $ (vm,lm,M.insert (dummy name) (Func myArgs myType) fm,
         nm):sms
