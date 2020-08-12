module StmtSems where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

labelCases :: Id -> Maybe Bool -> Sems ()
labelCases id = \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId dupLabErr id
  Nothing    -> errAtId "Undeclared label: " id

goToCases :: Id -> Maybe Bool -> Sems ()
goToCases id = \case
  Nothing -> errAtId "Goto undefined label: " id
  _       -> return ()

boolCases li co err = \case
  BoolT -> return ()
  _     -> errPos li co $ "Non-boolean expression in " ++ err

pointerCases li co err = \case
  Pointer t -> return t
  _         -> errPos li co err

newPointerCases li co = pointerCases li co "non-pointer in new statement"

caseFalseThrowErr li co err = \case
  True -> return ()
  _    -> errPos li co err

newNoExprSems li co = newPointerCases li co >=> fullType >>>
  caseFalseThrowErr li co "new l statement: l must not be of type ^array of t"

newExprSems li co (et,lt) =
  intCases li co et >> newPointerCases li co lt >>= fullType >>> not >>>
  caseFalseThrowErr li co "new [e] l statement: l must be of type ^array of t"

dispPointerCases li co = pointerCases li co dispNonPointErr

dispWithoutSems li co = dispPointerCases li co >=> fullType >>>
  caseFalseThrowErr li co "dispose l statement: l must not be of type ^array of t"

dispWithSems li co = dispPointerCases li co >=> fullType >>> not >>>
  caseFalseThrowErr li co "dispose [] l statement: l must be of type ^array of t"

notStrLiteralSems li co = symbatos >>>
  caseFalseThrowErr li co "type mismatch in assignment"

intCases li co = \case
  IntT -> return ()
  _    -> errPos li co "new [e] l statement: e must be of type integer" 
