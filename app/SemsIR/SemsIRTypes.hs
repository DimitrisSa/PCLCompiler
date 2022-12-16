{-# language LambdaCase #-}

module SemsIR.SemsIRTypes where
import Prelude hiding (lookup)
import Control.Monad.State (State,modify,get)
import Control.Monad.Trans.Either (EitherT,left)
import Data.Map (Map,empty,insert,lookup,adjust)
import LLVM.AST (Operand(..),Module,Global,moduleDefinitions,Definition(..),Terminator(..)
                ,Name(..),Named,Instruction,defaultModule)
import LLVM.AST.Constant (Constant(..))
import Data.Bits.Extras (w64)
import Data.String.Transform (toShortByteString)
import Parser as P (ArrSize(..),Type(..),Id(..),Frml,PassBy(..))
import LLVM.AST.Type as T (Type(..),ptr,i1,i8,i16,x86_fp80,void)
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
  deriving (Show)

data Callable =
  Proc [Frml]            |
  Func [Frml] P.Type     |
  ProcDclr [Frml]        |
  FuncDclr [Frml] P.Type
  deriving(Show,Eq)

data VarType = Mine | ToUse | ToPass
  deriving (Show,Eq,Ord)

type VariableMap = Map (Id,VarType) (P.Type,Operand)
type LabelMap    = Map Id Bool
type CallableMap = Map Id (Callable,Operand,Bool)
type FatherMap   = Map Id ([Id],[Id],Int,[SymbolTable])
type VarNumMap   = Map Id Int

data SymbolTable = SymbolTable {
   variableMap :: VariableMap
  ,labelMap    :: LabelMap
  ,callableMap :: CallableMap
  ,fatherMap   :: FatherMap
  ,forwardIds  :: [(Id,Bool)]
  ,varNumMap   :: VarNumMap
  ,varIds      :: (Int,[Id])
  }
  deriving (Show)

type TyOperBool = (P.Type,Operand,Bool)
type TyOper = (P.Type,Operand)
type Error = String
type StateType = (Env,[SymbolTable],Module,CodegenState,Int)

-- All of the state (Semantics,Module,Codegen)
type Sems  = EitherT Error (State StateType)

-- Initial state
emptyCodegen :: CodegenState
emptyCodegen = CodegenState (toShortName "entry") empty 1 0 empty

emptySymbolTable :: SymbolTable
emptySymbolTable = SymbolTable empty empty empty empty [] empty (0,[])

initState :: StateType
initState = (InProc,[emptySymbolTable],defaultModule,emptyCodegen,0)

-- Composition with arguments in a more logical order
infixl 9 >>>
(>>>) = (flip (.))

getLevel :: Sems Int
getLevel = get >>= (\(_,_,_,_,l) -> l) >>> return

-- Codegen State operations
modifyCodegen :: (CodegenState -> CodegenState) -> Sems ()
modifyCodegen f = modify $ \(env,sts,m,cgen,i) -> (env,sts,m,f cgen,i)

setCount :: Word -> Sems ()
setCount i = modifyCodegen $ \s -> s { count = i }

getCount :: Sems Word
getCount = getFromCodegen count

getFromCodegen :: (CodegenState -> a) -> Sems a
getFromCodegen f = get >>= (\(_,_,_,x,_) -> f x) >>> return

toShortName :: String -> Name
toShortName = toShortByteString >>> Name

-- Module State operations
getDefs :: Sems [Definition]
getDefs = get >>= (\(_,_,x,_,_) -> moduleDefinitions x) >>> return

addDef :: Definition -> Sems ()
addDef d = modifyMod $ \s -> s { moduleDefinitions = (moduleDefinitions s) ++ [d] }

addGlobalDef :: Global -> Sems ()
addGlobalDef = GlobalDefinition >>> addDef

modifyMod :: (Module -> Module) -> Sems ()
modifyMod f = modify $ \(env,sts,m,cgen,i) -> (env,sts,f m,cgen,i)

-- Environment State operations
getEnv :: Sems Env
getEnv = get >>= (\(x,_,_,_,_) -> x) >>> return

setEnv :: Env -> Sems ()
setEnv env = modify $ \(_,sts,m,cgen,i) -> (env,sts,m,cgen,i)

-- Symbol Tables State operations
getSymTabs :: Sems [SymbolTable]
getSymTabs = get >>= (\(_,x,_,_,_) -> x) >>> return

getMap :: (SymbolTable -> a) -> Sems a
getMap map = getSymTabs >>= head >>> map >>> return

get2ndVarMap :: Sems VariableMap
get2ndVarMap = getSymTabs >>= tail >>> head >>> variableMap >>> return

getVariableMap :: Sems VariableMap
getVariableMap = getMap variableMap

getLabelMap :: Sems LabelMap
getLabelMap = getMap labelMap

getCallableMap :: Sems CallableMap
getCallableMap = getMap callableMap

getFatherMap :: Sems FatherMap
getFatherMap = getMap fatherMap

getVarNumMap :: Sems VarNumMap
getVarNumMap = getMap varNumMap

get2ndVarNumMap :: Sems VarNumMap
get2ndVarNumMap = getSymTabs >>= tail >>> head >>> varNumMap >>> return

getVarIds :: Sems (Int,[Id])
getVarIds = getMap varIds

get2ndVarIds :: Sems (Int,[Id])
get2ndVarIds = getSymTabs >>= tail >>> head >>> varIds >>> return

getVarIdsInLevel :: Int -> Sems (Int,[Id])
getVarIdsInLevel level =
  getSymTabs >>= reverse >>> (!!(level -1)) >>> varIds >>> return

getVarIdsNum :: Sems Int
getVarIdsNum = getVarIds >>= fst >>> return

modifyVarIds :: ((Int,[Id]) -> (Int,[Id])) -> Sems ()
modifyVarIds f = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st { varIds = f $ varIds st }:sts,m,cgen,i)

insToLabelMap :: Id -> Bool -> Sems ()
insToLabelMap label b = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st { labelMap = insert label b $ labelMap st }:sts,m,cgen,i)

insToCallableMap :: [Id] -> Id -> Callable -> Bool -> Sems ()
insToCallableMap pids id cal b = do
  parVM <- getVariableMap --
  let parTys = map snd $ parIdsToParTys parVM pids --
  let idToName'' = case b of
                    True  -> idToName
                    False -> idToName'
  modify $ \(e,st:sts,m,cgen,i) ->
    (e,st {
       callableMap = insert id (cal,calToOper parTys cal $ idToName'' id,b) $ callableMap st
     }:sts,m,cgen,i)

insTo2ndVarMap :: Id -> TyOper -> Sems ()
insTo2ndVarMap id tyop = modify $ \(e,st1:st:sts,m,cgen,i) ->
  (e,st1:st { variableMap = insert (id,ToPass) tyop $ variableMap st }:sts,m,cgen,i)

modify2ndCallableMap :: Id -> (Operand -> Operand) -> Sems ()
modify2ndCallableMap id f = modify $ \(e,st1:st:sts,m,cgen,i) ->
  (e,st1:st {
    callableMap = adjust (\(cal,op,b) -> (cal,f op,b)) id $ callableMap st
  }:sts,m,cgen,i)

modifyCallableMap :: Id -> (Operand -> Operand) -> Sems ()
modifyCallableMap id f = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st {
    callableMap = adjust (\(cal,op,b) -> (cal,f op,b)) id $ callableMap st
  }:sts,m,cgen,i)

parIdsToParTys :: VariableMap -> [Id] -> [(P.Type,T.Type)]
parIdsToParTys parVM = map (parIdsToParTy parVM) 
  
parIdsToParTy :: VariableMap -> Id -> (P.Type,T.Type)
parIdsToParTy parVM pid = case lookup (pid,Mine) parVM of
  Just (ty,_) -> (ty,toTType $ Pointer ty)
  Nothing     -> case lookup (pid,ToUse) parVM of
    Just (ty,_) -> (ty,toTType $ Pointer ty)
    Nothing     -> case lookup (pid,ToPass) parVM of
      Just (ty,_) -> (ty,toTType $ Pointer ty)
      Nothing     -> error $ "Should have found: " ++ idString pid ++ " map: \n" ++
                        show parVM

insToFatherMap :: Id -> ([Id],[Id],Int,[SymbolTable]) -> Sems ()
insToFatherMap id state = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st { fatherMap = insert id state $ fatherMap st }:sts,m,cgen,i)

insToVarNumMap :: Id -> Int -> Sems ()
insToVarNumMap id num = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st { varNumMap = insert id num $ varNumMap st }:sts,m,cgen,i)

insToForwardIds :: Id -> Bool -> Sems ()
insToForwardIds id b = modify $ \(e,st:sts,m,cgen,i) ->
  (e,st { forwardIds = (id,b):forwardIds st }:sts,m,cgen,i)

toName :: String -> Name
toName = toShortByteString >>> Name

idToName :: Id -> Name
idToName = idString >>> toName

idToName' :: Id -> Name
idToName' = idString >>> (++".") >>> toName

consGlobalRef :: T.Type -> Name -> Operand
consGlobalRef ty name = ConstantOperand $ C.GlobalReference ty name

calToOper :: [T.Type] -> Callable -> Name -> Operand
calToOper parTys cal name = consGlobalRef (calToTy parTys cal) name

calToTy :: [T.Type] -> Callable -> T.Type --
calToTy parTys = \case
  Proc frmls        -> procToTy frmls parTys
  Func frmls ty     -> funcToTy frmls ty parTys
  ProcDclr frmls    -> procToTy frmls parTys
  FuncDclr frmls ty -> funcToTy frmls ty parTys

funcToTy :: [Frml] -> P.Type -> [T.Type] -> T.Type
funcToTy frmls ty parTys = ptr $ FunctionType {
    resultType = toTType ty
  , argumentTypes = frmlsToArgTypes frmls ++ parTys
  , isVarArg = False
  }

procToTy :: [Frml] -> [T.Type] -> T.Type
procToTy frmls parTys = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = frmlsToArgTypes frmls  ++ parTys
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

lookupInVariableMap :: (Id,VarType) -> Sems (Maybe (P.Type,Operand))
lookupInVariableMap idVarT = getVariableMap >>= lookup idVarT >>> return

lookupInLabelMap :: Id -> Sems (Maybe Bool)
lookupInLabelMap = lookupInMap getLabelMap

lookupInCallableMap :: Id -> Sems (Maybe (Callable,Operand,Bool))
lookupInCallableMap = lookupInMap getCallableMap

lookupInVarNumMap :: Id -> Sems (Maybe Int)
lookupInVarNumMap = lookupInMap getVarNumMap

lookupIn2ndVarNumMap :: Id -> Sems (Maybe Int)
lookupIn2ndVarNumMap = lookupInMap get2ndVarNumMap

searchCallableInSymTabs :: Id -> Sems (Callable,Operand,Bool)
searchCallableInSymTabs id = getSymTabs >>= 
  searchInSymTabs callableMap id "Undeclared function or procedure in call: "

searchInAncestorMaps :: Id -> Sems ([Id],[Id],Int,[SymbolTable])
searchInAncestorMaps id = getSymTabs >>= 
  searchInSymTabs fatherMap id (error $ "should have found in ancestors: " ++ idString id)

searchInVarNumMaps :: Id -> Sems Int
searchInVarNumMaps id = getSymTabs >>= 
  searchInSymTabs varNumMap id
    (error $ "Should have found in varNumMap myVarNum: " ++ idString id)

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
  RealT           -> x86_fp80
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
