{-# LANGUAGE DeriveFunctor,GeneralizedNewtypeDeriving #-}

module SemTypes where
import Parser as P
import Control.Monad.State
import Control.Monad.Trans.Either
import LLVM.AST as L
import Data.ByteString.Short (ShortByteString,toShort,
                              fromShort)
import Data.ByteString.Char8 (pack,unpack)
import qualified Data.Map as M

data Variable =
  Var { ty :: P.Type ,
        vop :: Maybe Operand}
  deriving(Show,Eq)

var :: P.Type -> Variable
var t = Var t Nothing

data FaP =
  FP { ca :: Callable ,
       fop :: Maybe Operand}
  deriving(Show,Eq)

fp :: Callable -> FaP
fp t = FP t Nothing

data Callable =
  Proc Args         |
  Func Args P.Type  |
  FProc Args        |
  FFunc Args P.Type
  deriving(Show,Eq)

type VarMap   = M.Map Id Variable
type LabelMap = M.Map Id Bool
type CallMap  = M.Map Id FaP
type NewMap   = M.Map LValue ()
type SymbolMap = (VarMap,LabelMap,CallMap,NewMap)
type Error = String
type Semantics a = EitherT Error (State CodegenState) a

data CodegenState
  = CodegenState {
    currentBlock :: Name                    
  , blocks       :: M.Map Name BlockState 
  , symtab       :: [SymbolMap]
  , blockCount   :: Int                     
  , count        :: Word                    
  , names        :: Names                   
  } deriving Show

emptySymbolMap = (M.empty,M.empty,M.empty,M.empty)
emptyCGS = CodegenState {
    currentBlock = Name $ tsp ""
  , blocks       = M.empty
  , symtab       = [emptySymbolMap]
  , blockCount   = 0
  , count        = 0
  , names        = M.empty
  }

data BlockState
  = BlockState {
    idx   :: Int                            
  , stack :: [Named Instruction]            
  , term  :: Maybe (Named Terminator)       
  } deriving Show

type Names = M.Map String Int

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case M.lookup nm ns of
    Nothing -> (nm,  M.insert nm 1 ns)
    Just ix -> (nm ++ show ix, M.insert nm (ix+1) ns)

newtype LLVM a = LLVM (State L.Module a)
  deriving (Functor, Applicative, Monad, MonadState L.Module )

runLLVM :: L.Module -> LLVM a -> L.Module
runLLVM mod (LLVM m) = execState m mod

emptyModule :: String -> L.Module
emptyModule label = defaultModule { moduleName = tsp label }

addDefn :: Definition -> LLVM ()
addDefn d = do
  defs <- gets moduleDefinitions
  modify $ \s -> s { moduleDefinitions = defs ++ [d] }

tsp :: String -> ShortByteString
tsp = toShort . pack
