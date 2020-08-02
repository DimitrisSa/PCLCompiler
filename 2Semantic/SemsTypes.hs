module SemsTypes where
import Parser (Type,Id,LValue,Formal)
import Control.Monad.State (State)
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
