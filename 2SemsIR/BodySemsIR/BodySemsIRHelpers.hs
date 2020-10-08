module BodySemsIRHelpers where
import Prelude hiding (abs,cos,sin,tan,sqrt,exp,pi,round)
import SemsCodegen (writeInteger,writeBoolean,writeChar,writeReal,writeString,readString
                   ,readInteger,readBoolean,readChar,readReal,abs,fabs,sqrt,sin,cos,tan
                   ,arctan,exp,ln,pi,trunc,round,ordOp,chr,call,getElemPtrInBounds
                   ,callVoid)
import Parser (ArrSize(..),Frml,Id(..),idString,Type(..),PassBy(..))
import SemsIRTypes (TyOper,Sems,(>>>),errAtId,errPos)
import Helpers (symbatos,formalsToTypes)
import Control.Monad.Trans.Either (right)
import LLVM.AST (Operand)

callStmtSemsIR :: Id -> [Frml] -> [TyOper] -> Sems ()
callStmtSemsIR id fs typeOpers = do
  formalsExprsTypesMatch 1 id (formalsToTypes fs) typeOpers
  args <- mapM typeOperToArg typeOpers
  callVoid (idToFunOper id) args

callRValueSemsIR :: Id -> [Frml] -> Type -> [TyOper] -> Sems TyOper
callRValueSemsIR id fs t typeOpers = do
  formalsExprsTypesMatch 1 id (formalsToTypes fs) typeOpers
  args <- mapM typeOperToArg typeOpers
  op <- call (idToFunOper id) args
  right (t,op)

typeOperToArg :: TyOper -> Sems Operand
typeOperToArg (ty,op) = case ty of
  Array (Size _) t -> getElemPtrInBounds op 0
  _                -> return op

type ByTy = (PassBy,Type)

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [TyOper] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,(t2,_):t2s) -> formalExprTypeMatch i id t1 t2 t1s t2s $ symbatos (t1,t2)
  ((Reference,t1):t1s,(t2,_):t2s) -> formalExprTypeMatch i id t1 t2 t1s t2s $
                                   symbatos (Pointer t1, Pointer t2)
  ([],[])                     -> return ()
  _                           -> errAtId "Wrong number of arguments in call of: " id

formalExprTypeMatch :: Int -> Id -> Type -> Type -> [ByTy] -> [TyOper] -> Bool -> Sems ()
formalExprTypeMatch i id t1 t2 t1s t2s = \case 
  True -> formalsExprsTypesMatch (i+1) id t1s t2s
  _    -> errorAtArg i id t1 t2

errorAtArg :: Int -> Id -> Type -> Type ->Sems ()
errorAtArg i (Id posn str) t1 t2 =
  errPos posn $ concat ["Type mismatch at argument "
                       ,show i
                       ," in call of: "
                       , str
                       ," expected type: "
                       , show t1
                       ," given type: "
                       , show t2]

idToFunOper = idString >>> \case
  "writeInteger" -> writeInteger
  "writeBoolean" -> writeBoolean
  "writeChar"    -> writeChar 
  "writeReal"    -> writeReal
  "writeString"  -> writeString 
  "readString"   -> readString
  "readInteger"  -> readInteger
  "readBoolean"  -> readBoolean
  "readChar"     -> readChar
  "readReal"     -> readReal
  "abs"          -> abs
  "fabs"         -> fabs
  "sqrt"         -> sqrt
  "sin"          -> sin
  "cos"          -> cos
  "tan"          -> tan
  "arctan"       -> arctan
  "exp"          -> exp
  "ln"           -> ln
  "pi"           -> pi
  "trunc"        -> trunc
  "round"        -> round
  "ord"          -> ordOp
  "chr"          -> chr
  _              -> undefined
