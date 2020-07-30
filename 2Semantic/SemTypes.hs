{-# LANGUAGE DeriveFunctor,GeneralizedNewtypeDeriving #-}

module SemTypes where
import Parser 
import Control.Monad.State
import Control.Monad.Trans.Either
import qualified Data.Map as M

data Callable =
  Procedure Args                  |
  Function Args Type              |
  ProcedureDeclaration Args       |
  FunctionDeclaration Args Type
  deriving(Show,Eq)

type VariableMap = M.Map Id Type
type LabelMap    = M.Map Id Bool
type CallableMap = M.Map Id Callable
type NewMap      = M.Map LValue ()
type SymbolTable = (VariableMap,LabelMap,CallableMap,NewMap)
type Error       = String
type Semantics a = EitherT Error (State [SymbolTable]) a

emptySymbolTable = (M.empty,M.empty,M.empty,M.empty)
