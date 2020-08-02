module Helpers where
import Prelude hiding (lookup)
import SemsTypes
import SemsErrs
import Control.Monad.State
import Parser
import Data.Map
import Control.Monad.Trans.Either

getVariableMap :: Sems VariableMap
getVariableMap = return . variableMap . head =<< get

getLabelMap :: Sems LabelMap
getLabelMap = return . labelMap . head =<< get

getCallableMap :: Sems CallableMap
getCallableMap = return . callableMap . head =<< get

checkUnusedLabels :: Sems ()
checkUnusedLabels = checkFalseLabelValueInList . toList =<< getLabelMap

checkFalseLabelValueInList :: [(Id,Bool)] -> Sems ()
checkFalseLabelValueInList = mapM_ $ \case
  (id,False) -> errAtId unusedLabelErr id
  _          -> return ()

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
