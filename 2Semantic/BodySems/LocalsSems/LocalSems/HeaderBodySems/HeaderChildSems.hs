module HeaderChildSems where
import Prelude hiding (lookup)
import Common 

headerChildSems :: Header -> Sems ()
headerChildSems = \case
  ProcHeader _ formals     -> insToSymTabFormals formals
  FuncHeader id formals ty -> insToSymTabFormals formals >> setEnv (InFunc id ty False)

insToSymTabFormals :: [Formal] -> Sems ()
insToSymTabFormals = mapM_ insToSymTabFormal

insToSymTabFormal :: Formal -> Sems ()
insToSymTabFormal (_,ids,t) = mapM_ (insToSymTabVar t) ids

insToSymTabVar :: Type -> Id -> Sems ()
insToSymTabVar ty var = lookupInVariableMapThenFun afterVarLookup ty var

afterVarLookup ty var = \case
  Nothing -> insToVariableMap var ty 
  _       -> errAtId duplicateArgumentErr var
