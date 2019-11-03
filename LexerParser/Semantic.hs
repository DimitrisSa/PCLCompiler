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
  putStrLn $
    case (\x -> x M.empty) $ evalState $ runEitherT $ program ast of
      Right _  -> "good"
      Left s   -> s
  
program :: Program -> Semantics
program (P _ body) = do
  initSymbolTable
  bodySems body
  
bodySems :: Body -> Semantics
bodySems (B locals block) = do
  flocals (reverse locals)
  fblock block

flocals :: [Local] -> Semantics
flocals locals = case locals of
  (x:xs) -> do 
              flocal x
              flocals xs
  []     -> do 
              return ()

flocal :: Local -> Semantics
flocal local = do
  case local of
    LoVar vars     -> toSems vars
    LoLabel labels -> myinsert (makeLabelList labels)
    LoHeadBod h _  -> headBodF h
    LoForward h    -> forwardF h

-- to check if func/proc with forward is defined
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
             left $ "Parameter missmatch between forward and procedure declaration for: " ++ i
        Nothing -> put $ M.insert i (Tproc a) tm 
        _  -> left $ "Duplicate Variable: " ++ i
    Function  i a t ->
      case M.lookup i tm of
        Just (TFfunc b t2) -> 
           if  (t==t2) && (makelistforward a == makelistforward b) then
             put $ M.insert i (Tfunc a t) tm 
           else
             left $ "Parameter missmatch between forward and procedure declaration for: " ++ i
        Nothing -> put $ M.insert i (Tfunc a t) tm
        _  -> left $ "Duplicate Variable: " ++ i

forwardF :: Header -> Semantics
forwardF h = do
  tm <- get
  case h of
    Procedure i a   -> case M.lookup i tm of 
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (TFproc a) tm 
    Function  i a t -> case M.lookup i tm of
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (TFfunc a t) tm

toSems :: Variables -> Semantics
toSems (var:vars) = do
  myinsert (makelist var)
  toSems vars
toSems [] = return ()

makelist :: (Ids,Type) -> [(Id,Type)]
makelist (in1,myt) =
  Prelude.map (\x -> (x,myt)) in1 

makelistforward :: [(Ids,Type)] ->[Type]
makelistforward fs = concat $ map makelisthelp fs

makelisthelp :: (Ids,Type) -> [Type]
makelisthelp (in1,myt) =
  Prelude.map (\_ -> myt) in1 

makeLabelList :: Ids -> [(Id,Type)]
makeLabelList in1 =
  Prelude.map (\x -> (x,Tlabel)) in1 

myinsert :: [(Id,Type)] -> Semantics
myinsert ((v,t):xs) = do
  tm <- get
  case M.lookup v tm of
    Just _  -> left $ "Duplicate Variable: " ++ v
    Nothing -> do 
                 put $ M.insert v t tm
                 myinsert xs
myinsert [] = return ()

fblock :: Block->Semantics 
fblock _ = do
  return ()

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
  tm<-get
  put $ M.insert name (Tproc myArgs) tm
  return ()

--helper function to insert the predefined functions to the symbol table
helpfunc :: String->Args->Type->Semantics
helpfunc name myArgs myType = do
  tm<-get
  put $ M.insert name (Tfunc myArgs myType) tm
  return ()
