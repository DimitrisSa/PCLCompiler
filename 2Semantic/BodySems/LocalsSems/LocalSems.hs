module LocalSems where
import Prelude hiding (lookup)
import Common

forwardSems :: Header -> Sems ()
forwardSems h = case h of
  ProcHeader i a   -> insToSymTabForwardHeader i a (ProcDeclaration $ reverse a)
  FuncHeader i a t -> case t of
    Array _ _ -> errAtId funcResTypeErr i
    _         -> insToSymTabForwardHeader i a (FuncDeclaration (reverse a) t)

insToSymTabForwardHeader :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabForwardHeader id fs t = getCallableMap >>= lookup id >>> \case
  Nothing -> insToSymTabIfFormalsOk id fs t
  _       -> errAtId duplicateCallableErr id

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ $ \label -> getLabelMap >>= lookup label >>> \case 
  Nothing -> insToLabelMap label False
  _       -> errAtId duplicateLabelDeclarationErr label

varsWithTypeListSems :: [([Id],Type)] -> Sems ()
varsWithTypeListSems = mapM_ insToSymTabVarsWithType 

insToSymTabVarsWithType :: ([Id],Type) -> Sems ()
insToSymTabVarsWithType (vars,ty) = mapM_ (insToSymTabVarWithType ty) $ reverse vars
  
insToSymTabVarWithType :: Type -> Id -> Sems ()
insToSymTabVarWithType ty var = lookupInVariableMap var >>= \case 
  Nothing -> afterVarLookupOk ty var
  _       -> errAtId duplicateVariableErr var

afterVarLookupOk :: Type -> Id -> Sems ()
afterVarLookupOk ty var = case checkFullType ty of
  True -> insToVariableMap var ty 
  _    -> errAtId arrayOfDeclarationErr var

checkUndefDeclarations :: Sems ()
checkUndefDeclarations = getCallableMap >>= toList >>>  mapM_ checkUndefDeclaration

checkUndefDeclaration :: (Id,Callable) -> Sems ()
checkUndefDeclaration = \case
  (id,ProcDeclaration _  ) -> errAtId undefinedDeclarationErr id
  (id,FuncDeclaration _ _) -> errAtId undefinedDeclarationErr id
  _                        -> return ()
