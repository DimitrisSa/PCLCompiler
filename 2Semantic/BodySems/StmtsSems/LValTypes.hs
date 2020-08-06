module LValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

idType :: Id -> Sems Type
idType id = get >>= snd >>> searchVarInSymTabs id (errAtId varErr id) 

resultType :: Int -> Int -> Sems Type
resultType li co = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> left $ errPos li co ++ resultNoFunErr
