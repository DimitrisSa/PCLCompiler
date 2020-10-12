module Main where
import SemsIR (programSemsIR)
import Parser (Program,parser)
import SemsIRTypes (Error,(>>>),initState)
import System.Exit (die)
import Control.Monad.Trans.Either (runEitherT)
import Control.Monad.State (runState)
import LLVM.AST as A (Module)
import LLVM.Module (withModuleFromAST,moduleLLVMAssembly)
import LLVM.Context (withContext)
import Data.ByteString.Char8 (unpack)
import System.Process (callCommand)

main :: IO ()
main = do
  c <- getContents
  --putStrLn c
  parserCases $ parser c

parserCases :: Either Error Program -> IO ()
parserCases = \case 
  Left e    -> die e
  Right ast -> astSems ast

astSems :: Program -> IO ()
astSems ast =
  let runProgramSems = programSemsIR >>> runEitherT >>> runState
  in case runProgramSems ast initState of
    (Right _,(_,_,m,_)) -> codegen m
    (Left e,_)          -> die e

codegen :: A.Module -> IO ()
codegen m = withContext $ \context -> withModuleFromAST context m $ \m -> do
  llstr <- moduleLLVMAssembly m
  --putStrLn $ unpack llstr
  writeFile "llvmhs.ll" $ unpack llstr
  callCommand "./usefulHs.sh"
