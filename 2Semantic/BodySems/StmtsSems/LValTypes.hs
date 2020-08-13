module LValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

resultType :: Int -> Int -> Sems Type
resultType li co = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> errPos li co "Result in procedure"

dereferenceCases li co = \case
  Pointer t -> right t
  Nil       -> errPos li co "dereferencing Nil pointer"
  _         -> errPos li co "dereferencing non-pointer"

indexingCases li co = \case
  (Array _ t,IntT) -> right t
  (_        ,IntT) -> errPos li co "indexing non-array"
  _                -> errPos li co "non-integer index"
