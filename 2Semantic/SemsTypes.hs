module SemsTypes where
import Parser (Type,Id,LValue,Formal)
import Control.Monad.State (State,get)
import Control.Monad.Trans.Either (EitherT)
import Data.Map (Map,empty)

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
type NewMap      = Map LValue ()
type Error       = String
type Sems a = EitherT Error (State [SymbolTable]) a

emptySymbolTable = SymbolTable empty empty empty empty 

getVariableMap :: Sems VariableMap
getVariableMap = return . variableMap . head =<< get

getLabelMap :: Sems LabelMap
getLabelMap = return . labelMap . head =<< get

getCallableMap :: Sems CallableMap
getCallableMap = return . callableMap . head =<< get
