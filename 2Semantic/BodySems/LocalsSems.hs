module LocalsSems where
import Common
import Data.Function (on)

forwardSems :: Header -> Sems ()
forwardSems = \case
  ProcHeader id fs   -> checkId id >> checkFrmls id fs >> insProcDclrToMap id fs
  FuncHeader id fs t -> checkId id >> checkFrmlsType id fs t >> insFuncDclrToMap id fs t

insProcDclrToMap id fs = insToCallableMap id (ProcDclr $ reverse fs)
insFuncDclrToMap id fs t = insToCallableMap id (FuncDclr (reverse fs) t)
checkFrmlsType id fs t = checkFrmls id fs >> checkType id t

checkId :: Id -> Sems ()
checkId id = lookupInCallableMap id >>= \case
  Nothing -> return ()
  _       -> errAtId duplicateCallableErr id

checkFrmls :: Id -> [Frml] -> Sems ()
checkFrmls id fs = mapM_ (checkFrml id) fs

checkFrml :: Id -> Frml -> Sems ()
checkFrml id = \case
  (Value,_,Array _ _) -> errAtId "Can't pass array by value in: " id;
  _                   -> return ()

checkType :: Id -> Type -> Sems ()
checkType id = \case
  Array _ _ -> errAtId "Function can't have a return type of array " id
  _         -> return ()

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ $ \label -> lookupInLabelMap label >>= \case 
  Nothing -> insToLabelMap label False
  _       -> errAtId "Duplicate label declaration: " label

varsWithTypeListSems :: [([Id],Type)] -> Sems ()
varsWithTypeListSems = mapM_ insToSymTabVarsWithType 

insToSymTabVarsWithType :: ([Id],Type) -> Sems ()
insToSymTabVarsWithType (vars,ty) = mapM_ (insToSymTabVarWithType ty) $ reverse vars
  
insToSymTabVarWithType :: Type -> Id -> Sems ()
insToSymTabVarWithType ty var = lookupInVariableMap var >>= \case 
  Nothing -> afterVarLookupOk ty var
  _       -> errAtId "Duplicate Variable: " var

afterVarLookupOk :: Type -> Id -> Sems ()
afterVarLookupOk ty var = case fullType ty of
  True -> insToVariableMap var ty 
  _    -> errAtId "Can't declare 'array of': " var

checkUndefDclrs :: Sems ()
checkUndefDclrs = getCallableMap >>= toList >>> mapM_ (\case
  (id,ProcDclr _  ) -> errAtId "No definition for procedure declaration: " id
  (id,FuncDclr _ _) -> errAtId "No definition for function declaration: " id
  _                 -> return ())

headerChildSems :: Header -> Sems ()
headerChildSems = \case
  ProcHeader _ formals     -> insToSymTabFrmls formals
  FuncHeader id formals ty -> insToSymTabFrmls formals >> setEnv (InFunc id ty False)

insToSymTabFrmls :: [Frml] -> Sems ()
insToSymTabFrmls = mapM_ insToSymTabFrml

insToSymTabFrml :: Frml -> Sems ()
insToSymTabFrml (_,ids,t) = mapM_ (insToSymTabVar t) ids

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
  ProcHeader id fs    -> lookupInCallableMap id >>= procCases id (reverse fs)
  FuncHeader id fs ty -> lookupInCallableMap id >>= funcCases id (reverse fs) ty

procCases :: Id -> [Frml] -> Maybe Callable -> Sems ()
procCases id fs = \case
  Just (ProcDclr fs') -> insToSymTabIfFrmlsMatch id fs fs'
  Nothing             -> checkFrmls id fs >> insToCallableMap id (Proc fs)
  _                   -> errAtId duplicateCallableErr id

funcCases :: Id -> [Frml] -> Type -> Maybe Callable -> Sems ()
funcCases id fs ty = \case
  Just (FuncDclr fs' ty') -> insToSymTabIfFrmlsAndTypeMatch id fs fs' ty ty'
  Nothing                 -> checkFrmlsType id fs ty >> insToCallableMap id (Func fs ty)
  _                       -> errAtId duplicateCallableErr id

insToSymTabIfFrmlsMatch :: Id -> [Frml] -> [Frml] -> Sems ()
insToSymTabIfFrmlsMatch id fs fs' = sameTypes id fs fs' >> insToCallableMap id (Proc fs)

insToSymTabIfFrmlsAndTypeMatch :: Id -> [Frml] -> [Frml] -> Type -> Type -> Sems ()
insToSymTabIfFrmlsAndTypeMatch id fs fs' ty ty' = do
  sameTypes id fs fs'
  case ty == ty' of
    True -> insToCallableMap id (Func fs ty)
    _    -> errAtId "Result type missmatch between declaration and definition for: " id


sameTypes :: Id -> [Frml] -> [Frml] -> Sems ()
sameTypes id fs fs' = case ((==) `on` formalsToTypes) fs fs' of
  True -> return ()
  _    -> errAtId "Parameter type missmatch between declaration and definition for: " id

duplicateCallableErr = "Duplicate Function/Procedure name: "

