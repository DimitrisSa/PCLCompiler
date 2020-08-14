module SemsTypes where
import Prelude hiding (lookup)
import Parser 
import Control.Monad.State (State,get,modify)
import Control.Monad.Trans.Either 
import Data.Map (Map,empty,insert,lookup)

data Callable =
  Proc [Frml]                  |
  Func [Frml] Type             |
  ProcDclr [Frml]       |
  FuncDclr [Frml] Type
  deriving(Show,Eq)

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  }

data Env = InProc | InFunc Id Type Bool

type VariableMap = Map Id Type
type LabelMap    = Map Id Bool
type CallableMap = Map Id Callable
type Error       = String
type Sems a      = EitherT Error (State (Env,[SymbolTable])) a

emptySymbolTable = SymbolTable empty empty empty --empty
initState = (InProc,[emptySymbolTable])

infixl 9 >>>
(>>>) = (flip (.))

getEnv :: Sems Env
getEnv = get >>= fst >>> return

setEnv :: Env -> Sems ()
setEnv env = modify $ \(_,sts) -> (env,sts)

getMap :: (SymbolTable -> a) -> Sems a
getMap map = get >>= snd >>> head >>> map >>> return

getVariableMap :: Sems VariableMap
getVariableMap = getMap variableMap

getLabelMap :: Sems LabelMap
getLabelMap = getMap labelMap

getCallableMap :: Sems CallableMap
getCallableMap = getMap callableMap

insToVariableMap :: Id -> Type -> Sems ()
insToVariableMap var ty =
  modify $ \(e,st:sts) -> (e,st { variableMap = insert var ty $ variableMap st }:sts)

insToLabelMap :: Id -> Bool -> Sems ()
insToLabelMap label b =
  modify $ \(e,st:sts) -> (e,st { labelMap = insert label b $ labelMap st }:sts)

insToCallableMap :: Id -> Callable -> Sems ()
insToCallableMap id cal =
  modify $ \(e,st:sts) -> (e,st { callableMap = insert id cal $ callableMap st }:sts)

lookupInMap :: Sems (Map Id a) -> Id -> Sems (Maybe a)
lookupInMap getMap id = getMap >>= lookup id >>> return

lookupInVariableMap :: Id -> Sems (Maybe Type)
lookupInVariableMap = lookupInMap getVariableMap

lookupInLabelMap :: Id -> Sems (Maybe Bool)
lookupInLabelMap = lookupInMap getLabelMap

lookupInCallableMap :: Id -> Sems (Maybe Callable)
lookupInCallableMap = lookupInMap getCallableMap

searchVarInSymTabs :: Id -> Sems Type
searchVarInSymTabs id = get >>= snd >>>
  searchInSymTabs variableMap id "Undeclared variable: "

searchCallableInSymTabs :: Id -> Sems Callable
searchCallableInSymTabs id = get >>= snd >>>
  searchInSymTabs callableMap id "Undeclared function or procedure in call: "

searchInSymTabs :: (SymbolTable -> Map Id a) -> Id -> Error -> [SymbolTable] -> Sems a
searchInSymTabs map id err = \case
  st:sts -> case lookup id $ map st of
    Just val -> return val
    Nothing  -> searchInSymTabs map id err sts
  []     -> errAtId err id

errAtId :: String -> Id -> Sems a
errAtId err (Id posn str) = errPos posn $ err ++ str

errPos (li,co) err = left $ concat [show li,":",show co,": ",err] 
