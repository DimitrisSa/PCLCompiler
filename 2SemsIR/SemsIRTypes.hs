module SemsIRTypes where
import Prelude hiding (lookup)
import Control.Monad.State (State,modify,get)
import Control.Monad.Trans.Either (EitherT,left)
import Data.Map (Map,empty,insert,lookup)
import LLVM.AST (Operand(..),Module,Global,moduleDefinitions,Definition(..),Terminator(..)
                ,Name(..),Named,Instruction,defaultModule)
import LLVM.AST.Constant (Constant(..))
import Data.Bits.Extras (w64)
import Data.String.Transform (toShortByteString)
import Parser as P (ArrSize(..),Type(..),Id(..),Frml,PassBy(..))
import LLVM.AST.Type as T (Type(..),ptr,i1,i8,i16,double,void)
import qualified LLVM.AST.Constant as C (Constant(..))

-- Codegen State
type Names = Map String Int

data CodegenState
  = CodegenState {
    currentBlock :: Name                     
  , blocks       :: Map Name BlockState  
  , blockCount   :: Int                      
  , count        :: Word                     
  , names        :: Names
  } deriving Show

data BlockState
  = BlockState {
    idx   :: Int                            
  , stack :: [Named Instruction]            
  , term  :: Maybe (Named Terminator)       
  } deriving Show

-- Semantics State
data Env = InProc | InFunc Id P.Type Bool

data Callable =
  Proc [Frml]            |
  Func [Frml] P.Type     |
  ProcDclr [Frml]        |
  FuncDclr [Frml] P.Type
  deriving(Show,Eq)

type VariableMap = Map Id (P.Type,Operand)
type LabelMap    = Map Id Bool
type CallableMap = Map Id (Callable,Operand)

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  }

type TyOperBool = (P.Type,Operand,Bool)
type TyOper = (P.Type,Operand)
type Error = String

-- All of the state (Semantics,Module,Codegen)
type Sems  = EitherT Error (State (Env,[SymbolTable],Module,CodegenState))

-- Initial state
emptyCodegen :: CodegenState
emptyCodegen = CodegenState (toShortName "entry") empty 1 0 empty

emptySymbolTable :: SymbolTable
emptySymbolTable = SymbolTable empty empty empty

initState :: (Env,[SymbolTable],Module,CodegenState)
initState = (InProc,[emptySymbolTable],defaultModule,emptyCodegen)

-- Composition with arguments in a more logical order
infixl 9 >>>
(>>>) = (flip (.))

-- Codegen State operations
modifyCodegen :: (CodegenState -> CodegenState) -> Sems ()
modifyCodegen f = modify $ \(env,sts,m,cgen) -> (env,sts,m,f cgen)

setCount :: Int -> Sems ()
setCount i = modifyCodegen $ \s -> s { count = fromIntegral i }

getFromCodegen :: (CodegenState -> a) -> Sems a
getFromCodegen f = get >>= (\(_,_,_,x) -> f x) >>> return

toShortName :: String -> Name
toShortName = toShortByteString >>> Name

-- Module State operations
getDefs :: Sems [Definition]
getDefs = get >>= (\(_,_,x,_) -> moduleDefinitions x) >>> return

addDef :: Definition -> Sems ()
addDef d = modifyMod $ \s -> s { moduleDefinitions = (moduleDefinitions s) ++ [d] }

addGlobalDef :: Global -> Sems ()
addGlobalDef = GlobalDefinition >>> addDef

modifyMod :: (Module -> Module) -> Sems ()
modifyMod f = modify $ \(env,sts,m,cgen) -> (env,sts,f m,cgen)

-- Environment State operations
getEnv :: Sems Env
getEnv = get >>= (\(x,_,_,_) -> x) >>> return

setEnv :: Env -> Sems ()
setEnv env = modify $ \(_,sts,m,cgen) -> (env,sts,m,cgen)

-- Symbol Tables State operations
getSymTabs :: Sems [SymbolTable]
getSymTabs = get >>= (\(_,x,_,_) -> x) >>> return

getMap :: (SymbolTable -> a) -> Sems a
getMap map = getSymTabs >>= head >>> map >>> return

getVariableMap :: Sems VariableMap
getVariableMap = getMap variableMap

getLabelMap :: Sems LabelMap
getLabelMap = getMap labelMap

getCallableMap :: Sems CallableMap
getCallableMap = getMap callableMap

insToLabelMap :: Id -> Bool -> Sems ()
insToLabelMap label b = modify $ \(e,st:sts,m,cgen) ->
  (e,st { labelMap = insert label b $ labelMap st }:sts,m,cgen)

insToCallableMap :: Id -> Callable -> Sems ()
insToCallableMap id cal = modify $ \(e,st:sts,m,cgen) ->
  (e,st {
       callableMap = insert id (cal,calToOper cal $ idToName id) $ callableMap st
     }:sts,m,cgen)

toName :: String -> Name
toName = toShortByteString >>> Name

idToName :: Id -> Name
idToName = idString >>> toName

consGlobalRef :: T.Type -> Name -> Operand
consGlobalRef ty name = ConstantOperand $ C.GlobalReference ty name

calToOper :: Callable -> Name -> Operand
calToOper cal name = consGlobalRef (calToTy cal) name

calToTy :: Callable -> T.Type
calToTy = \case
  Proc frmls        -> procToTy frmls
  Func frmls ty     -> funcToTy frmls ty
  ProcDclr frmls    -> procToTy frmls
  FuncDclr frmls ty -> funcToTy frmls ty

funcToTy :: [Frml] -> P.Type -> T.Type
funcToTy frmls ty = ptr $ FunctionType {
    resultType = toTType ty
  , argumentTypes = frmlsToArgTypes frmls
  , isVarArg = False
  }

procToTy :: [Frml] -> T.Type
procToTy frmls = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = frmlsToArgTypes frmls
  , isVarArg = False
  }

frmlsToArgTypes :: [Frml] -> [T.Type]
frmlsToArgTypes = concat . map frmlToArgTypes

frmlToArgTypes :: Frml -> [T.Type]
frmlToArgTypes (by,ids,ty) = replicate (length ids) $ case by of
  Val -> toTType ty 
  _   -> toTType $ Pointer ty

lookupInMap :: Sems (Map Id a) -> Id -> Sems (Maybe a)
lookupInMap getMap id = getMap >>= lookup id >>> return

lookupInVariableMap :: Id -> Sems (Maybe (P.Type,Operand))
lookupInVariableMap = lookupInMap getVariableMap

lookupInLabelMap :: Id -> Sems (Maybe Bool)
lookupInLabelMap = lookupInMap getLabelMap

lookupInCallableMap :: Id -> Sems (Maybe (Callable,Operand))
lookupInCallableMap = lookupInMap getCallableMap

searchVarInSymTabs :: Id -> Sems (P.Type,Operand)
searchVarInSymTabs id =
  getSymTabs >>= searchInSymTabs variableMap id "Undeclared variable: "

searchCallableInSymTabs :: Id -> Sems (Callable,Operand)
searchCallableInSymTabs id = getSymTabs >>= 
  searchInSymTabs callableMap id "Undeclared function or procedure in call: "

searchInSymTabs :: (SymbolTable -> Map Id a) -> Id -> Error -> [SymbolTable] -> Sems a
searchInSymTabs map id err = \case
  st:sts -> case lookup id $ map st of
    Just val -> return val
    Nothing  -> searchInSymTabs map id err sts
  []     -> errAtId err id

-- Printing errors
errAtId :: String -> Id -> Sems a
errAtId err (Id posn str) = errPos posn $ err ++ str

errPos (li,co) err = left $ concat [show li,":",show co,": ",err] 

-- Parser Type to LLVM.AST.Type
toTType :: P.Type -> T.Type
toTType = \case
  Nil             -> undefined
  IntT            -> i16
  RealT           -> double
  BoolT           -> i1
  CharT           -> i8
  P.Array size ty -> arrayToTType ty size
  Pointer ty      -> ptr $ toTType ty

arrayToTType :: P.Type -> ArrSize -> T.Type
arrayToTType ty = \case
  NoSize -> ptr $ toTType ty 
  Size n -> ArrayType (w64 n) $ toTType ty

-- Int to constant operant with bit size variations
toConsI1 :: Int -> Operand
toConsI1 = ConstantOperand . Int 1 . toInteger

toConsI16 :: Int -> Operand
toConsI16 = ConstantOperand . Int 16 . toInteger

toConsI32 :: Int -> Operand
toConsI32 = ConstantOperand . Int 32 . toInteger

toConsI64 :: Int -> Operand
toConsI64 = ConstantOperand . Int 64 . toInteger
