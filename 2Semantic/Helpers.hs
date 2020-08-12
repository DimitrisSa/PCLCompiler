module Helpers where
import Parser
import SemsTypes
import SemsErrs
import Control.Monad.Trans.Either

checkFullType :: Type -> Bool
checkFullType = \case Array NoSize _ -> False; _ -> True

symbatos :: Type -> Type -> Bool
symbatos (Pointer (Array NoSize t1)) (Pointer (Array (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) || (lt == RealT && et == IntT)

symbatos' :: Type -> Type -> Error -> Sems ()
symbatos' t1 t2 err = case symbatos t1 t2 of True -> return (); _ -> left err

dummy :: String -> Id
dummy s = Id s 0 0 

formalsToTypes :: [Formal] -> [(PassBy,Type)]
formalsToTypes = map formalToTypes >>> concat

formalToTypes :: Formal -> [(PassBy,Type)]
formalToTypes (pb,ids,ty) = map (\_ -> (pb,ty)) ids

insToSymTabIfFormalsOk :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabIfFormalsOk id fs cal = case all formalOk fs of
  True -> insToCallableMap id cal
  _    -> errAtId arrByValErr id

formalOk :: Formal -> Bool
formalOk = \case (Value,_,Array _ _) -> False; _ -> True
