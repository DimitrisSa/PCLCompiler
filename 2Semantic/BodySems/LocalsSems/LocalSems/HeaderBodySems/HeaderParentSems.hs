module HeaderParentSems where
import Prelude hiding (lookup)
import Common hiding (map)
import Data.Function
import InsToSymTabIfFormalsOk (insToSymTabIfFormalsOk)

headerParentSems :: Header -> Sems ()
headerParentSems = \case
  ProcHeader id formals    -> headerProcSems id (reverse formals)
  FuncHeader id formals ty -> headerFuncSems id (reverse formals) ty

headerProcSems :: Id -> [Formal] -> Sems ()
headerProcSems id fs = getCallableMap >>= lookup id >>> \case
  Just (ProcDeclaration fs') -> insToSymTabIfFormalsMatch id fs fs'
  Nothing                    -> insToSymTabIfFormalsOk id fs $ Proc fs
  _                          -> errAtId duplicateCallableErr id

headerFuncSems :: Id -> [Formal] -> Type -> Sems ()
headerFuncSems id fs ty = getCallableMap >>= lookup id >>> \case
  Just (FuncDeclaration fs' ty') -> insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty'
  Nothing                        -> insToSymTabIfFormalsAndTypeOk id fs ty
  _                              -> errAtId duplicateCallableErr id

insToSymTabIfFormalsMatch :: Id -> [Formal] -> [Formal] -> Sems ()
insToSymTabIfFormalsMatch id fs fs' = do
  sameTypes id fs fs'
  insToCallableMap id (Proc fs)

insToSymTabIfFormalsAndTypeMatch :: Id -> [Formal] -> [Formal] -> Type -> Type -> Sems ()
insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty' = do
  sameTypes id fs fs'
  case ty == ty' of
    True -> insToCallableMap id (Func fs ty)
    _    -> errAtId resultTypeMismatchErr id

insToSymTabIfFormalsAndTypeOk id fs = \case 
  Array _ _ -> errAtId funcResTypeErr id
  t          -> insToSymTabIfFormalsOk id fs $ Func fs t

sameTypes :: Id -> [Formal] -> [Formal] -> Sems ()
sameTypes id (f:fs) (f':fs') = case ((==) `on` formalToType) f f' of
  True -> sameTypes id fs fs'
  _    -> errAtId paramenterTypeMismatchErr id
sameTypes _ [] [] = return ()
sameTypes id _  _  = errAtId paramenterTypeMismatchErr id

formalToType :: Formal -> (PassBy,Type,Int)
formalToType (pb,ids,ty) = (pb,ty,length ids)
