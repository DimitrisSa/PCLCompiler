module StmtSems where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

labelCases :: Id -> Maybe Bool -> Sems ()
labelCases id = \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId dupLabErr id
  Nothing    -> errAtId undefLabErr id

goToCases :: Id -> Maybe Bool -> Sems ()
goToCases id = \case
  Nothing -> errAtId undefLabErr id
  _       -> return ()

boolCases li co err = \case
  BoolT -> return ()
  _     -> left $ errPos li co ++ nonBoolErr ++ err

pointerCases li co err = \case
  Pointer t -> return t
  _         -> left $ errPos li co ++ err

intCases li co = \case
  IntT -> return ()
  _    -> left $ errPos li co ++ nonIntNewErr 
