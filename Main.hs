module Main where
import SemsIR (programSemsIR)
import Parser (Program,parser)
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
import RemoveDoubles (transformProgram,initUniqueState)

checkOif :: [String] -> IO ()
checkOif args = case elem args $ permutations ["-O","-i","-f"] of
  True -> getContents >>= codegenOif 
  _    -> checkOi args

checkOi :: [String] -> IO ()
checkOi args = case elem args $ permutations ["-O","-i"] of
  True -> getContents >>= codegenOi
  _    -> checkOf args

checkOf :: [String] -> IO ()
checkOf args = case elem args $ permutations ["-O","-f"] of
  True -> getContents >>= codegenOf
  _    -> checkif args

checkif :: [String] -> IO ()
checkif args = case elem args $ permutations ["-i","-f"] of
  True -> getContents >>= codegenif
  _    -> checki args

checki :: [String] -> IO ()
checki args = case args == ["-i"] of
  True -> getContents >>= codegeni
  _    -> checkf args

checkf :: [String] -> IO ()
checkf args = case args == ["-f"] of
  True -> getContents >>= codegenf
  _    -> checkOfile args

checkOfile :: [String] -> IO ()
checkOfile args = case length args == 2 && elem "-O" args of
  True -> do
    let file = head $ filter (/="-O") args
    let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
    input <- readFile file
    codegenOfile input filePrefix
  _    -> checkfile args

checkfile :: [String] -> IO ()
checkfile args = case length args == 1 of
  True -> do
    let file = head args
    let filePrefix = reverse $ tail $ dropWhile (/= '.') $ reverse file
    input <- readFile file
    codegenfile input filePrefix
  _    -> error "Not Valid"

inputToModule :: String -> IO A.Module
inputToModule s = do
  ast <- parserTransformCases $ parser s
  astSems ast

main :: IO ()
main = do
  args <- getArgs
  checkOif args

parserTransformCases :: Either Error Program -> IO Program
parserTransformCases = \case 
  Left e    -> die e
  Right ast -> transformProgramFinal ast

transformProgramFinal :: Program -> IO Program
transformProgramFinal ast =
  let runTransformProgram = transformProgram >>> runEitherT >>> evalState
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

codegenIR :: A.Module -> IO ByteString
codegenIR m = withContext $ \context -> withModuleFromAST context m $ \m ->
  moduleLLVMAssembly m

codegeni :: String -> IO ()
codegeni input = do
  m <- inputToModule input
  llstr <- codegenIR m
  putStrLn $ unpack llstr

codegenScript :: String -> String -> IO ()
codegenScript s input = do
  m <- inputToModule input
  llstr <- codegenIR m
  writeFile "./3IntermediateFiles/llvmhs.ll" $ unpack llstr
  callCommand $ "./5ExecutableScripts/" ++ s ++ ".sh"

codegenScript' :: String -> String -> String -> IO ()
codegenScript' s input filePrefix = do
  m <- inputToModule input
  llstr <- codegenIR m
  writeFile (filePrefix ++ ".ll") $ unpack llstr
  callCommand $ "./5ExecutableScripts/" ++ s ++ ".sh " ++ filePrefix

codegenf :: String -> IO ()
codegenf = codegenScript "f"

codegenif :: String -> IO ()
codegenif = codegenScript "if"

codegenOf :: String -> IO ()
codegenOf = codegenScript "Of"

codegenOi :: String -> IO ()
codegenOi = codegenScript "Oi"

codegenOif :: String -> IO ()
codegenOif = codegenScript "Oif"

codegenOfile :: String -> String -> IO ()
codegenOfile = codegenScript' "Ofile"

codegenfile :: String -> String -> IO ()
codegenfile = codegenScript' "file"
