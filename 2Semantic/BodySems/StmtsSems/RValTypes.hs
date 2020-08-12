module RValTypesCases where
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
  _                     -> left $ errPos li co ++ mismTypesErr ++ a

binOpBoolCases li co a = \case
  [BoolT,BoolT] -> right BoolT
  [BoolT,_]     -> left $ errPos li co ++ nonBoolAfErr ++ a
  _             -> left $ errPos li co ++ nonBoolBefErr ++ a

binOpIntCases li co a =  \case
  [IntT,IntT] -> right IntT
  [IntT,_]    -> left $ errPos li co ++ nonIntAfErr ++ a
  _           -> left $ errPos li co ++ nonIntBefErr ++ a

binOpNumCases li co intIntType restType a = \case
  [IntT,IntT]   -> right intIntType
  [IntT,RealT]  -> right restType
  [RealT,IntT]  -> right restType
  [RealT,RealT] -> right restType
  [IntT,_]      -> left $ errPos li co ++ nonNumAfErr ++ a
  [RealT,_]     -> left $ errPos li co ++ nonNumAfErr ++ a
  _             -> left $ errPos li co ++ nonNumBefErr ++ a

unaryOpNumCases li co a = \case
  IntT  -> right IntT
  RealT -> right RealT
  _     -> left $ errPos li co ++ nonNumAfErr ++ a 

notCases li co = \case
  BoolT -> right BoolT
  _     -> left $ errPos li co ++ nonBoolAfErr ++ "not"

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId argsExprsErr id

formalExprTypeMatch i id t1 t2 t1s t2s = do
  symbatos' (errorAtArg badArgErr i id) (t1,t2)
  formalsExprsTypesMatch (i+1) id t1s t2s

errorAtArg err i (Id str li co) = errPos li co ++ err i str
