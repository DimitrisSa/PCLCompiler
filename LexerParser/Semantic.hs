module Main where
import Parser
import qualified Data.Map as M

type TypeMap = M.Map Id Type

data Semantics =
  Good TypeMap |
  Error String

main = do
  ast <- parser
  putStrLn $ case program ast of
    Good _  -> "good"
    Error s -> s
  
program :: Program -> Semantics
program (P _ body) = bodySems body
  
bodySems :: Body -> Semantics
bodySems (B locals block) = case flocals locals M.empty of
  Good mymap -> fblock mymap
  Error s -> Error s

flocals :: [Local] -> TypeMap -> Semantics
flocals locals mymap1 = case locals of
  (x:xs) -> case flocal x (Good mymap1) of
              Good mymap2 -> flocals xs mymap2
              Error s -> Error s
  []     -> Good mymap1

flocal :: Local -> Semantics -> Semantics
flocal local (Good mymap) = case local of
  LoVar vars -> toSems vars mymap
  LoLabel labels -> myinsert (makeLabelList labels) mymap
  LoHeadBod h _ -> headerF h mymap 
  LoForward h -> headerF h mymap
flocal _ a = a  

headerF :: Header -> TypeMap -> Semantics
headerF h tm = case h of
  Procedure i a   -> case M.lookup i tm of 
                      Just _  -> Error $ "Duplicate Variable: " ++ i
                      Nothing -> Good $ M.insert i (Tproc a) tm 
  Function  i a t -> case M.lookup i tm of
                      Just _  -> Error $ "Duplicate Variable: " ++ i
                      Nothing -> Good $ M.insert i (Tfunc a t) tm


toSems :: Variables -> TypeMap -> Semantics
toSems (var:vars) mymap = case myinsert (makelist var) mymap of
 Good mymap2 -> toSems vars mymap2
 Error s -> Error s
toSems [] mymap = Good mymap

makelist :: (Ids,Type) -> [(Id,Type)]
makelist (in1,myt) =
  Prelude.map (\x -> (x,myt)) in1 

makeLabelList :: Ids -> [(Id,Type)]
makeLabelList in1 =
  Prelude.map (\x -> (x,Tlabel)) in1 

myinsert :: [(Id,Type)] -> TypeMap -> Semantics
myinsert ((v,t):xs) mymap = case M.lookup v mymap of
  Just _  -> Error $ "Duplicate Variable: " ++ v
  Nothing -> myinsert xs $ M.insert v t mymap
myinsert [] mymap = Good mymap

fblock map = Good map
