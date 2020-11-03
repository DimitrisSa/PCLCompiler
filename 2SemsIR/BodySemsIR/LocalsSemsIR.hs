module LocalsSemsIR where
import Common (Sems,Frml,Id(..),Type(..),Callable(..),Header(..),Env(..),PassBy(..),errAtId
              ,formalsToTypes,insToCallableMap,lookupInCallableMap,getEnv,getCount
              ,lookupInVariableMap,setEnv,(>>>),toList,fullType,VarType(..)
              ,insToLabelMap,lookupInLabelMap,toTType,setCount)
import Data.Function (on)
import SemsCodegen(alloca,insToVariableMap,insToVariableMapFormalVal
                  ,insToVariableMapFormalRef)
import LLVM.AST (Operand(..))
import InitSymTab (dummy)

varsWithTypeListSemsIR :: [([Id],Type)] -> Sems ()
varsWithTypeListSemsIR rvwtl = mapM_ varsWithTypeSemsIR rvwtl

varsWithTypeSemsIR :: ([Id],Type) -> Sems ()
varsWithTypeSemsIR (vars,ty) = mapM_ (insToSymTabVarWithType ty) $ reverse vars
  
insToSymTabVarWithType :: Type -> Id -> Sems ()
insToSymTabVarWithType ty (Id p str) = do
  lookupInVariableMap ((Id p str),Mine) >>= \case 
    Nothing -> return ()
    _       -> errAtId "Duplicate Variable: " (Id p str)
  case fullType ty of
    True -> return ()
    _    -> errAtId "Can't declare 'array of': " $ Id p $ takeWhile (/= '.') str
  insToVariableMap (Id p str) ty 

forwardSems :: Header -> Sems ()
forwardSems = \case
  ProcHeader id fs   -> checkId id >> checkFrmls id fs >> insProcDclrToMap id fs 
  FuncHeader id fs t -> checkId id >> checkFrmlsType id fs t >> insFuncDclrToMap id fs t

insProcDclrToMap id fs = insToCallableMap [] id (ProcDclr $ reverse fs) True
insFuncDclrToMap id fs t = insToCallableMap [] id (FuncDclr (reverse fs) t) True
checkFrmlsType id fs t = checkFrmls id fs >> checkType id t

checkId :: Id -> Sems ()
checkId id = lookupInCallableMap id >>= \case
  Nothing          -> return ()
  Just (_,_,False) -> return ()
  _                ->  errAtId duplicateCallableErr id

checkFrmls :: Id -> [Frml] -> Sems ()
checkFrmls id fs = mapM_ (checkFrml id) fs

checkFrml :: Id -> Frml -> Sems ()
checkFrml id = \case
  (Val,_,Array _ _) -> errAtId "Can't pass array by value in: " id;
  _                 -> return ()

checkType :: Id -> Type -> Sems ()
checkType id = \case
  Array _ _ -> errAtId "Function can't have a return type of array " id
  _         -> return ()

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ $ \label -> lookupInLabelMap label >>= \case 
  Nothing -> insToLabelMap label False
  _       -> errAtId "Duplicate label declaration: " label

headerChildSems :: Int -> Header -> Sems ()
headerChildSems pl = \case
  ProcHeader _ fs     -> headerChildSems' pl fs
  FuncHeader id fs ty -> do
    headerChildSems' pl fs
    setEnv (InFunc id ty False)
    insToVariableMap (dummy "result") ty

headerChildSems' :: Int -> [Frml] -> Sems ()
headerChildSems' pl fs = do
  let n = sum $ map (\(_,ids,_) -> length ids) fs
  insToSymTabFrmls (n+pl) $ reverse fs
  --let nVal = sum $ map (\(by,ids,_) -> case by of Val -> length ids; _ -> 0) fs
  --error $ show n
  setCount $ fromIntegral $ 2*n + pl -1

insToSymTabFrmls :: Int -> [Frml] -> Sems ()
insToSymTabFrmls n = mapM_ (insToSymTabFrml n)

insToSymTabFrml :: Int -> Frml -> Sems ()
insToSymTabFrml n (by,ids,t) = mapM_ (insToSymTabVar n by t) $ reverse ids

insToSymTabVar :: Int -> PassBy -> Type -> Id -> Sems ()
insToSymTabVar n by ty var = lookupInVariableMap (var,Mine) >>= \case
  Nothing -> case by of
    Val -> insToVariableMapFormalVal var ty n
    Ref -> insToVariableMapFormalRef var ty n
  _       -> error "Should have already put a duplicate error"

checkResult :: Sems ()
checkResult = getEnv >>= \case
  InFunc id _ False -> errAtId "Result not set for function: " id
  _                 -> return ()

headerParentSems :: [Id] -> Header -> Sems ()
headerParentSems pids = \case
  ProcHeader id fs    -> lookupInCallableMap id >>= procCases pids id (reverse fs)
  FuncHeader id fs ty -> lookupInCallableMap id >>= funcCases pids id (reverse fs) ty

procCases :: [Id] -> Id -> [Frml] -> Maybe (Callable,Operand,Bool) -> Sems ()
procCases pids id fs = \case
  Just (ProcDclr fs',_,_) -> insToSymTabIfFrmlsMatch pids id fs fs'
  Nothing                 -> checkFrmls id fs >> insToCallableMap pids id (Proc fs) True
  Just (_,_,False)        -> checkFrmls id fs >> insToCallableMap pids id (Proc fs) True
  _                       -> errAtId duplicateCallableErr id

funcCases :: [Id] -> Id -> [Frml] -> Type -> Maybe (Callable,Operand,Bool) -> Sems ()
funcCases pids id fs ty = \case
  Just (FuncDclr fs' ty',_,_) -> insToSymTabIfFrmlsAndTypeMatch pids id fs fs' ty ty'
  Nothing                   -> do
    checkFrmlsType id fs ty
    insToCallableMap pids id (Func fs ty) True
  Just (_,_,False)          -> do
    checkFrmlsType id fs ty
    insToCallableMap pids id (Func fs ty) True
  _                         -> errAtId duplicateCallableErr id

insToSymTabIfFrmlsMatch :: [Id] -> Id -> [Frml] -> [Frml] -> Sems ()
insToSymTabIfFrmlsMatch pids id fs fs' = do
  sameTypes id fs fs'
  insToCallableMap pids id (Proc fs) True

insToSymTabIfFrmlsAndTypeMatch :: [Id] -> Id -> [Frml] -> [Frml] -> Type -> Type -> Sems ()
insToSymTabIfFrmlsAndTypeMatch pids id fs fs' ty ty' = do
  sameTypes id fs fs'
  case ty == ty' of
    True -> insToCallableMap pids id (Func fs ty) True
    _    -> errAtId "Result type missmatch between declaration and definition for: " id

sameTypes :: Id -> [Frml] -> [Frml] -> Sems ()
sameTypes id fs fs' = case ((==) `on` formalsToTypes) fs fs' of
  True -> return ()
  _    -> errAtId "Parameter type missmatch between declaration and definition for: " id

duplicateCallableErr :: String
duplicateCallableErr = "Duplicate Function/Procedure name: "
