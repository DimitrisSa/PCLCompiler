module Main where

import Control.Monad.Trans
import Parser
import Emit
import SemTypes
import Semantics

import System.IO
import System.Environment
import System.Console.Haskeline
import System.Exit

import qualified LLVM.AST as AST

initModule :: AST.Module
initModule = emptyModule "my cool jit"

process :: AST.Module -> Program -> IO (Maybe AST.Module)
process modo prog = do
  ast <- codegen modo prog
  return $ Just ast

main :: IO ()
main = do
  s    <- getContents
  case parser s of
    Left e -> die e
    Right ast -> process initModule ast >> return ()
