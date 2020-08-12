module LocalsSems where
import Common

forwardSems :: Header -> Sems ()
forwardSems = \case
  ProcHeader i a   -> insToSymTabForwardHeader i a (ProcDeclaration $ reverse a)
  FuncHeader i a t -> case t of
    Array _ _ -> errAtId funcResTypeErr i
    _         -> insToSymTabForwardHeader i a (FuncDeclaration (reverse a) t)

insToSymTabForwardHeader :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabForwardHeader id fs t = lookupInCallableMap id >>= \case
  Nothing -> insToSymTabIfFormalsOk id fs t
  _       -> errAtId duplicateCallableErr id

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
  _    -> errAtId arrayOfDeclarationErr var

checkUndefDeclarations :: Sems ()
checkUndefDeclarations = getCallableMap >>= toList >>> mapM_ (\case
  (id,ProcDeclaration _  ) -> errAtId "No definition for procedure declaration: " id
  (id,FuncDeclaration _ _) -> errAtId "No definition for function declaration: " id
  _                        -> return ())
