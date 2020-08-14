module StmtSems where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

labelCases :: Id -> Maybe Bool -> Sems ()
labelCases id = \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId "Duplicate label: " id
  Nothing    -> errAtId "Undeclared label: " id

goToCases :: Id -> Maybe Bool -> Sems ()
goToCases id = \case
  Nothing -> errAtId "Goto undefined label: " id
  _       -> return ()

boolCases posn err = \case
  BoolT -> return ()
  _     -> errPos posn $ "Non-boolean expression in " ++ err

pointerCases posn err = \case
  Pointer t -> return t
  _         -> errPos posn err

newPointerCases posn = pointerCases posn "non-pointer in new statement"

caseFalseThrowErr posn err = \case
  True -> return ()
  _    -> errPos posn err

newNoExprSems posn = newPointerCases posn >=> fullType >>>
  caseFalseThrowErr posn "new l statement: l must not be of type ^array of t"

newExprSems posn (et,lt) =
  intCases posn et >> newPointerCases posn lt >>= fullType >>> not >>>
  caseFalseThrowErr posn "new [e] l statement: l must be of type ^array of t"

dispPointerCases posn = pointerCases posn "non-pointer in dispose statement"

dispWithoutSems posn = dispPointerCases posn >=> fullType >>>
  caseFalseThrowErr posn "dispose l statement: l must not be of type ^array of t"

dispWithSems posn = dispPointerCases posn >=> fullType >>> not >>>
  caseFalseThrowErr posn "dispose [] l statement: l must be of type ^array of t"

notStrLiteralSems posn = symbatos >>>
  caseFalseThrowErr posn "type mismatch in assignment"

intCases posn = \case
  IntT -> return ()
  _    -> errPos posn "new [e] l statement: e must be of type integer" 
