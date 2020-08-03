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

type VariableMap = Map Id Type
type LabelMap    = Map Id Bool
type CallableMap = Map Id Callable
type NewMap      = Map LVal ()
type Error       = String
type Sems a      = EitherT Error (State [SymbolTable]) a

emptySymbolTable = SymbolTable empty empty empty empty 

infixl 9 >>>
(>>>) = (flip (.))

getMap :: (SymbolTable -> a) -> Sems a
getMap map = get >>= head >>> map >>> return

getVariableMap :: Sems VariableMap
getVariableMap = getMap variableMap

getLabelMap :: Sems LabelMap
getLabelMap = getMap labelMap

getCallableMap :: Sems CallableMap
getCallableMap = getMap callableMap

insToVariableMap :: Id -> Type -> Sems ()
insToVariableMap var ty =
  modify $ \(st:sts) -> st { variableMap = insert var ty $ variableMap st }:sts

insToLabelMap :: Id -> Bool -> Sems ()
insToLabelMap label b =
  modify $ \(st:sts) -> st { labelMap = insert label b $ labelMap st }:sts

insToCallableMap :: Id -> Callable -> Sems ()
insToCallableMap id cal =
  modify $ \(st:sts) -> st { callableMap = insert id cal $ callableMap st }:sts

lookupInVariableMapThenFun :: (Type -> Id -> Maybe Type -> Sems ()) -> Type -> Id -> Sems()
lookupInVariableMapThenFun f ty id = getVariableMap >>= lookup id >>> f ty id 
