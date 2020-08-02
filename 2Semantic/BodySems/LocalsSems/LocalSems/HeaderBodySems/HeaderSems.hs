module HeaderSems where
import Prelude hiding (lookup)
import Common hiding (map)
import InsToSymTabIfFormalsOk (insToSymTabIfFormalsOk)

headerSems :: Header -> Sems ()
headerSems = \case
  ProcHeader id formals    -> headerProcSems id (reverse formals)
  FuncHeader id formals ty -> headerFuncSems id (reverse formals) ty

headerProcSems :: Id -> [Formal] -> Sems ()
headerProcSems id fs = afterProcIdLookup id fs . lookup id =<< getCallableMap

headerFuncSems :: Id -> [Formal] -> Type -> Sems ()
headerFuncSems id fs ty = afterFuncIdLookup id fs ty . lookup id =<< getCallableMap

afterProcIdLookup :: Id -> [Formal] -> Maybe Callable -> Sems ()
afterProcIdLookup id fs = \case
  Just (ProcDeclaration fs') -> insToSymTabIfFormalsMatch id fs fs'
  Nothing                    -> insToSymTabIfFormalsOk id fs $ Proc fs
  _                          -> errAtId duplicateCallableErr id

afterFuncIdLookup :: Id -> [Formal] -> Type -> Maybe Callable -> Sems ()
afterFuncIdLookup id fs ty = \case
  Just (FuncDeclaration fs' ty') -> insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty'
  Nothing                        -> insToSymTabIfFormalsAndTypeOk id fs ty
  _                              -> errAtId duplicateCallableErr id

insToSymTabIfFormalsMatch :: Id -> [Formal] -> [Formal] -> Sems ()
insToSymTabIfFormalsMatch id fs fs' = insToSymTabIfGood id (Proc fs) $ sameTypes fs fs'

insToSymTabIfFormalsAndTypeMatch :: Id -> [Formal] -> [Formal] -> Type -> Type -> Sems ()
insToSymTabIfFormalsAndTypeMatch id fs fs' ty ty' = 
  insToSymTabIfGood id (Func fs ty) $ ty==ty' && sameTypes fs fs'

insToSymTabIfFormalsAndTypeOk id fs = \case 
  ArrayT _ _ -> errAtId funcResTypeErr id
  t          -> insToSymTabIfFormalsOk id fs $ Func fs t

insToSymTabIfGood :: Id -> Callable -> Bool -> Sems ()
insToSymTabIfGood id cal = \case
  True -> insToCallableMap id cal 
  _    -> errAtId typeMismatchErr id

sameTypes :: [Formal] -> [Formal] -> Bool
sameTypes (f:fs) (f':fs') = case formalToType f == formalToType f' of
  True -> sameTypes fs fs'
  _    -> False  
sameTypes [] [] = True
sameTypes _  _ = True

formalToType :: Formal -> (PassBy,Type,Int)
formalToType (pb,ids,ty) = (pb,ty,length ids)
