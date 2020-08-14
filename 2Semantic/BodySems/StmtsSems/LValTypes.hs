module LValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

resultType :: (Int,Int) -> Sems Type
resultType posn = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> errPos posn "Result in procedure"

dereferenceCases posn = \case
  Pointer t -> right t
  Nil       -> errPos posn "dereferencing Nil pointer"
  _         -> errPos posn "dereferencing non-pointer"

indexingCases posn = \case
  (Array _ t,IntT) -> right t
  (_        ,IntT) -> errPos posn "indexing non-array"
  _                -> errPos posn "non-integer index"
