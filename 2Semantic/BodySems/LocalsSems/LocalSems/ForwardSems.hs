module ForwardSems where
import Prelude hiding (lookup)
import Common

forwardSems :: Header -> Sems ()
forwardSems h = case h of
  ProcHeader i a   -> insToSymTabForwardHeader i a (ProcDeclaration $ reverse a)
  FuncHeader i a t -> case t of
    ArrayT _ _ -> errAtId funcResTypeErr i
    _          -> insToSymTabForwardHeader i a (FuncDeclaration (reverse a) t)

insToSymTabForwardHeader :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabForwardHeader id fs t =
  afterForwardHeaderLookup id fs t . lookup id =<< getCallableMap

afterForwardHeaderLookup id fs t = \case
  Nothing -> insToSymTabIfFormalsOk id fs t
  _       -> errAtId duplicateCallableErr id
