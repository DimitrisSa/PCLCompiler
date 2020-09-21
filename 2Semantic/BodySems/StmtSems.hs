module StmtSems where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common
import LLVM.AST
import qualified LLVM.AST.Constant as C
import SemsCodegen

labelCases :: Id -> Maybe Bool -> Sems ()
labelCases id = \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId "Duplicate label: " id
  Nothing    -> errAtId "Undeclared label: " id

goToCases :: Id -> Maybe Bool -> Sems ()
goToCases id = \case
  Nothing -> errAtId "Goto undefined label: " id
  _       -> return ()

boolCases :: (Int,Int) -> String -> TyOper -> Sems Operand
boolCases posn err = \case
  (BoolT,op) -> return op
  _          -> errPos posn $ "Non-boolean expression in " ++ err

pointerCases :: (Int,Int) -> String -> TyOper -> Sems TyOper
pointerCases posn err = \case
  (Pointer t,op) -> return (t,op)
  _              -> errPos posn err

newPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
newPointerCases posn = pointerCases posn "non-pointer in new statement"

newNoExprSemsIR :: (Int,Int) -> TyOper -> Sems ()
newNoExprSemsIR posn (lt,lOp) = do
  (lt,lOp) <- newPointerCases posn (lt,lOp)
  caseFalseThrowErr posn "new l statement: l must not be of type ^array of t" $ fullType lt
  newPtr <- alloca $ case lOp of
    LocalReference (PointerType (PointerType ty _) _) _ -> ty
    _                      -> error "newNoExprSemsIR: should not happen"
  store lOp newPtr

newExprSems :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
newExprSems posn ((et,eOp),(lt,lOp)) = do
  intCases posn et 
  (lt,lOp) <- newPointerCases posn (lt,lOp)
  let bool = not $ fullType lt
  caseFalseThrowErr posn "new [e] l statement: l must be of type ^array of t" bool
  newPtr <- allocaNum eOp $ case lOp of
    LocalReference (PointerType (PointerType ty _) _) _ -> ty
    _                      -> error "newExprSems : should not happen"
  store lOp newPtr

intCases posn = \case
  IntT -> return ()
  _    -> errPos posn "new [e] l statement: e must be of type integer" 

caseFalseThrowErr :: (Int,Int) -> String -> Bool -> Sems ()
caseFalseThrowErr posn err = \case
  True -> return ()
  _    -> errPos posn err

dispPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
dispPointerCases posn = pointerCases posn "non-pointer in dispose statement"

dispWithoutSems :: (Int,Int) -> TyOper -> Sems ()
dispWithoutSems posn = dispPointerCases posn >=> fst >>> fullType >>>
  caseFalseThrowErr posn "dispose l statement: l must not be of type ^array of t"

dispWithSems :: (Int,Int) -> TyOper -> Sems ()
dispWithSems posn = dispPointerCases posn >=> fst >>> fullType >>> not >>>
  caseFalseThrowErr posn "dispose [] l statement: l must be of type ^array of t"

notStrLiteralSems :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
notStrLiteralSems posn ((lt,lOp),(et,eOp)) = do
  caseFalseThrowErr posn ("type mismatch in assignment -> " ++ show lt ++ " " ++ show et)
      (symbatos (lt,et))
  eOp' <- case (lt,et) of 
          (RealT,IntT)    -> sitofp eOp
          (Pointer t,Nil) -> return $ cons $ C.Null $ toTType $ Pointer t
          (Pointer (Array NoSize t1),Pointer (Array (Size _) _)) -> getElemPtrInt eOp 0
          _               -> return eOp
  store lOp eOp'
