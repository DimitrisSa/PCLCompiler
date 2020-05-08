module SemTypes where
import Parser as P
import Control.Monad.State
import Control.Monad.Trans.Either
import LLVM.AST as L
import qualified Data.Map as M

data Variable =
  Var { ty :: P.Type }
  deriving(Show,Eq)

var :: P.Type -> Variable
var t = Var t

data FaP =
  FP { ca :: Callable }
  deriving(Show,Eq)

fp :: Callable -> FaP
fp t = FP t

data Callable =
  Proc Args         |
  Func Args P.Type  |
  FProc Args        |
  FFunc Args P.Type
  deriving(Show,Eq)

type VarMap   = M.Map Id Variable
type LabelMap = M.Map Id Bool
type CallMap  = M.Map Id FaP
type NewMap   = M.Map LValue ()
type SymbolMap = (VarMap,LabelMap,CallMap,NewMap)
type Error = String
type Semantics a = EitherT Error (State [SymbolMap]) a
