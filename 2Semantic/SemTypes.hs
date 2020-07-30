{-# LANGUAGE DeriveFunctor,GeneralizedNewtypeDeriving #-}

module SemTypes where
import Parser as P
import Control.Monad.State
import Control.Monad.Trans.Either
import LLVM.AST as L
import LLVM.AST.Type as T
import Data.ByteString.Short (ShortByteString,toShort,
                              fromShort)
import Data.ByteString.Char8 (pack,unpack)
import Data.Bits.Extras (w64)
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
  Procedure Args         |
  Function Args P.Type  |
  ProcedureDeclaration Args        |
  FunctionDeclaration Args P.Type
  deriving(Show,Eq)

type VariableMap   = M.Map Id Variable
type LabelMap = M.Map Id Bool
type CallMap  = M.Map Id FaP
type NewMap   = M.Map LValue ()
type SymbolMap = (VariableMap,LabelMap,CallMap,NewMap)
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

pst :: ShortByteString -> String
pst = unpack . fromShort

tollvmTy :: P.Type -> T.Type
tollvmTy = \case 
  Tnil              -> undefined
  Tint              -> i32
  Treal             -> double
  Tbool             -> i1
  Tchar             -> i8
  ArrayT arrSize ty -> tollvmArrTy arrSize ty
  PointerT ty       -> ptr (tollvmTy ty)

tollvmArrTy arrSize ty = case arrSize of
  NoSize -> ptr (tollvmTy ty)
  Size i -> ArrayType (w64 i) $ tollvmTy ty

toSig :: Args -> [(L.Type, L.Name)] 
toSig = concat . map formalToSig

formalToSig (_,ids,ty) =
  map (\id -> (tollvmTy ty,L.Name $ tsp $ idString id)) ids
