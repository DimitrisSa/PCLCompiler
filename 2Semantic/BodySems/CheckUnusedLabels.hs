module CheckUnusedLabels where
import Prelude hiding (lookup)
import Common

checkUnusedLabels :: Sems ()
checkUnusedLabels = checkFalseLabelValueInList . toList =<< getLabelMap

checkFalseLabelValueInList :: [(Id,Bool)] -> Sems ()
checkFalseLabelValueInList = mapM_ $ \case
  (id,False) -> errAtId unusedLabelErr id
  _          -> return ()
