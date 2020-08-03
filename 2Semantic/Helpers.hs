module Helpers where
import Parser
import SemsTypes
import Control.Monad.Trans.Either

checkFullType :: Type -> Bool
checkFullType = \case Array NoSize _ -> False; _ -> True

symbatos :: Type -> Type -> Bool
symbatos (Pointer (Array NoSize t1)) (Pointer (Array (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) || (lt == Real' && et == Int')

symbatos' :: Type -> Type -> Error -> Sems ()
symbatos' t1 t2 err = case symbatos t1 t2 of True -> return (); _ -> left err

dummy :: String -> Id
dummy s = Id s 0 0 
