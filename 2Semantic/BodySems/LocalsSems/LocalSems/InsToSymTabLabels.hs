module InsToSymTabLabels where
import Prelude hiding (lookup)
import Common

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ insToSymTabLabel

insToSymTabLabel :: Id -> Sems ()
insToSymTabLabel label = afterlabelLookup label . lookup label =<< getLabelMap 

afterlabelLookup :: Id -> Maybe Bool -> Sems ()
afterlabelLookup label = \case 
  Nothing -> modify $ \(st:sts) -> st { labelMap = insert label False $ labelMap st }:sts
  _       -> errAtId duplicateLabelDeclarationErr label
