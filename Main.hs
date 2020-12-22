module Main where
import SemsIR (programSemsIR)
import Parser (Program,lexAndParse)
import SemsIRTypes (Error,(>>>),initState)
import System.Exit (die)
import Control.Monad.Trans.Either (runEitherT)
import Control.Monad.State (runState,evalState)
import LLVM.AST as A (Module)
import LLVM.Module (withModuleFromAST,moduleLLVMAssembly)
import LLVM.Context (withContext)
import Data.List (permutations)
import Data.ByteString.Char8 (unpack,ByteString)
import System.Process (callCommand)
import System.Environment (getArgs)
import RemoveDoubles (removeDoubles,initUniqueState)

main :: IO ()
main = do
  args <- getArgs
  codegenDependingOnArgs args

possibleArgs :: [[String]]
possibleArgs = [ ["-O","-i","-f"], ["-O","-i"], ["-O","-f"], ["-i","-f"], ["-i"], ["-f"] ]

possibleArgsPermutations :: [[[String]]]
possibleArgsPermutations = map permutations possibleArgs

codegenDependingOnArgs :: [String] -> IO ()
codegenDependingOnArgs args
  | elem args $ possibleArgsPermutations !! 0 = codegenScriptNew "Oif"
  | elem args $ possibleArgsPermutations !! 1 = codegenScriptNew "Oi"
  | elem args $ possibleArgsPermutations !! 2 = codegenScriptNew "Of"
  | elem args $ possibleArgsPermutations !! 3 = codegenScriptNew "if"
  | elem args $ possibleArgsPermutations !! 4 = codegeniNew
  | elem args $ possibleArgsPermutations !! 5 = codegenScriptNew "f"
  | length args == 2 && elem "-O" args = dontRemember1 args
  | length args == 1 = dontRemember2 args
  | otherwise = error "Not Valid"

codegenScriptNew :: String -> IO ()
codegenScriptNew s = do
  contents <- getContents
  m <- contentsToModule contents 
  llstr <- codegenIR m
  callCommand $ "mkdir -p IntermediateFiles"
  writeFile "./IntermediateFiles/llvmhs.ll" $ unpack llstr
  callCommand $ "./ExecutableScripts/" ++ s ++ ".sh"

codegeniNew :: IO ()
codegeniNew = do
  contents <- getContents
  m <- contentsToModule contents
  llstr <- codegenIR m
  putStrLn $ unpack llstr

dontRemember1 args = do
    let file = head $ filter (/="-O") args
    let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
    contents <- readFile file
    codegenScript' "Ofile" contents filePrefix

dontRemember2 args = do
    let file = head args
    let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
    contents <- readFile file
    codegenScript' "file" contents filePrefix

contentsToModule :: String -> IO A.Module
contentsToModule s = do
  ast <- parserTransformCases $ lexAndParse s
  astSems ast

parserTransformCases :: Either Error Program -> IO Program
parserTransformCases = \case 
  Left e    -> die e
  Right ast -> transformProgramFinal ast

transformProgramFinal :: Program -> IO Program
transformProgramFinal ast =
  let runTransformProgram = removeDoubles >>> runEitherT >>> evalState
  in case runTransformProgram ast initUniqueState of
    Right ast -> return ast
    Left e    -> die e

astSems :: Program -> IO A.Module
astSems ast =
  let runProgramSems = programSemsIR >>> runEitherT >>> runState
  in case runProgramSems ast initState of
    (Right _,(_,_,m,_,_)) -> return m
    (Left e,_)          -> die e

codegen :: A.Module -> IO ()
codegen m = withContext $ \context -> withModuleFromAST context m $ \m -> do
  llstr <- moduleLLVMAssembly m
  --putStrLn $ unpack llstr
  writeFile "llvmhs.ll" $ unpack llstr
  callCommand "./usefulHs.sh"

codegenScript' :: String -> String -> String -> IO ()
codegenScript' s contents filePrefix = do
  m <- contentsToModule contents
  llstr <- codegenIR m
  writeFile (filePrefix ++ ".ll") $ unpack llstr
  callCommand $ "./ExecutableScripts/" ++ s ++ ".sh " ++ filePrefix

codegenIR :: A.Module -> IO ByteString
codegenIR m = withContext $ \context -> withModuleFromAST context m $ \m ->
  moduleLLVMAssembly m
