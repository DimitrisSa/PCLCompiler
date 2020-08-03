module InsToSymTabLabels where
import Prelude hiding (lookup)
import Common

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ $ \label -> getLabelMap >>= lookup label >>> \case 
  Nothing -> insToLabelMap label False
  _       -> errAtId duplicateLabelDeclarationErr label
