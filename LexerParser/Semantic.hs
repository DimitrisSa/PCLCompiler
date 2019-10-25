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
program (P _ body) = bodySems body
  
bodySems :: Body -> Semantics
bodySems (B locals block) = do
  flocals locals
  fblock

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
    Procedure i a   -> case M.lookup i tm of 
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (Tproc a) tm 
    Function  i a t -> case M.lookup i tm of
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (Tfunc a t) tm

forwardF :: Header -> Semantics
forwardF h = do
  tm <- get
  case h of
    Procedure i a   -> case M.lookup i tm of 
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (Tproc a) tm 
    Function  i a t -> case M.lookup i tm of
                         Just _  -> left $ "Duplicate Variable: " ++ i
                         Nothing -> put $ M.insert i (Tfunc a t) tm

toSems :: Variables -> Semantics
toSems (var:vars) = do
  myinsert (makelist var)
  toSems vars
toSems [] = return ()

makelist :: (Ids,Type) -> [(Id,Type)]
makelist (in1,myt) =
  Prelude.map (\x -> (x,myt)) in1 

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

fblock = do
  return ()
