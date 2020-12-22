module Main where
import SemsIR (semanticsAndIRFunction)
import Parser (Program,lexAndParse)
import SemsIRTypes (Error,(>>>),initState)
import System.Exit (die)
import Control.Monad.Trans.Either (runEitherT)
import Control.Monad.State (runState,evalState)
import Control.Monad ((>=>))
import LLVM.AST as A (Module)
import LLVM.Module (withModuleFromAST,moduleLLVMAssembly)
import LLVM.Context (withContext)
import Data.List (permutations)
import Data.ByteString.Char8 (unpack,ByteString)
import System.Process (callCommand)
import System.Environment (getArgs)
import RemoveDoubles (removeDoubles,initUniqueState)

main :: IO ()
main = getArgs >>= compileDependingOnArgs

possibleArgs :: [[String]]
possibleArgs = [ ["-O","-i","-f"], ["-O","-i"], ["-O","-f"], ["-i","-f"], ["-i"], ["-f"] ]

possibleArgsPermutations :: [[[String]]]
possibleArgsPermutations = map permutations possibleArgs

compileDependingOnArgs :: [String] -> IO ()
compileDependingOnArgs args
  | elem args $ possibleArgsPermutations !! 0 = compileUsingTheScript "Oif"
  | elem args $ possibleArgsPermutations !! 1 = compileUsingTheScript "Oi"
  | elem args $ possibleArgsPermutations !! 2 = compileUsingTheScript "Of"
  | elem args $ possibleArgsPermutations !! 3 = compileUsingTheScript "if"
  | elem args $ possibleArgsPermutations !! 4 = getIRString >>= putStrLn
  | elem args $ possibleArgsPermutations !! 5 = compileUsingTheScript "f"
  | length args == 2 && elem "-O" args = dontRemember1 args
  | length args == 1 = dontRemember2 args
  | otherwise = error "Not Valid"

getIRString :: IO String
getIRString = getContents >>= contentsToIRString

contentsToIRString :: String -> IO String
contentsToIRString = contentsToIR >=> irToBytestring >=> ( unpack >>> return )

compileUsingTheScript :: String -> IO ()
compileUsingTheScript s =
  callCommand "mkdir -p IntermediateFiles" >>
  (getIRString >>= writeFile "./IntermediateFiles/llvmhs.ll") >>
  (callCommand $ "./ExecutableScripts/" ++ s ++ ".sh")

dontRemember1 args = do
  let file = head $ filter (/="-O") args
  let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
  contents <- readFile file
  compileUsingTheScript' "Ofile" contents filePrefix

dontRemember2 args = do
  let file = head args
  let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
  contents <- readFile file
  compileUsingTheScript' "file" contents filePrefix

contentsToIR :: String -> IO A.Module
contentsToIR s = do
  ast <- checkSuccessOfParsing $ lexAndParse s
  noDuplicatesAst <- checkForDuplicates ast
  semanticsAndIR noDuplicatesAst

checkSuccessOfParsing :: Either Error Program -> IO Program
checkSuccessOfParsing = \case 
  Left e    -> die e
  Right ast -> return ast

checkForDuplicates :: Program -> IO Program
checkForDuplicates ast =
  let runRemoveDoubles = removeDoubles >>> runEitherT >>> evalState
  in case runRemoveDoubles ast initUniqueState of
    Left e    -> die e
    Right ast -> return ast

semanticsAndIR :: Program -> IO A.Module
semanticsAndIR ast =
  let runSemanticsAndIR = semanticsAndIRFunction >>> runEitherT >>> runState
  in case runSemanticsAndIR ast initState of
    (Right _,(_,_,m,_,_)) -> return m
    (Left e,_)            -> die e

codegen :: A.Module -> IO ()
codegen m = withContext $ \context -> withModuleFromAST context m $ \m -> do
  irBytestring <- moduleLLVMAssembly m
  --putStrLn $ unpack irBytestring
  writeFile "llvmhs.ll" $ unpack irBytestring
  callCommand "./usefulHs.sh"

compileUsingTheScript' :: String -> String -> String -> IO ()
compileUsingTheScript' s contents filePrefix = do
  irString <- contentsToIRString contents
  writeFile (filePrefix ++ ".ll") irString
  callCommand $ "./ExecutableScripts/" ++ s ++ ".sh " ++ filePrefix

irToBytestring :: A.Module -> IO ByteString
irToBytestring m = withContext $ \context -> withModuleFromAST context m $ \m ->
  moduleLLVMAssembly m
