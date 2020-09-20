module SemsTypes where
import Prelude hiding (lookup)
import Parser as P
import Control.Monad.State 
import Control.Monad.Trans.Either 
import Data.Map (Map,empty,insert,lookup)
import LLVM.AST
import LLVM.AST.Type as T
import LLVM.AST.Constant
import Data.Bits.Extras
import Data.String.Transform

type TyOper = (P.Type,Operand)

data Callable =
  Proc [Frml]            |
  Func [Frml] P.Type     |
  ProcDclr [Frml]        |
  FuncDclr [Frml] P.Type
  deriving(Show,Eq)

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  }

data CodegenState
  = CodegenState {
    currentBlock :: Name                     
  , blocks       :: Map Name BlockState  
  , symtab       :: [(String, Operand)]              
  , blockCount   :: Int                      
  , count        :: Word                     
  , names        :: Names
  } deriving Show

type Names = Map String Int

data BlockState
  = BlockState {
    idx   :: Int                            
  , stack :: [Named Instruction]            
  , term  :: Maybe (Named Terminator)       
  } deriving Show

data Env = InProc | InFunc Id P.Type Bool

type VariableMap = Map Id P.Type
type LabelMap    = Map Id Bool
type CallableMap = Map Id Callable
type Error       = String
type Sems        = EitherT Error (State (Env,[SymbolTable],Module,CodegenState))

emptySymbolTable = SymbolTable empty empty empty
initState = (InProc,[emptySymbolTable],defaultModule,emptyCodegen)

infixl 9 >>>
(>>>) = (flip (.))

modifyCodegen :: (CodegenState -> CodegenState) -> Sems ()
modifyCodegen f = modify $ \(env,sts,m,cgen) -> (env,sts,m,f cgen)

getFromCodegen :: (CodegenState -> a) -> Sems a
getFromCodegen f = get >>= (\(_,_,_,x) -> f x) >>> return

emptyCodegen :: CodegenState
emptyCodegen = CodegenState (toShortName "entry") empty [] 1 0 empty

toShortName = toShortByteString >>> Name

getDefs :: Sems [Definition]
getDefs = get >>= (\(_,_,x,_) -> moduleDefinitions x) >>> return

addDef :: Definition -> Sems ()
addDef d = modifyMod $ \s -> s { moduleDefinitions = (moduleDefinitions s) ++ [d] }

addGlobalDef :: Global -> Sems ()
addGlobalDef = GlobalDefinition >>> addDef

modifyMod :: (Module -> Module) -> Sems ()
modifyMod f = modify $ \(env,sts,m,cgen) -> (env,sts,f m,cgen)

getEnv :: Sems Env
getEnv = get >>= (\(x,_,_,_) -> x) >>> return

setEnv :: Env -> Sems ()
setEnv env = modify $ \(_,sts,m,cgen) -> (env,sts,m,cgen)

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

insToVariableMap :: Id -> P.Type -> Sems ()
insToVariableMap var ty = modify $ \(e,st:sts,m,cgen) ->
  (e,st { variableMap = insert var ty $ variableMap st }:sts,m,cgen)

insToLabelMap :: Id -> Bool -> Sems ()
insToLabelMap label b = modify $ \(e,st:sts,m,cgen) ->
  (e,st { labelMap = insert label b $ labelMap st }:sts,m,cgen)

insToCallableMap :: Id -> Callable -> Sems ()
insToCallableMap id cal = modify $ \(e,st:sts,m,cgen) ->
  (e,st { callableMap = insert id cal $ callableMap st }:sts,m,cgen)

lookupInMap :: Sems (Map Id a) -> Id -> Sems (Maybe a)
lookupInMap getMap id = getMap >>= lookup id >>> return

lookupInVariableMap :: Id -> Sems (Maybe P.Type)
lookupInVariableMap = lookupInMap getVariableMap

lookupInLabelMap :: Id -> Sems (Maybe Bool)
lookupInLabelMap = lookupInMap getLabelMap

lookupInCallableMap :: Id -> Sems (Maybe Callable)
lookupInCallableMap = lookupInMap getCallableMap

searchVarInSymTabs :: Id -> Sems P.Type
searchVarInSymTabs id =
  getSymTabs >>= searchInSymTabs variableMap id "Undeclared variable: "

searchCallableInSymTabs :: Id -> Sems Callable
searchCallableInSymTabs id = getSymTabs >>= 
  searchInSymTabs callableMap id "Undeclared function or procedure in call: "

searchInSymTabs :: (SymbolTable -> Map Id a) -> Id -> Error -> [SymbolTable] -> Sems a
searchInSymTabs map id err = \case
  st:sts -> case lookup id $ map st of
    Just val -> return val
    Nothing  -> searchInSymTabs map id err sts
  []     -> errAtId err id

errAtId :: String -> Id -> Sems a
errAtId err (Id posn str) = errPos posn $ err ++ str

errPos (li,co) err = left $ concat [show li,":",show co,": ",err] 

toTType :: P.Type -> T.Type
toTType = \case
  Nil           -> undefined
  IntT          -> i16
  RealT         -> double
  BoolT         -> i1
  CharT         -> i8
  P.Array size ty -> arrayToTType ty size
  Pointer ty    -> ptr $ toTType ty

arrayToTType :: P.Type -> ArrSize -> T.Type
arrayToTType ty = \case
  NoSize -> toTType ty -- is this right? what could the type be
  Size n -> ArrayType (w64 n) $ toTType ty

toConsI16 :: Int -> Operand
toConsI16 = ConstantOperand . Int 16 . toInteger

toConsI32 :: Int -> Operand
toConsI32 = ConstantOperand . Int 32 . toInteger

toConsI1 :: Int -> Operand
toConsI1 = ConstantOperand . Int 1 . toInteger
