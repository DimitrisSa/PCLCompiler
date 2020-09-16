module ValTypes where
import Control.Monad.Trans.Either
import Common
import qualified LLVM.AST as AST
import qualified LLVM.AST.IntegerPredicate as I
import qualified LLVM.AST.FloatingPointPredicate as FP
import SemsCodegen
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F

resultType :: (Int,Int) -> Sems TyOper
resultType posn = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return (ty,undefined)
  InProc         -> errPos posn "Result in procedure"

dereferenceCases :: (Int,Int) -> TyOper -> Sems TyOper
dereferenceCases posn = \case
  (Pointer t,op) -> right (t,undefined) -- GEP
  (Nil,_ )       -> errPos posn "dereferencing Nil pointer"
  _              -> errPos posn "dereferencing non-pointer"

indexingCases :: (Int,Int) -> (TyOper,TyOper) -> Sems TyOper
indexingCases posn = \case
  ((Array _ t,op1),(IntT,op2)) -> right (t,undefined)
  (_        ,(IntT,_)) -> errPos posn "indexing non-array"
  _                -> errPos posn "non-integer index"

comparisonCases :: (Int,Int) -> String -> [TyOper] -> Sems TyOper 
comparisonCases posn a = \case
  [(IntT,op1),(IntT,op2)] -> 
    case a of
      "'='"  -> do
        eqOp <- icmp I.EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp I.NE op1 op2
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
        eqOp <- icmp I.EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp I.NE op1 op2
        right (BoolT,diffOp)
  [(CharT,op1),(CharT,op2)] ->
    case a of
      "'='"  -> do
        eqOp <- icmp I.EQ op1 op2
        right (BoolT,eqOp)
      "'<>'" -> do
        diffOp <- icmp I.NE op1 op2
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
        opLess <- icmp I.SLT op1 op2
        right (intIntType,opLess)
      "'>'" -> do
        opGreater <- icmp I.SGT op1 op2
        right (intIntType,opGreater)
      "'>='" -> do
        opGreq <- icmp I.SGE op1 op2
        right (intIntType,opGreq)
      "'<='" -> do
        opSmeq <- icmp I.SLE op1 op2
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
    operMinus <- fsub (cons $ C.Float $ F.Double 0.0) oper
    let oper' = case a of "'+'" -> oper; "'-'" -> operMinus
    right (RealT,oper')
  _     -> errPos posn $ nonNumAfErr ++ a 

notCases :: (Int,Int) -> TyOper -> Sems TyOper
notCases posn = \case
  (BoolT,oper) -> do
    oper' <- icmp I.EQ oper $ cons $ C.Int 1 0
    right (BoolT,oper')
  _            -> errPos posn $ "Non-boolean expression after: not"


formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId "Wrong number of arguments in call of: " id

formalExprTypeMatch :: Int -> Id -> Type -> Type -> [(PassBy,Type)] -> [Type] -> Sems ()
formalExprTypeMatch i id t1 t2 t1s t2s = case symbatos (t1,t2) of 
  True -> formalsExprsTypesMatch (i+1) id t1s t2s
  _    -> errorAtArg i id

errorAtArg :: Int -> Id -> Sems ()
errorAtArg i (Id posn str) =
  errPos posn $ concat ["Type mismatch at argument ",show i, " in call of: ", str]

nonNumAfErr :: String
nonNumAfErr = "Non-number expression after: " 
