module Main where
import SemTypes
import Parser as P
import Control.Monad.State
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import SemErrors
import qualified Data.Map as M
 
-- Read, Parse, Process sems
main = do
  s    <- getContents
  case parser s of
    Left e -> die e
    Right ast -> do
      let processAst = evalState . runEitherT . program
      case processAst ast emptyCGS of
        Right _  -> hPutStrLn stdout "good" >> exitSuccess
        Left s   -> die s

-- predefined funs + body sems
program :: Program -> Semantics ()
program (P _ body) = initSymbolTable >> bodySems body

-- locals sems + block sems + unused declared labels
bodySems :: Body -> Semantics ()
bodySems (B locals (Bl s)) =
  flocals (reverse locals) >> fblock (reverse s) >>
  checkDangledGoTos (reverse s)

checkDangledGoTos :: Stmts -> Semantics ()
checkDangledGoTos = mapM_ checkDangledGoTo

checkDangledGoTo :: Stmt -> Semantics ()
checkDangledGoTo = \case
  SGoto id -> do
    (_,lm,_,_):_ <- gets symtab
    let idv = idValue id
        (li,co) = idPosn id
    case M.lookup id lm of
      Just False -> left $ dangledGotoErr ++ idv ++
                    errorend li co
      _          -> return ()
  SBlock (Bl ss) -> checkDangledGoTos $ reverse ss
  _              -> return ()

-- process locals + unimplemented forward
flocals :: [Local] -> Semantics ()
flocals ls = mapM_ flocal ls >> checkNoForward

checkNoForward :: Semantics ()
checkNoForward = gets symtab >>= \((_,_,fm,_):_) ->
  checkNoForwardFMList $ map (\(x,y)->(x,ca y)) $ M.toList fm

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

-- Pattern match and call appropriate fun
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
  (vm,lm,fm,nm):sms <- gets symtab
  let lv = idValue l
      (li,co) = idPosn l
  case M.lookup l lm of
    Just _  -> left $ dupLabDecErr ++ lv ++ errorend li co
    Nothing -> modify $ \s->s {symtab =
      (vm,M.insert l False lm,fm,nm):sms }

headBodF :: Header -> Body -> Semantics ()
headBodF h bod = do
  headF h
  sms <- gets symtab
  modify $ \s->s {symtab = emptySymbolMap:sms }
  headArgsF h
  bodySems bod
  checkresult h
  modify $ \s->s {symtab = sms }

checkresult :: Header -> Semantics ()
checkresult = \case
  Function i _ _ -> do
    (vm,_,_,_):_ <- gets symtab
    let idv = idValue i
        (li,co) = idPosn i
    case M.lookup (dummy "while") vm of
      Nothing -> left $ noResInFunErr ++ idv ++ errorend li co
      _       -> return ()
  _ -> return ()

headArgsF :: Header -> Semantics ()
headArgsF = \case
  Procedure _ a   -> insertArgsInTm a
  Function  _ a t -> insertArgsInTm a >> insertResult t

insertResult :: P.Type -> Semantics ()
insertResult t = do
  (vm,lm,fm,nm):sms <- gets symtab
  modify $ \s -> s {symtab =
    (M.insert (dummy "result") (var t) vm,lm,fm,nm):sms }

insertArgsInTm :: Args -> Semantics ()
insertArgsInTm = mapM_ insertFormalInTm

insertFormalInTm :: Formal -> Semantics ()
insertFormalInTm (_,ids,t) = mapM_ (insertIdInTm t) ids

insertIdInTm :: P.Type -> Id -> Semantics ()
insertIdInTm t id = do
  (vm,lm,fm,nm):sms <- gets symtab
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id vm of
    Nothing -> modify $ \s->s {symtab =
      (M.insert id (var t) vm,lm,fm,nm):sms }
    _       -> left $ dupArgErr ++ idv ++ errorend li co

-- to check if func/proc with forward is defined
insertheader :: Id -> Callable -> Bool -> Semantics ()
insertheader i t expr = do
  (vm,lm,fm,nm):sms <- gets symtab
  let idv = idValue i
      (li,co) = idPosn i
  if expr then modify $ \s->s {symtab =
    (vm,lm,M.insert i (fp t) fm,nm):sms }
  else left $ parErr ++ idv ++ errorend li co

searchCallSMs :: Id -> [SymbolMap] -> Maybe Callable
searchCallSMs id = \case
  sm:sms -> case searchCallSM id sm of
    Nothing -> searchCallSMs id sms
    x       -> x
  []     -> Nothing

searchCallSM :: Id -> SymbolMap -> Maybe Callable
searchCallSM id sm = 
  fmap ca $ M.lookup id $ (\(_,_,fm,_) -> fm) sm

searchVarSMs :: Id -> [SymbolMap] -> Maybe P.Type
searchVarSMs id = \case
  sm:sms -> case searchVarSM id sm of
    Nothing -> searchVarSMs id sms
    x       -> x
  []     -> Nothing

searchVarSM :: Id -> SymbolMap -> Maybe P.Type
searchVarSM id sm =
  fmap ty $ M.lookup id $ (\(vm,_,_,_) -> vm) sm

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

type SemUnit = Semantics ()
headFunctionF :: Id -> Args -> P.Type -> [SymbolMap] -> SemUnit
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
headF h = gets symtab >>= \sms -> case h of
  Procedure i a   -> headProcedureF i a sms
  Function  i a t -> headFunctionF i a t sms

checkArgsAndPut :: Id -> Args -> Callable -> Semantics ()
checkArgsAndPut i as t = do
  (vm,lm,fm,nm):sms <- gets symtab
  let idv = idValue i
      (li,co) = idPosn i
  if all argOk as then modify $ \s->s {symtab =
    (vm,lm,M.insert i (fp t) fm,nm):sms }
  else left $ arrByValErr ++ idv ++ errorend li co

argOk :: Formal -> Bool
argOk = \case
  (Value,_,ArrayT _ _) -> False
  _                    -> True

insertforward :: Id -> Args -> Callable -> Semantics ()
insertforward i as t = do
  sms <- gets symtab
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
  (vm,lm,fm,nm):sms <- gets symtab
  let idv = idValue v
      (li,co) = idPosn v
  case searchVarSMs v ((vm,lm,fm,nm):sms) of
    Just _  -> left $ dupErr ++ idv ++ errorend li co
    Nothing -> if checkFullType t then
                 modify ( \s->s {symtab =
                   (M.insert v (var t) vm,lm,fm,nm):sms })>> 
                 myinsert xs
               else left $ arrayOfErr ++ idv ++ errorend li co
myinsert [] = return ()

fblock :: Stmts -> Semantics ()
fblock ss = mapM_ fstatement ss

checkBoolExpr :: Expr -> String -> Semantics ()
checkBoolExpr expr stmtDesc = do
  et <- totype expr
  if et == Tbool then return ()
  else left $ nonBoolErr ++ stmtDesc

checkGoTo :: Id -> Semantics ()
checkGoTo id = do
  (_,lm,_,_):_ <- gets symtab
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id lm of
    Just _  -> return ()
    Nothing -> left $ undefLabErr ++ idv ++ errorend li co

checkId :: Id -> Semantics ()
checkId id = do
  (vm,lm,fm,nm):sms <- gets symtab
  let idv = idValue id
      (li,co) = idPosn id
  case M.lookup id lm of
    Just False -> modify $ \s->s {symtab =
      (vm,M.insert id True lm,fm,nm):sms }
    Just True  -> left $ dupLabErr ++ idv ++ errorend li co
    Nothing    -> left $ undefLabErr ++ idv ++ errorend li co

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
  SBlock (Bl ss)           -> fblock $ reverse ss
  SCall (CId id exprs)     -> do
                              sms <- gets symtab
                              let idv = idValue id
                                  (li,co) = idPosn id
                              case searchCallSMs id sms of
                                Just t  -> callSem id t $
                                           reverse exprs
                                Nothing -> left $ callErr ++
                                           idv ++
                                           errorend li co
  SIT  (li,co) expr stmt -> checkBoolExpr expr ("if-then" ++ errorend li co) >>
                              fstatement stmt
  SITE (li,co) expr s1 s2 -> checkBoolExpr expr ("if-then-else" ++ errorend li co)
                              >> fstatement s1 >> fstatement s2
  SWhile (li,co) expr stmt -> checkBoolExpr expr ("while" ++ errorend li co) >>
                              fstatement stmt
  SId id stmt              -> checkId   id >> fstatement stmt
  SGoto id                 -> checkGoTo id
  SReturn                  -> return ()
  SNew (li,co) new lVal          -> do
    (vm,lm,fm,nm):sms <- gets symtab
    modify $ \s->s {symtab =
      (vm,lm,fm,M.insert lVal () nm):sms }
    t <- checkpointer lVal $ nonPointNewErr ++ errorend li co
    case (new,checkFullType t) of
      (NewEmpty,True)   -> return ()
      (NewExpr e,False) -> totype e >>= \case
        Tint -> return ()
        _    -> left $ nonIntNewErr ++ errorend li co
      _ -> left $ badPointNewErr ++ errorend li co
  SDispose (li,co) disptype lVal -> do
    (vm,lm,fm,nm):sms <- gets symtab
    newnm <- deleteNewMap lVal nm $
              dispNullPointErr ++ errorend li co
    modify $ \s->s {symtab = (vm,lm,fm,newnm):sms }
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

totype :: Expr -> Semantics P.Type
totype = \case
  L lval -> totypel lval
  R rval -> totyper rval

totypel :: LValue -> Semantics P.Type
totypel = \case
  LId id                 -> do
    sms <- gets symtab
    let idv = idValue id
        (li,co) = idPosn id
    case searchVarSMs id sms of
      Just t  -> return t
      Nothing -> left $ varErr ++ idv ++ errorend li co
  LResult (li,co)        -> do
    (vm,lm,fm,nm):sms <- gets symtab
    case M.lookup (dummy "result") vm of
      Just v  -> modify ( \s->s {symtab =
        (M.insert (dummy "while") v vm, lm,fm,nm):sms } )
                       >> return (ty v)
      Nothing -> left $ "Can only use result in a function call "++errorend li co
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
    _     -> left $ "non-number expression after " ++ a ++ errorend li co

checkarithmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkarithmetic (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    Treal -> right Treal
    _     -> left $ "non-number expression after "++a ++ errorend li co
  Treal -> totype exp2 >>= \case
    Treal -> right Treal
    Tint  -> right Treal
    _     -> left $ "non-number expression after "++a ++ errorend li co
  _     -> left $ "non-number expression before "++a ++ errorend li co

checkinthmetic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkinthmetic (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> totype exp2 >>= \case
    Tint  -> right Tint
    _     -> left $ "non-integer expression after "++a ++ errorend li co
  _     -> left $ "non-integer expression before "++a ++ errorend li co

checklogic :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checklogic (li,co) exp1 exp2 a = totype exp1 >>= \case
    Tbool  -> totype exp2 >>= \case
      Tbool  -> right Tbool
      _     -> left $ "non-boolean expression after " ++ a ++ errorend li co
    _     -> left $ "non-boolean expression before " ++ a ++ errorend li co

checkcompare :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checkcompare (li,co) exp1 exp2 a = totype exp1 >>= \case
  Tint  -> arithmeticbool exp2 ("mismatched types at "++a ++ errorend li co)
                          (right Tbool)
  Treal -> arithmeticbool exp2 ("mismatched types at "++a ++ errorend li co)
                          (right Tbool)
  Tbool -> totype exp2 >>= \case
    Tbool  -> right Tbool
    _      -> left $ "mismatched types at "++a ++ errorend li co
  Tchar -> totype exp2 >>= \case
    Tchar  -> right Tbool
    _      -> left $ "mismatched types at "++a ++ errorend li co
  PointerT _ -> pointersbool exp2 ("mismatched types at "++a ++ errorend li co)
  Tnil       -> pointersbool exp2 ("mismatched types at "++a ++ errorend li co)
  _     -> left $ "mismatched types at "++a ++ errorend li co

checknumcomp :: (Int,Int) -> Expr -> Expr -> String -> Semantics P.Type
checknumcomp (li,co) exp1 exp2 a =
  arithmeticbool exp1 ("non-number expression before " ++ a)
  (arithmeticbool exp2 ("non-number expression after " ++ a)
                  (right Tbool))

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
    sms <- gets symtab
    let idv = idValue id
        (li,co) = idPosn id
    case searchCallSMs id sms of
      Just t  -> funCallSem id t $ reverse exprs
      Nothing -> left $ callErr ++ idv ++ errorend li co
  RPapaki  posn lValue     -> totypel lValue >>=
                              right . PointerT
  RNot     (li,co) expr       -> totype expr >>= \case
    Tbool -> right Tbool
    _     -> left $ "non-boolean expression after not" ++ errorend li co
  RPos     posn expr       -> checkposneg posn expr "'+'"
  RNeg     posn expr       -> checkposneg posn expr "'-'"
  RPlus    posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'+'"
  RMul     posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'*'"
  RMinus   posn exp1 exp2  -> checkarithmetic posn exp1 exp2 "'-'"
  RRealDiv (li,co) exp1 exp2  ->
    arithmeticbool exp1 ("non-number expression before '/'" ++ errorend li co)
    (arithmeticbool exp2 ("non-number expression after '/'" ++ errorend li co)
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
  (vm,lm,fm,nm):sms <- gets symtab
  modify $ \s -> s {
    symtab = (vm,lm,
       M.insert (dummy name) (fp $ Proc myArgs) fm,nm):sms }
--helper function to insert
--  the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics ()
helpfunc name myArgs myType = do
  (vm,lm,fm,nm):sms <- gets symtab
  modify $ \s -> s {
    symtab = (vm,lm,
       M.insert (dummy name) (fp $ Func myArgs myType) fm,
         nm):sms }
