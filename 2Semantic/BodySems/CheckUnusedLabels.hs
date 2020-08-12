module CheckUnusedLabels where
import Prelude hiding (lookup)
import Common

checkUnusedLabels :: Sems ()
checkUnusedLabels = getLabelMap >>= toList >>> (mapM_ $ \case
  (id,False) -> errAtId "Label declared but not used: " id
  _          -> return ())
