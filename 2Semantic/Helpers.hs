module Helpers where
import Prelude hiding (lookup)
import SemsTypes
import SemsErrs
import Control.Monad.State
import Parser
import Data.Map
import Control.Monad.Trans.Either

checkFullType :: Type -> Bool
checkFullType = \case
  ArrayT NoSize _ -> False
  _               -> True

symbatos :: Type -> Type -> Bool
symbatos (PointerT (ArrayT NoSize t1)) (PointerT (ArrayT (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) || (lt == Treal && et == Tint)

insToSymTabIfFormalsOk :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabIfFormalsOk id fs cal = case all formalOk fs of
  True -> modify $ \(st:sts) -> st { callableMap = insert id cal $ callableMap st }:sts 
  _    -> errAtId arrByValErr id

formalOk :: Formal -> Bool
formalOk = \case (Value,_,ArrayT _ _) -> False; _ -> True

dummy :: String -> Id
dummy s = Id s 0 0 
