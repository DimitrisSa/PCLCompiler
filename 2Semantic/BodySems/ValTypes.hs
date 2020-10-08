module ValTypes where
import Prelude hiding (EQ)
import Common (Id(..),Type(..),PassBy(..),Sems,TyOper,Env(..),ArrSize(..),errAtId,errPos
              ,symbatos,setEnv,getEnv)
import Control.Monad.Trans.Either (right)
import LLVM.AST.IntegerPredicate (IntegerPredicate(..))
import SemsCodegen (icmp,cons,fsub,sub,fcmp,fdiv,fmul,fadd,sitofp,mul,add,srem,sdiv
                   ,orInstr,andInstr,getElemPtrOp',load,getElemPtrInBounds')
import LLVM.AST.Float (SomeFloat(..))
import qualified LLVM.AST.FloatingPointPredicate as FP (FloatingPointPredicate(..))
import qualified LLVM.AST.Constant as C (Constant(..))

resultType :: (Int,Int) -> Sems TyOper
resultType posn = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return (ty,undefined)
  InProc         -> errPos posn "Result in procedure"

dereferenceCases :: (Int,Int) -> TyOper -> Sems TyOper
dereferenceCases posn = \case
  (Pointer t,op) -> right (t,op)
  (Nil,_ )       -> errPos posn "dereferencing Nil pointer"
  _              -> errPos posn "dereferencing non-pointer"

indexingCases :: (Int,Int) -> (TyOper,TyOper) -> Sems TyOper
indexingCases posn = \case
  ((Array (Size _) t,lOp),(IntT,eOp)) -> do
    elemOp <- getElemPtrInBounds' lOp eOp
    right (t,elemOp)
  ((Array NoSize t,lOp),(IntT,eOp)) -> do
    lOp' <- load lOp
    elemOp <- getElemPtrOp' lOp' eOp
    right (t,elemOp)
  ((Array _ _,_)  ,(_,_)     ) -> errPos posn "non-integer index"
  _                            -> errPos posn "indexing non-array"

comparisonCases :: (Int,Int) -> String -> [TyOper] -> Sems TyOper 
comparisonCases posn a = \case
  [(IntT,op1),(IntT,op2)] -> 
    case a of
      "'='"  -> do
        eqOp <- icmp EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp NE op1 op2
        right (BoolT,diffOp)
  [(IntT,op1),(RealT,op2)] -> do 
    op1' <- sitofp op1
    case a of
      "'='"  -> do
        eqOp <- fcmp FP.OEQ op1' op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- fcmp FP.ONE op1' op2
        right (BoolT,diffOp)
  [(RealT,op1),(IntT,op2)] -> do 
    op2' <- sitofp op2
    case a of
      "'='"  -> do
        eqOp <- fcmp FP.OEQ op1 op2'
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- fcmp FP.ONE op1 op2'
        right (BoolT,diffOp)
  [(RealT,op1),(RealT,op2)] -> do 
    case a of
      "'='"  -> do
        eqOp <- fcmp FP.OEQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- fcmp FP.ONE op1 op2
        right (BoolT,diffOp)
  [(BoolT,op1),(BoolT,op2)] ->
    case a of
      "'='"  -> do
        eqOp <- icmp EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp NE op1 op2
        right (BoolT,diffOp)
  [(CharT,op1),(CharT,op2)] ->
    case a of
      "'='"  -> do
        eqOp <- icmp EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp NE op1 op2
        right (BoolT,diffOp)
  [(Pointer t1,op1),(Pointer t2,op2)] -> case t1 == t2 of
    True -> undefined
    _    -> errPos posn $ "Incomparable types at: " ++ a
  [(Pointer _,_),(Nil,_)] -> right (BoolT,cons $ C.Int 1 0)
  [(Nil,_),(Pointer _,_)] -> right (BoolT,cons $ C.Int 1 0)
  [(Nil,_),(Nil,_)]       -> right (BoolT,cons $ C.Int 1 1)
  _                       -> errPos posn $ "Incomparable types at: " ++ a

binOpBoolCases :: (Int,Int) -> String -> [TyOper] -> Sems TyOper
binOpBoolCases posn a = \case
  [(BoolT,op1),(BoolT,op2)] -> 
    case a of
      "'or'" -> do
        opOr <- orInstr op1 op2
        right (BoolT,opOr)
      "'and'" -> do
        opAnd <- andInstr op1 op2
        right (BoolT,opAnd)
  [(BoolT,_),_]     -> errPos posn $ "Non-boolean expression after: " ++ a
  _             -> errPos posn $ "Non-boolean expression before: " ++ a

binOpIntCases :: (Int,Int) -> String -> [TyOper] -> Sems TyOper
binOpIntCases posn a =  \case
  [(IntT,op1),(IntT,op2)] -> do
    case a of
      "'div'" -> do
        opDiv <- sdiv op1 op2
        right (IntT,opDiv)
      "'mod'" -> do
        opMod <- srem op1 op2
        right (IntT,opMod)
  [(IntT,_),_]   -> errPos posn $ "Non-integer expression after: " ++ a
  _              -> errPos posn $ "Non-integer expression before: " ++ a

binOpNumCases :: (Int,Int) -> Type -> Type -> String -> [TyOper] -> Sems TyOper
binOpNumCases posn intIntType restType a = \case
  [(IntT,op1),(IntT,op2)] -> 
    case a of
      "'+'" -> do
        opAdd <- add op1 op2
        right (intIntType,opAdd)
      "'*'" -> do
        opMul <- mul op1 op2
        right (intIntType,opMul)
      "'-'" -> do
        opSub <- sub op1 op2
        right (intIntType,opSub)
      "'/'" -> do
        op1' <- sitofp op1
        op2' <- sitofp op2
        opDiv <- fdiv op1' op2'
        right (intIntType,opDiv)
      "'<'" -> do
        opLess <- icmp SLT op1 op2
        right (intIntType,opLess)
      "'>'" -> do
        opGreater <- icmp SGT op1 op2
        right (intIntType,opGreater)
      "'>='" -> do
        opGreq <- icmp SGE op1 op2
        right (intIntType,opGreq)
      "'<='" -> do
        opSmeq <- icmp SLE op1 op2
        right (intIntType,opSmeq)
  [(IntT,op1),(RealT,op2)]  -> do
    op1' <- sitofp op1
    case a of
      "'+'" -> do
        opAdd <- fadd op1' op2
        right (restType,opAdd)
      "'*'" -> do
        opMul <- fmul op1' op2
        right (restType,opMul)
      "'-'" -> do
        opSub <- fsub op1' op2
        right (restType,opSub)
      "'/'" -> do
        opDiv <- fdiv op1' op2
        right (restType,opDiv)
      "'<'" -> do
        opLess <- fcmp FP.OLT op1' op2
        right (restType,opLess)
      "'>'" -> do
        opGreater <- fcmp FP.OGT op1' op2
        right (restType,opGreater)
      "'>='" -> do
        opGreq <- fcmp FP.OGE op1' op2
        right (restType,opGreq)
      "'<='" -> do
        opSmeq <- fcmp FP.OLE op1' op2
        right (restType,opSmeq)
  [(RealT,op1),(IntT,op2)]  -> do
    op2' <- sitofp op2
    case a of
      "'+'" -> do
        opAdd <- fadd op1 op2'
        right (restType,opAdd)
      "'*'" -> do
        opMul <- fmul op1 op2'
        right (restType,opMul)
      "'-'" -> do
        opSub <- fsub op1 op2'
        right (restType,opSub)
      "'/'" -> do
        opDiv <- fdiv op1 op2'
        right (restType,opDiv)
      "'<'" -> do
        opLess <- fcmp FP.OLT op1 op2'
        right (restType,opLess)
      "'>'" -> do
        opGreater <- fcmp FP.OGT op1 op2'
        right (restType,opGreater)
      "'>='" -> do
        opGreq <- fcmp FP.OGE op1 op2'
        right (restType,opGreq)
      "'<='" -> do
        opSmeq <- fcmp FP.OLE op1 op2'
        right (restType,opSmeq)
  [(RealT,op1),(RealT,op2)] -> 
    case a of
      "'+'" -> do
        opAdd <- fadd op1 op2
        right (restType,opAdd)
      "'*'" -> do
        opMul <- fmul op1 op2
        right (restType,opMul)
      "'-'" -> do
        opSub <- fsub op1 op2
        right (restType,opSub)
      "'/'" -> do
        opDiv <- fdiv op1 op2
        right (restType,opDiv)
      "'<'" -> do
        opLess <- fcmp FP.OLT op1 op2
        right (restType,opLess)
      "'>'" -> do
        opGreater <- fcmp FP.OGT op1 op2
        right (restType,opGreater)
      "'>='" -> do
        opGreq <- fcmp FP.OGE op1 op2
        right (restType,opGreq)
      "'<='" -> do
        opSmeq <- fcmp FP.OLE op1 op2
        right (restType,opSmeq)
  [(IntT,_),_]  -> errPos posn $ nonNumAfErr ++ a
  [(RealT,_),_] -> errPos posn $ nonNumAfErr ++ a
  _             -> errPos posn $ "Non-number expression before: " ++ a

unaryOpNumCases :: (Int,Int) -> String -> TyOper -> Sems TyOper
unaryOpNumCases posn a = \case
  (IntT,oper)  -> do
    operMinus <- sub (cons $ C.Int 16 0) oper
    let oper' = case a of "'+'" -> oper; "'-'" -> operMinus
    right (IntT,oper')
  (RealT,oper) -> do
    operMinus <- fsub (cons $ C.Float $ Double 0.0) oper
    let oper' = case a of "'+'" -> oper; "'-'" -> operMinus
    right (RealT,oper')
  _     -> errPos posn $ nonNumAfErr ++ a 

notCases :: (Int,Int) -> TyOper -> Sems TyOper
notCases posn = \case
  (BoolT,oper) -> do
    oper' <- icmp EQ oper $ cons $ C.Int 1 0
    right (BoolT,oper')
  _            -> errPos posn $ "Non-boolean expression after: not"


formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s $ symbatos (t1,t2)
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id t1 t2 t1s t2s $
                                   symbatos (Pointer t1, Pointer t2)
  ([],[])                     -> return ()
  _                           -> errAtId "Wrong number of arguments in call of: " id

type ByTy = (PassBy,Type)
formalExprTypeMatch :: Int -> Id -> Type -> Type -> [ByTy] -> [Type] -> Bool -> Sems ()
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

nonNumAfErr :: String
nonNumAfErr = "Non-number expression after: " 
