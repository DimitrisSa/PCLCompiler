module LValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

idType :: Id -> Sems Type
idType id = get >>= snd >>> searchVarInSymTabs id 

searchVarInSymTabs :: Id -> [SymbolTable] -> Sems Type
searchVarInSymTabs id = \case
  st:sts -> case lookup id $ variableMap st of
    Just t  -> return t
    Nothing -> searchVarInSymTabs id sts
  []     -> errAtId varErr id

resultType :: Int -> Int -> Sems Type
resultType li co = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> left $ errPos li co ++ resultNoFunErr
