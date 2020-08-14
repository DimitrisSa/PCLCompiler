module ValTypes where
import Control.Monad.Trans.Either
import Common

resultType :: (Int,Int) -> Sems Type
resultType posn = getEnv >>= \case
  InFunc id ty _ -> setEnv (InFunc id ty True) >> return ty
  InProc         -> errPos posn "Result in procedure"

dereferenceCases posn = \case
  Pointer t -> right t
  Nil       -> errPos posn "dereferencing Nil pointer"
  _         -> errPos posn "dereferencing non-pointer"

indexingCases posn = \case
  (Array _ t,IntT) -> right t
  (_        ,IntT) -> errPos posn "indexing non-array"
  _                -> errPos posn "non-integer index"

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

binOpBoolCases posn a = \case
  [BoolT,BoolT] -> right BoolT
  [BoolT,_]     -> errPos posn $ "Non-boolean expression after: " ++ a
  _             -> errPos posn $ "Non-boolean expression before: " ++ a

binOpIntCases posn a =  \case
  [IntT,IntT] -> right IntT
  [IntT,_]    -> errPos posn $ "Non-integer expression after: " ++ a
  _           -> errPos posn $ "Non-integer expression before: " ++ a

binOpNumCases posn intIntType restType a = \case
  [IntT,IntT]   -> right intIntType
  [IntT,RealT]  -> right restType
  [RealT,IntT]  -> right restType
  [RealT,RealT] -> right restType
  [IntT,_]      -> errPos posn $ nonNumAfErr ++ a
  [RealT,_]     -> errPos posn $ nonNumAfErr ++ a
  _             -> errPos posn $ "Non-number expression before: " ++ a

unaryOpNumCases posn a = \case
  IntT  -> right IntT
  RealT -> right RealT
  _     -> errPos posn $ nonNumAfErr ++ a 

notCases posn = \case
  BoolT -> right BoolT
  _     -> errPos posn $ "Non-boolean expression after: not"

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId "Wrong number of arguments in call of: " id

formalExprTypeMatch i id t1 t2 t1s t2s = case symbatos (t1,t2) of 
  True -> formalsExprsTypesMatch (i+1) id t1s t2s
  _    -> errorAtArg i id

errorAtArg i (Id posn str) =
  errPos posn $ concat ["Type mismatch at argument ",show i, " in call of: ", str]

nonNumAfErr = "Non-number expression after: " 
