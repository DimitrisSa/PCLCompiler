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

