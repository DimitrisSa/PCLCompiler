module ValTypes where
import Control.Monad.Trans.Either
import Common
import qualified LLVM.AST as AST
import qualified LLVM.AST.IntegerPredicate as I
import SemsCodegen
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F

resultType :: (Int,Int) -> Sems Type
resultType posn = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> errPos posn "Result in procedure"

dereferenceCases :: (Int,Int) -> Type -> Sems Type
dereferenceCases posn = \case
  Pointer t -> right t
  Nil       -> errPos posn "dereferencing Nil pointer"
  _         -> errPos posn "dereferencing non-pointer"

indexingCases :: (Int,Int) -> (Type,Type) -> Sems Type
indexingCases posn = \case
  (Array _ t,IntT) -> right t
  (_        ,IntT) -> errPos posn "indexing non-array"
  _                -> errPos posn "non-integer index"

comparisonCases :: (Int,Int) -> String -> [Type] -> Sems Type 
comparisonCases posn a = \case
  [IntT,IntT]           -> right BoolT
  [IntT,RealT]          -> right BoolT
  [RealT,IntT]          -> right BoolT
  [RealT,RealT]         -> right BoolT
  [BoolT,BoolT]         -> right BoolT
  [CharT,CharT]         -> right BoolT
  [Pointer _,Pointer _] -> right BoolT
  [Pointer _,Nil]       -> right BoolT
  [Nil,Pointer _]       -> right BoolT
  [Nil,Nil]             -> right BoolT
  _                     -> errPos posn $ "Incomparable types at: " ++ a

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

type TyOper = (Type,AST.Operand)
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
        right (intIntType,opDiv)
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
