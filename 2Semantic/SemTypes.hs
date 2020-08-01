module SemTypes where
import Parser (Type,Id,LValue,Args)
import Control.Monad.State (State)
import Control.Monad.Trans.Either (EitherT)
import Data.Map (Map,empty)

data Callable =
  Proc Args                  |
  Func Args Type             |
  ProcDeclaration Args       |
  FuncDeclaration Args Type
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
type Semantics a = EitherT Error (State [SymbolTable]) a

emptySymbolTable = SymbolTable empty empty empty empty 
