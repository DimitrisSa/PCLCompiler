module Main where
import Parser
import Control.Monad.State
import Control.Monad.Trans.Either
import qualified Data.Map as M

type TypeMap = M.Map Id Type
type Error = String
type Semantics = EitherT Error (State TypeMap) ()

main = do
  ast <- parser
  let processAst = evalState . runEitherT . program
  putStrLn $
    case (\x -> x M.empty) $ processAst ast of
      Right _  -> "good"
      Left s   -> s

-- process ast
program :: Program -> Semantics
program (P _ body) = initSymbolTable >> bodySems body 

-- process body
bodySems :: Body -> Semantics
bodySems (B locals block) = 
  flocals (reverse locals) >> fblock block

-- process locals (vars, labels, headbod, forward)
flocals :: [Local] -> Semantics
flocals = mapM_ flocal

flocal :: Local -> Semantics
flocal = \case 
  LoVar vars     -> toSems vars
  LoLabel labels -> myinsert (makeLabelList labels)
  LoHeadBod h _  -> headBodF h
  LoForward h    -> forwardF h

-- to check if func/proc with forward is defined
parErr = "Parameter missmatch between " ++
         "forward and declaration for: "
dupErr = "Duplicate Variable: "

headBodF :: Header -> Semantics
headBodF h = do
  tm <- get
  case h of
    Procedure i a   ->
      case M.lookup i tm of 
        Just (TFproc b) -> 
           if  makelistforward a == makelistforward b then
             put $ M.insert i (Tproc a) tm 
           else
             left $ parErr ++ i
        Nothing -> put $ M.insert i (Tproc a) tm 
        _       -> left $ dupErr ++ i
    Function  i a t ->
      case M.lookup i tm of
        Just (TFfunc b t2) -> 
           if (t==t2) &&
              (makelistforward a == makelistforward b) then
             put $ M.insert i (Tfunc a t) tm 
           else
             left $ parErr ++ i
        Nothing -> put $ M.insert i (Tfunc a t) tm
        _       -> left $ dupErr ++ i

forwardF :: Header -> Semantics
forwardF h = do
  tm <- get
  case h of
    Procedure i a   ->
      case M.lookup i tm of 
        Just _  -> left $ dupErr ++ i
        Nothing -> put $ M.insert i (TFproc a) tm 
    Function  i a t ->
      case M.lookup i tm of
        Just _  -> left $ dupErr ++ i
        Nothing -> put $ M.insert i (TFfunc a t) tm

toSems :: Variables -> Semantics
toSems = mapM_ (myinsert . makelist)

makelist :: (Ids,Type) -> [(Id,Type)]
makelist (in1,myt) = Prelude.map (\x -> (x,myt)) in1 

makelistforward :: [(Ids,Type)] -> [Type]
makelistforward fs = concat $ map makelisthelp fs

makelisthelp :: (Ids,Type) -> [Type]
makelisthelp (in1,myt) = Prelude.map (\_ -> myt) in1 

makeLabelList :: Ids -> [(Id,Type)]
makeLabelList in1 = Prelude.map (\x -> (x,Tlabel)) in1 

myinsert :: [(Id,Type)] -> Semantics
myinsert ((v,t):xs) = do
  tm <- get
  case M.lookup v tm of
    Just _  -> left $ dupErr ++ v
    Nothing -> put (M.insert v t tm) >> myinsert xs
myinsert [] = return ()

fblock :: Block -> Semantics 
fblock (Bl ss) = mapM_ fstatement ss

-- Check that label exists in the program (not done)
-- Check that r-value is not procedure in call (not done)
-- Check that forward is declared afterwards (not done)
-- fix call expr for r-values
-- string-literal

gotoErr = "Undeclared Label: "
callErr = "Undeclared function or procedure in call: "

fstatement :: Stmt -> Semantics
fstatement = \case
  SEmpty               -> return ()
  SEqual lValue expr   -> return ()
  SBlock block         -> return ()
  SCall (CId id exprs) -> do
    tm <- get
    case M.lookup id tm of
      Just t  -> callSem id t exprs
      Nothing -> left $ callErr ++ id
  SIT  expr stmt       -> return ()
  SITE expr s1 s2      -> return ()
  SWhile expr stmt     -> return ()
  SId id stmt          -> return ()
  SGoto id             -> do
    tm <- get
    case M.lookup id tm of
      Just l  -> return ()
      Nothing -> left $ gotoErr ++ id
  SReturn              -> return ()
  SNew expr lValue     -> return ()
  SDispose lValue      -> return ()
  SElse stmt           -> return ()

callSemErr = "Wrong type of identifier in call: "
callSem id = \case
  TFfunc as t -> \exprs -> return ()
  Tfunc  as t -> \exprs -> return ()
  TFproc as   -> \exprs -> return ()
  Tproc  as   -> \exprs -> argsExprsSems id (makelistforward as) exprs--mapM totype exprs >>= argsExprsSems id (makelistforward as)
  _           -> \_ -> left $ callSemErr ++ id

--totype :: Expr -> Semantics 
--totype a = Tint

argsExprsErr = "Wrong number of args for: "
argsExprsSems :: Id -> [Type] -> Exprs -> Semantics
argsExprsSems id (t:ts) (expr:exprs) = 
  argsExprsSems id ts exprs 
argsExprsSems _ [] [] = return ()
argsExprsSems id _ _ = left $ argsExprsErr ++ id

--initialize Symbol Table with predefined procedures
initSymbolTable :: Semantics
initSymbolTable = do
  helpprocs "writeInteger" [(["number"],Tint)]
  helpprocs "writeBoolean" [(["cow"],Tbool)]
  helpprocs "writeChar" [(["character"],Tchar)]
  helpprocs "writeReal" [(["notimaginary"],Treal)]
  helpprocs "writeString" [(["typestring"],ArrayT NoSize Tchar)]
  helpfunc "readInteger" [] Tint
  helpfunc "readBoolean" [] Tbool
  helpfunc "readChar" [] Tchar
  helpfunc "readReal" [] Treal
  helpprocs "readString" [(["size"],Tint),(["myarray"],ArrayT NoSize Tchar)]
  helpfunc "abs" [(["num"],Tint)] Tint
  helpfunc "fabs" [(["rnum"],Treal)] Treal
  helpfunc "sqrt" [(["rnum"],Treal)] Treal
  helpfunc "sin" [(["rnum"],Treal)] Treal
  helpfunc "cos" [(["rnum"],Treal)] Treal
  helpfunc "tan" [(["rnum"],Treal)] Treal
  helpfunc "arctan" [(["rnum"],Treal)] Treal
  helpfunc "exp" [(["rnum"],Treal)] Treal
  helpfunc "ln" [(["rnum"],Treal)] Treal
  helpfunc "pi" [] Treal
  helpfunc "trunc" [(["rnum"],Treal)] Tint
  helpfunc "round" [(["rnum"],Treal)] Tint
  helpfunc "ord" [(["rnum"],Tchar)] Tint
  helpfunc "chr" [(["rnum"],Tint)] Tchar
  return ()

--helper function to insert the predefined procedures to the symbol table
helpprocs :: String->Args->Semantics
helpprocs name myArgs = do
  tm <- get
  put $ M.insert name (Tproc myArgs) tm
  return ()

--helper function to insert the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics
helpfunc name myArgs myType = do
  tm <- get
  put $ M.insert name (Tfunc myArgs myType) tm
  return ()
