module SemsTypes where
import Prelude hiding (lookup)
import Parser (Type,Id,LVal,Formal)
import Control.Monad.State (State,get,modify)
import Control.Monad.Trans.Either (EitherT)
import Data.Map (Map,empty,insert,lookup)

data Callable =
  Proc [Formal]                  |
  Func [Formal] Type             |
  ProcDeclaration [Formal]       |
  FuncDeclaration [Formal] Type
  deriving(Show,Eq)

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  ,newMap      :: NewMap
  }

data Env = InProc | InFunc Id Type Bool

type VariableMap = Map Id Type
type LabelMap    = Map Id Bool
type CallableMap = Map Id Callable
type NewMap      = Map LVal ()
type Error       = String
type Sems a      = EitherT Error (State (Env,[SymbolTable])) a

emptySymbolTable = SymbolTable empty empty empty empty
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

insToNewMap :: LVal -> () -> Sems ()
insToNewMap id cal =
  modify $ \(e,st:sts) -> (e,st { newMap = insert id cal $ newMap st }:sts)

lookupInVariableMapThenFun :: (Type -> Id -> Maybe Type -> Sems ()) -> Type -> Id -> Sems()
lookupInVariableMapThenFun f ty id = getVariableMap >>= lookup id >>> f ty id 

searchVarInSymTabs :: Id -> Sems Type -> [SymbolTable] -> Sems Type
searchVarInSymTabs id err = searchInSymTabs variableMap id err

searchCallableInSymTabs :: Id -> Sems Callable -> [SymbolTable] -> Sems Callable
searchCallableInSymTabs id err = searchInSymTabs callableMap id err

searchInSymTabs :: (SymbolTable -> Map Id a) -> Id -> Sems a -> [SymbolTable] -> Sems a
searchInSymTabs map id err = \case
  st:sts -> case lookup id $ map st of
    Just t  -> return t
    Nothing -> searchInSymTabs map id err sts
  []     -> err



