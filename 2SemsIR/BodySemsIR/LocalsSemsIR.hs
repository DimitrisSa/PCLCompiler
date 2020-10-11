module LocalsSemsIR where
import Common (Sems,Frml,Id(..),Type(..),Callable(..),Header(..),Env(..),PassBy(..),errAtId
              ,formalsToTypes,insToCallableMap,lookupInCallableMap,getEnv
              ,lookupInVariableMap,setEnv,(>>>),toList,fullType
              ,insToLabelMap,lookupInLabelMap,toTType,setCount)
import Data.Function (on)
import SemsCodegen(alloca,insToVariableMap,insToVariableMapFormalVal
                  ,insToVariableMapFormalRef)
import LLVM.AST (Operand(..))

varsWithTypeListSemsIR :: [([Id],Type)] -> Sems ()
varsWithTypeListSemsIR rvwtl = mapM_ varsWithTypeSemsIR rvwtl

varsWithTypeSemsIR :: ([Id],Type) -> Sems ()
varsWithTypeSemsIR (vars,ty) = mapM_ (insToSymTabVarWithType ty) $ reverse vars
  
insToSymTabVarWithType :: Type -> Id -> Sems ()
insToSymTabVarWithType ty id = do
  lookupInVariableMap id >>= \case 
    Just (_,_,True) -> errAtId "Duplicate Variable: " id
    _               -> return ()
  case fullType ty of
    True -> return ()
    _    -> errAtId "Can't declare 'array of': " id
  insToVariableMap id ty 

forwardSems :: Header -> Sems ()
forwardSems = \case
  ProcHeader id fs   -> checkId id >> checkFrmls id fs >> insProcDclrToMap id fs
  FuncHeader id fs t -> checkId id >> checkFrmlsType id fs t >> insFuncDclrToMap id fs t

insProcDclrToMap id fs = insToCallableMap id (ProcDclr $ reverse fs)
insFuncDclrToMap id fs t = insToCallableMap id (FuncDclr (reverse fs) t)
checkFrmlsType id fs t = checkFrmls id fs >> checkType id t

checkId :: Id -> Sems ()
checkId id = lookupInCallableMap id >>= \case
  Nothing -> return ()
  _       -> errAtId duplicateCallableErr id

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

headerChildSems :: [Frml] -> Header -> Sems ()
headerChildSems pfs = \case
  ProcHeader _ fs     -> headerChildSems' (trueFrmls fs ++ falseFrmls pfs) 
  FuncHeader id fs ty -> headerChildSems' (trueFrmls fs ++ falseFrmls pfs) >>
                         setEnv (InFunc id ty False)

trueFrmls :: [Frml] -> [(Bool,Frml)]
trueFrmls = map (\f -> (True,f))

falseFrmls :: [Frml] -> [(Bool,Frml)]
falseFrmls = map (\f -> (False,f))

headerChildSems' :: [(Bool,Frml)] -> Sems ()
headerChildSems' bfs = do
  let n = sum $ map (\(_,(_,ids,_)) -> length ids) bfs
  insToSymTabFrmls n $ reverse bfs
  setCount $ 2*n

insToSymTabFrmls :: Int -> [(Bool,Frml)] -> Sems ()
insToSymTabFrmls n = mapM_ (insToSymTabFrml n)

insToSymTabFrml :: Int -> (Bool,Frml) -> Sems ()
insToSymTabFrml n (b,(by,ids,t)) = mapM_ (insToSymTabVar n by t b) $ reverse ids

insToSymTabVar :: Int -> PassBy -> Type -> Bool -> Id -> Sems ()
insToSymTabVar n by ty b var = lookupInVariableMap var >>= \case
  Nothing -> case by of
    Val -> insToVariableMapFormalVal var ty n
    Ref -> insToVariableMapFormalRef var ty b n 
  _       -> errAtId "Duplicate Argument: " var

checkResult :: Sems ()
checkResult = getEnv >>= \case
  InFunc id _ False -> errAtId "Result not set for function: " id
  _                 -> return ()

headerParentSems :: Header -> Sems ()
headerParentSems = \case
  ProcHeader id fs    -> lookupInCallableMap id >>= procCases id (reverse fs)
  FuncHeader id fs ty -> lookupInCallableMap id >>= funcCases id (reverse fs) ty

procCases :: Id -> [Frml] -> Maybe (Callable,Operand) -> Sems ()
procCases id fs = \case
  Just (ProcDclr fs',_) -> insToSymTabIfFrmlsMatch id fs fs'
  Nothing               -> checkFrmls id fs >> insToCallableMap id (Proc fs)
  _                     -> errAtId duplicateCallableErr id

funcCases :: Id -> [Frml] -> Type -> Maybe (Callable,Operand) -> Sems ()
funcCases id fs ty = \case
  Just (FuncDclr fs' ty',_) -> insToSymTabIfFrmlsAndTypeMatch id fs fs' ty ty'
  Nothing                   -> checkFrmlsType id fs ty >> insToCallableMap id (Func fs ty)
  _                         -> errAtId duplicateCallableErr id

insToSymTabIfFrmlsMatch :: Id -> [Frml] -> [Frml] -> Sems ()
insToSymTabIfFrmlsMatch id fs fs' = sameTypes id fs fs' >> insToCallableMap id (Proc fs)

insToSymTabIfFrmlsAndTypeMatch :: Id -> [Frml] -> [Frml] -> Type -> Type -> Sems ()
insToSymTabIfFrmlsAndTypeMatch id fs fs' ty ty' = do
  sameTypes id fs fs'
  case ty == ty' of
    True -> insToCallableMap id (Func fs ty)
    _    -> errAtId "Result type missmatch between declaration and definition for: " id


sameTypes :: Id -> [Frml] -> [Frml] -> Sems ()
sameTypes id fs fs' = case ((==) `on` formalsToTypes) fs fs' of
  True -> return ()
  _    -> errAtId "Parameter type missmatch between declaration and definition for: " id

duplicateCallableErr :: String
duplicateCallableErr = "Duplicate Function/Procedure name: "
