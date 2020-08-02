module VarsWithTypeListSems where
import Prelude hiding (lookup)
import Common

varsWithTypeListSems :: [([Id],Type)] -> Sems ()
varsWithTypeListSems = mapM_ insToSymTabVarsWithType 

insToSymTabVarsWithType :: ([Id],Type) -> Sems ()
insToSymTabVarsWithType (vars,ty) = mapM_ (insToSymTabVarWithType ty) $ reverse vars
  
insToSymTabVarWithType :: Type -> Id -> Sems ()
insToSymTabVarWithType ty var = afterVarLookup ty var . lookup var =<< getVariableMap

afterVarLookup :: Type -> Id -> Maybe Type -> Sems ()
afterVarLookup ty var = \case 
  Nothing -> afterVarLookupOk ty var
  _       -> errAtId duplicateVariableErr var

afterVarLookupOk :: Type -> Id -> Sems ()
afterVarLookupOk ty var = case checkFullType ty of
  True -> modify $ \(st:sts) -> st { variableMap = insert var ty $ variableMap st }:sts
  _    -> errAtId arrayOfDeclarationErr var
