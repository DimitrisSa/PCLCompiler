module LValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

idType :: Id -> Sems Type
idType id = searchVarInSymTabs id 

resultType :: Int -> Int -> Sems Type
resultType li co = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> left $ errPos li co ++ resultNoFunErr

dereferenceCases li co = \case
  Pointer t -> right t
  Nil       -> left $ errPos li co ++ "dereferencing Nil pointer"
  _         -> left $ errPos li co ++ pointErr

indexingCases li co = \case
  (IntT,Array _ t)-> right t
  (IntT,__)       -> left $ errPos li co ++ arrErr
  _               -> left $ errPos li co ++ indErr
