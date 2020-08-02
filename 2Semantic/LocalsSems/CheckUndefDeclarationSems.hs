module CheckUndefDeclarationSems where
import Prelude hiding (lookup)
import Common

checkUndefDeclarationSems :: Sems ()
checkUndefDeclarationSems = checkUndefDeclarationInList . toList =<< getCallableMap

checkUndefDeclarationInList :: [(Id,Callable)] -> Sems ()
checkUndefDeclarationInList = mapM_ checkUndefDeclaration

checkUndefDeclaration :: (Id,Callable) -> Sems ()
checkUndefDeclaration = \case
  (id,ProcDeclaration _  ) -> errAtId undefinedDeclarationErr id
  (id,FuncDeclaration _ _) -> errAtId undefinedDeclarationErr id
  _                        -> return ()
