module HeaderBodySems where
import Common 
import Data.Function (on)

headerChildSems :: Header -> Sems ()
headerChildSems = \case
  ProcHeader _ formals     -> insToSymTabFormals formals
  FuncHeader id formals ty -> insToSymTabFormals formals >> setEnv (InFunc id ty False)

insToSymTabFormals :: [Formal] -> Sems ()
insToSymTabFormals = mapM_ insToSymTabFormal

insToSymTabFormal :: Formal -> Sems ()
insToSymTabFormal (_,ids,t) = mapM_ (insToSymTabVar t) ids

insToSymTabVar :: Type -> Id -> Sems ()
insToSymTabVar ty var = lookupInVariableMap var >>= \case
  Nothing -> insToVariableMap var ty 
  _       -> errAtId "Duplicate Argument: " var

checkResult :: Sems ()
checkResult = getEnv >>= \case
  InFunc id _ False -> errAtId "Result not set for function: " id
  _                 -> return ()

headerParentSems :: Header -> Sems ()
headerParentSems = \case
  ProcHeader id formals    -> lookupInCallableMap id >>= procCases id (reverse formals)
  FuncHeader id formals ty -> lookupInCallableMap id >>= funcCases id (reverse formals) ty

procCases :: Id -> [Formal] -> Maybe Callable -> Sems ()
procCases id fs = \case
  Just (ProcDeclaration fs') -> insToSymTabIfFormalsMatch id fs fs'
  Nothing                    -> insToSymTabIfFormalsOk id fs $ Proc fs
  _                          -> errAtId duplicateCallableErr id

funcCases :: Id -> [Formal] -> Type -> Maybe Callable -> Sems ()
funcCases id fs ty = \case
  Just (FuncDeclaration fs' ty') -> insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty'
  Nothing                        -> insToSymTabIfFormalsAndTypeOk id fs ty
  _                              -> errAtId duplicateCallableErr id

insToSymTabIfFormalsMatch :: Id -> [Formal] -> [Formal] -> Sems ()
insToSymTabIfFormalsMatch id fs fs' = sameTypes id fs fs' >> insToCallableMap id (Proc fs)

insToSymTabIfFormalsAndTypeMatch :: Id -> [Formal] -> [Formal] -> Type -> Type -> Sems ()
insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty' = do
  sameTypes id fs fs'
  case ty == ty' of
    True -> insToCallableMap id (Func fs ty)
    _    -> errAtId "Result type missmatch between declaration and definition for: " id

insToSymTabIfFormalsAndTypeOk id fs = \case 
  Array _ _ -> errAtId funcResTypeErr id
  t         -> insToSymTabIfFormalsOk id fs $ Func fs t

sameTypes :: Id -> [Formal] -> [Formal] -> Sems ()
sameTypes id fs fs' = case ((==) `on` formalsToTypes) fs fs' of
  True -> return ()
  _    -> errAtId "Parameter type missmatch between declaration and definition for: " id
