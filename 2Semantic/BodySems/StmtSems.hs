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

boolCases :: (Int,Int) -> String -> TyOper -> Sems ()
boolCases posn err = \case
  (BoolT,_) -> return ()
  _         -> errPos posn $ "Non-boolean expression in " ++ err

pointerCases :: (Int,Int) -> String -> TyOper -> Sems TyOper
pointerCases posn err = \case
  (Pointer t,op) -> return (t,undefined)
  _              -> errPos posn err

newPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
newPointerCases posn = pointerCases posn "non-pointer in new statement"

caseFalseThrowErr :: (Int,Int) -> String -> Bool -> Sems ()
caseFalseThrowErr posn err = \case
  True -> return ()
  _    -> errPos posn err

newNoExprSems :: (Int,Int) -> TyOper -> Sems ()
newNoExprSems posn = newPointerCases posn >=> fst >>> fullType >>>
  caseFalseThrowErr posn "new l statement: l must not be of type ^array of t"

newExprSems :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
newExprSems posn (eto,lto) =
  intCases posn eto >> newPointerCases posn lto >>= fst >>> fullType >>> not >>>
  caseFalseThrowErr posn "new [e] l statement: l must be of type ^array of t"

dispPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
dispPointerCases posn = pointerCases posn "non-pointer in dispose statement"

dispWithoutSems :: (Int,Int) -> TyOper -> Sems ()
dispWithoutSems posn = dispPointerCases posn >=> fst >>> fullType >>>
  caseFalseThrowErr posn "dispose l statement: l must not be of type ^array of t"

dispWithSems :: (Int,Int) -> TyOper -> Sems ()
dispWithSems posn = dispPointerCases posn >=> fst >>> fullType >>> not >>>
  caseFalseThrowErr posn "dispose [] l statement: l must be of type ^array of t"

notStrLiteralSems :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
notStrLiteralSems posn ((t1,_),(t2,_)) = 
  caseFalseThrowErr posn ("type mismatch in assignment" ++ show t1 ++ show t2)
      (symbatos (t1,t2))

intCases posn = \case
  (IntT,op) -> return ()
  _         -> errPos posn "new [e] l statement: e must be of type integer" 
