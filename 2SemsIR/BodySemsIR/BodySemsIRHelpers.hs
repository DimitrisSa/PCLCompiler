module BodySemsIRHelpers where
import SemsCodegen (call,getElemPtrInBounds,callVoid,load,sitofp)
import Parser (ArrSize(..),Frml,Id(..),idString,Type(..),PassBy(..))
import SemsIRTypes (TyOper,TyOperBool,Sems,(>>>),errAtId,errPos,searchCallableInSymTabs)
import Helpers (symbatos,formalsToTypes)
import Control.Monad.Trans.Either (right)
import LLVM.AST (Operand)
import Data.List.Index (indexed)

callStmtSemsIR' :: Id -> [Frml] -> [TyOperBool] -> Sems ()
callStmtSemsIR' id fs typeOperBools = do
  args <- formalsExprsSemsIR id (formalsToTypes fs) typeOperBools
  op <- idToFunOper id
  callVoid op args

callRValueSemsIR' :: Id -> [Frml] -> Type -> [TyOperBool] -> Sems TyOper
callRValueSemsIR' id fs t typeOperBools = do
  args <- formalsExprsSemsIR id (formalsToTypes fs) typeOperBools
  op <- idToFunOper id
  op <- call op args
  right (t,op)

type ByTy = (PassBy,Type)

formalsExprsSemsIR :: Id -> [ByTy] -> [TyOperBool] -> Sems [Operand]
formalsExprsSemsIR id byTys tyOperBools = case (byTys,tyOperBools) of
  (_:_,_:_) -> mapM (formalExprSemsIR id) $ indexed $ zip byTys tyOperBools
  ([],[])   -> return []
  _         -> errAtId "Wrong number of arguments in call of: " id

formalExprSemsIR :: Id -> (Int,(ByTy,TyOperBool)) -> Sems Operand
formalExprSemsIR id (i,(byTy,tyOperBool)) = case (byTy,tyOperBool) of
  ((Val,RealT),(IntT,op,True))  -> load op >>= sitofp
  ((Val,RealT),(IntT,op,False)) -> sitofp op
  ((Val,t1),(t2,op,True))  -> checkSymbatos i id t1 t2 >> load op
  ((Val,t1),(t2,op,False)) -> checkSymbatos i id t1 t2 >> return op
  ((Ref,t1),(t2,op,_)) -> do
    checkSymbatos i id (Pointer t1) (Pointer t2)
    case t2 of
      Array (Size _) t -> getElemPtrInBounds op 0
      _                -> return op

checkSymbatos :: Int -> Id -> Type -> Type -> Sems ()
checkSymbatos i id t1 t2 = case symbatos (t1,t2) of
  True -> return () 
  _    -> errorAtArg (i+1) id t1 t2

errorAtArg :: Int -> Id -> Type -> Type ->Sems ()
errorAtArg i (Id posn str) t1 t2 =
  errPos posn $ concat ["Type mismatch at argument ", show i
                       ," in call of: ", str
                       ," expected type: ", show t1
                       ," given type: ", show t2]

idToFunOper id = searchCallableInSymTabs id >>= \(_,op) -> return op
