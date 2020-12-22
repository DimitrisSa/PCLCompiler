module Main where
import SemsIR (semanticsAndIRFunction)
import Parser (Program,lexAndParse)
import SemsIRTypes (Error,(>>>),initState)
import System.Exit (die)
import Control.Monad.Trans.Either (runEitherT)
import Control.Monad.State (runState,evalState)
import Control.Monad ((>=>))
import LLVM.AST (Module)
import LLVM.Module (withModuleFromAST,moduleLLVMAssembly)
import LLVM.Context (withContext)
import Data.List (permutations)
import Data.ByteString.Char8 (unpack,ByteString)
import System.Process (callCommand)
import System.Environment (getArgs)
import RemoveDoubles (removeDoubles,initUniqueState)

type Arg = String
type Args = [Arg]

main :: IO ()
main = getArgs >>= compileDependingOnArgs

compileDependingOnArgs :: Args -> IO ()
compileDependingOnArgs args
  | elem args $ possibleArgsPermutations !! 0 = compileToStdout "Oif"
  | elem args $ possibleArgsPermutations !! 1 = compileToStdout "Oi"
  | elem args $ possibleArgsPermutations !! 2 = compileToStdout "Of"
  | elem args $ possibleArgsPermutations !! 3 = compileToStdout "if"
  | elem args $ possibleArgsPermutations !! 4 = getIRString >>= putStrLn
  | elem args $ possibleArgsPermutations !! 5 = compileToStdout "f"
  | length args == 2 && elem "-O" args = compileToFileWithOptimizations args
  | length args == 1 = compileToFileWithoutOptimizations args
  | otherwise = error "Not Valid"

type ArgsList = [Args]
possibleArgsPermutations :: [ArgsList]
possibleArgsPermutations = map permutations possibleArgs
possibleArgs :: ArgsList
possibleArgs = [ ["-O","-i","-f"], ["-O","-i"], ["-O","-f"], ["-i","-f"], ["-i"], ["-f"] ]

type ScriptInput = String
compileToStdout :: ScriptInput -> IO ()
compileToStdout scriptInput =
  callCommand "mkdir -p IntermediateFiles" >>
  (getIRString >>= writeFile "IntermediateFiles/llvmhs.ll") >>
  (callCommand $ "./scriptRunByExecutable.sh " ++ scriptInput)

type IRString = String
getIRString :: IO IRString
getIRString = getContents >>= contentsToIRString

compileToFileWithOptimizations :: Args -> IO ()
compileToFileWithOptimizations = filter (/="-O") >>> head >>> compileToFile "Ofile"

compileToFileWithoutOptimizations :: Args -> IO ()
compileToFileWithoutOptimizations = head >>> compileToFile "file"

contentsToIRString :: String -> IO String
contentsToIRString = contentsToIR >=> irToBytestring >=> ( unpack >>> return )

type Prefix = String
type File = String
compileToFile :: ScriptInput -> File -> IO ()
compileToFile scriptInput file =
  let filePrefix = fileToPrefix file
  in (readFile file >>= contentsToIRString >>= writeFile (filePrefix ++ ".ll")) >>
     (callCommand $ "./scriptRunByExecutable.sh " ++ scriptInput ++ " " ++ filePrefix)

contentsToIR :: String -> IO Module
contentsToIR s = do
  ast <- checkSuccessOfParsing $ lexAndParse s
  noDuplicatesAst <- checkForDuplicates ast
  semanticsAndIR noDuplicatesAst

irToBytestring :: Module -> IO ByteString
irToBytestring m = withContext $ \context -> withModuleFromAST context m $ \m ->
  moduleLLVMAssembly m

fileToPrefix :: File -> Prefix
fileToPrefix = reverse >>> dropWhile (/= '.')  >>> tail >>> reverse

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

semanticsAndIR :: Program -> IO Module
semanticsAndIR ast =
  let runSemanticsAndIR = semanticsAndIRFunction >>> runEitherT >>> runState
  in case runSemanticsAndIR ast initState of
    (Right _,(_,_,m,_,_)) -> return m
    (Left e,_)            -> die e
