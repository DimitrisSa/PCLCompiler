module InsToSymTabLabels where
import Prelude hiding (lookup)
import Common

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ insToSymTabLabel

insToSymTabLabel :: Id -> Sems ()
insToSymTabLabel label = afterlabelLookup label . lookup label =<< getLabelMap 

afterlabelLookup :: Id -> Maybe Bool -> Sems ()
afterlabelLookup label = \case 
  Nothing -> insToLabelMap label False
  _       -> errAtId duplicateLabelDeclarationErr label
