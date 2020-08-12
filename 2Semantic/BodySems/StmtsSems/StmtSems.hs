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

newPointerCases li co = pointerCases li co nonPointNewErr

newNoExprSems li co = newPointerCases li co >=> fullType >>> \case
  True -> return ()
  _    -> left $ errPos li co ++ "new l statement: l must not be of type ^array of t"

newExprSems li co (et,lt) =
  intCases li co et >>
  newPointerCases li co lt >>= fullType >>> \case
    False -> return ()
    _     -> left $ errPos li co ++ "new [e] l statement: l must be of type ^array of t"

intCases li co = \case
  IntT -> return ()
  _    -> left $ errPos li co ++ "new [e] l statement: e must be of type integer" 
