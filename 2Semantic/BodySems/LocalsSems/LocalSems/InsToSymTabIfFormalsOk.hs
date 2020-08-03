module InsToSymTabIfFormalsOk where
import Prelude hiding (lookup)
import Common

insToSymTabIfFormalsOk :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabIfFormalsOk id fs cal = case all formalOk fs of
  True -> insToCallableMap id cal
  _    -> errAtId arrByValErr id

formalOk :: Formal -> Bool
formalOk = \case (Value,_,Array _ _) -> False; _ -> True
