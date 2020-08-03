module HeaderChildSems where
import Prelude hiding (lookup)
import Common 

headerChildSems :: Header -> Sems ()
headerChildSems = \case
  ProcHeader _ formals    -> insToSymTabFormals formals
  FuncHeader _ formals ty -> insToSymTabFormals formals >> insToSymTabResult ty

insToSymTabFormals :: [Formal] -> Sems ()
insToSymTabFormals = mapM_ insToSymTabFormal

insToSymTabFormal :: Formal -> Sems ()
insToSymTabFormal (_,ids,t) = mapM_ (insToSymTabVar t) ids

insToSymTabVar :: Type -> Id -> Sems ()
insToSymTabVar ty var = lookupInVariableMapThenFun afterVarLookup ty var

afterVarLookup ty var = \case
  Nothing -> insToVariableMap var ty 
  _       -> errAtId duplicateArgumentErr var

insToSymTabResult :: Type -> Sems ()
insToSymTabResult = insToVariableMap (dummy "result")
