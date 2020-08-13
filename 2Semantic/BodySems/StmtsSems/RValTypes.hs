module RValTypes where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import Common

comparisonCases li co a = \case
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
  _                     -> errPos li co $ mismTypesErr ++ a

binOpBoolCases li co a = \case
  [BoolT,BoolT] -> right BoolT
  [BoolT,_]     -> errPos li co $ nonBoolAfErr ++ a
  _             -> errPos li co $ nonBoolBefErr ++ a

binOpIntCases li co a =  \case
  [IntT,IntT] -> right IntT
  [IntT,_]    -> errPos li co $ nonIntAfErr ++ a
  _           -> errPos li co $ nonIntBefErr ++ a

binOpNumCases li co intIntType restType a = \case
  [IntT,IntT]   -> right intIntType
  [IntT,RealT]  -> right restType
  [RealT,IntT]  -> right restType
  [RealT,RealT] -> right restType
  [IntT,_]      -> errPos li co $ nonNumAfErr ++ a
  [RealT,_]     -> errPos li co $ nonNumAfErr ++ a
  _             -> errPos li co $ "Non-number expression before: " ++ a

unaryOpNumCases li co a = \case
  IntT  -> right IntT
  RealT -> right RealT
  _     -> errPos li co $ nonNumAfErr ++ a 

notCases li co = \case
  BoolT -> right BoolT
  _     -> errPos li co $ nonBoolAfErr ++ "not"

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId argsExprsErr id

formalExprTypeMatch i id t1 t2 t1s t2s = case symbatos (t1,t2) of 
  True -> formalsExprsTypesMatch (i+1) id t1s t2s
  _    -> errorAtArg i id

errorAtArg i (Id str li co) =
  errPos li co $ concat ["Type mismatch at argument ",show i, " in call of: ", str]

nonNumAfErr = "Non-number expression after: " 
