module SemsTypes where
import Prelude hiding (lookup)
import Parser as P
import Control.Monad.State 
import Control.Monad.Trans.Either 
import Data.Map (Map,empty,insert,lookup)

data Callable =
  Proc [Frml]                  |
  Func [Frml] P.Type             |
  ProcDclr [Frml]       |
  FuncDclr [Frml] P.Type
  deriving(Show,Eq)

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  }

data Env = InProc | InFunc Id P.Type Bool

type VariableMap = Map Id P.Type
type LabelMap    = Map Id Bool
type CallableMap = Map Id Callable
type Error       = String
type Sems        = EitherT Error (State (Env,[SymbolTable]))

emptySymbolTable = SymbolTable empty empty empty
initState = (InProc,[emptySymbolTable])

infixl 9 >>>
(>>>) = (flip (.))

getEnv :: Sems Env
getEnv = get >>= fst >>> return

setEnv :: Env -> Sems ()
setEnv env = modify $ \(_,sts) -> (env,sts)

getSymTabs :: Sems [SymbolTable]
getSymTabs = get >>= snd >>> return

getMap :: (SymbolTable -> a) -> Sems a
getMap map = getSymTabs >>= head >>> map >>> return

getVariableMap :: Sems VariableMap
getVariableMap = getMap variableMap

getLabelMap :: Sems LabelMap
getLabelMap = getMap labelMap

getCallableMap :: Sems CallableMap
getCallableMap = getMap callableMap

insToVariableMap :: Id -> P.Type -> Sems ()
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

lookupInVariableMap :: Id -> Sems (Maybe P.Type)
lookupInVariableMap = lookupInMap getVariableMap

lookupInLabelMap :: Id -> Sems (Maybe Bool)
lookupInLabelMap = lookupInMap getLabelMap

lookupInCallableMap :: Id -> Sems (Maybe Callable)
lookupInCallableMap = lookupInMap getCallableMap

searchVarInSymTabs :: Id -> Sems P.Type
searchVarInSymTabs id =
  getSymTabs >>= searchInSymTabs variableMap id "Undeclared variable: "

searchCallableInSymTabs :: Id -> Sems Callable
searchCallableInSymTabs id = getSymTabs >>= 
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
