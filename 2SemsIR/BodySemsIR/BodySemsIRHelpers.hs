module BodySemsIRHelpers where
import Prelude hiding (lookup)
import SemsCodegen (call,getElemPtrInBounds,callVoid,load,sitofp,store,alloca)
import Parser (ArrSize(..),Frml,Id(..),idString,Type(..),PassBy(..))
import SemsIRTypes (TyOper,TyOperBool,Sems,(>>>),errAtId,errPos,searchCallableInSymTabs
                   ,toTType,VariableMap,searchInAncestorMaps,getVariableMap,getLevel
                   ,VarType(..),get2ndVarIds,lookupInVariableMap,searchInVarNumMaps
                   ,getVarIdsInLevel)
import Helpers (symbatos,formalsToTypes)
import Control.Monad.Trans.Either (right)
import LLVM.AST (Operand)
import Data.List.Index (indexed)
import StmtSemsIR (assignmentSizeToNoSize)
import Data.Map (lookup)

parIdsToParOps :: VariableMap -> Bool -> [Id] -> [Operand]
parIdsToParOps parVM b = map (parIdsToParOp parVM b) 
  
parIdsToParOp :: VariableMap -> Bool -> Id -> Operand
parIdsToParOp parVM b pid = case b of
  False -> case lookup (pid,ToUse) parVM of
    Just (_,op) -> op
    Nothing     -> case lookup (pid,ToPass) parVM of
      Just (_,op) -> op
      Nothing     -> error $ "Should have found pid: " ++ idString pid
  _     -> case lookUpChildThenParentVars pid parVM of
    Just (_,op) -> op
    Nothing     -> error "Should have found it"

lookUpChildThenParentVars :: Id -> VariableMap -> Maybe TyOper
lookUpChildThenParentVars id vm = case lookup (id,Mine) vm of
    Nothing     -> case lookup (id,ToUse) vm of
      Nothing -> Nothing
      jtyop   -> jtyop
    jtyop   -> jtyop

callStmtSemsIR' :: Id -> [Frml] -> [TyOperBool] -> Sems ()
callStmtSemsIR' id fs typeOperBools = do
  (op,args) <- callSemsIR id fs typeOperBools
  callVoid op args

callRValueSemsIR' :: Id -> [Frml] -> Type -> [TyOperBool] -> Sems TyOper
callRValueSemsIR' id fs t typeOperBools = do
  (op,args) <- callSemsIR id fs typeOperBools
  op <- call op args
  right (t,op)

callSemsIR :: Id -> [Frml] -> [TyOperBool] -> Sems (Operand,[Operand])
callSemsIR id fs typeOperBools = do
  childArgs <- formalsExprsSemsIR id (formalsToTypes fs) typeOperBools
  op <- idToFunOper id
  (parIds,parForIds,level,_) <- case not $ elem (idString id) predefinedNames of
    True -> searchInAncestorMaps id
    _    -> return ([],[],0,mempty)
  --case idString id == "ok2" of
  --  True -> error $ "ok2 level:" ++ show level
  --  _    -> return ()
  pArgs <- case not $ elem (idString id) predefinedNames of
    True -> parOps id parIds level
    _    -> return []
  fArgs <- case not $ elem (idString id) predefinedNames of
    True -> do
      hisVarNum <- searchInVarNumMaps id 
      forIds <- calcForIds hisVarNum level
      getFArgs $ forIds ++ parForIds
    _    -> return []
  --case idString id == "ok2" of
  --  True -> error $ "ok2 fArgs:" ++ show fArgs
  --  _    -> return ()
  return (op,childArgs ++ pArgs ++ fArgs)

getFArgs :: [Id] -> Sems [Operand]
getFArgs = mapM getFArg

getFArg :: Id -> Sems Operand
getFArg id = lookupInVariableMap (id,ToPass) >>= \case
  Just (_,op) -> return op
  Nothing   -> lookupInVariableMap (id,ToUse) >>= \case
    Just (_,op) -> return op 
    Nothing   -> lookupInVariableMap (id,Mine) >>= \case
      Just (_,op) -> return op 
      Nothing   -> error $ "Should have found in varMap variable: " ++ idString id

calcForIds :: Int -> Int -> Sems [Id]
calcForIds hisVarNum level = do
  --error . show =<< get2ndVarIds
  --error $ show $ level
  (_,ids) <- getVarIdsInLevel level
  return $ drop hisVarNum ids 

parOps id parIds level = do
  myLevel <- getLevel
  parVM <- getVariableMap
  let parOps = parIdsToParOps parVM (level > myLevel) parIds
  return parOps

type ByTy = (PassBy,Type)

formalsExprsSemsIR :: Id -> [ByTy] -> [TyOperBool] -> Sems [Operand]
formalsExprsSemsIR id byTys tyOperBools = do
  case length byTys == length tyOperBools of
    True -> mapM (formalExprSemsIR id) $ indexed $ zip byTys tyOperBools
    _    -> errAtId "Wrong number of arguments in call of: " id

formalExprSemsIR :: Id -> (Int,(ByTy,TyOperBool)) -> Sems Operand
formalExprSemsIR id (i,(byTy,tyOperBool)) = case (byTy,tyOperBool) of
  ((Val,RealT),(IntT,op,True))  -> load op >>= sitofp
  ((Val,RealT),(IntT,op,False)) -> sitofp op
  ((Val,Pointer (Array NoSize t1)),(Pointer (Array (Size _) t2),op,True)) -> do
    case t1 == t2 of
      True -> return ()
      _    -> errorAtArg (i+1) id t1 t2
    op <- load op
    assignmentSizeToNoSize t2 op
  ((Val,t1),(t2,op,True))  -> checkSymbatos i id t1 t2 >> load op
  ((Val,t1),(t2,op,False)) -> checkSymbatos i id t1 t2 >> return op
  ((Ref,t1),(t2,op,False)) -> errAtId "Can't pass rvalue by reference at: " id
  ((Ref,t1),(t2,op,_)) -> do
    checkSymbatos i id (Pointer t1) (Pointer t2)
    case t2 of
      Array (Size _) t -> assignmentSizeToNoSize t op
      _                -> return op

checkSymbatos :: Int -> Id -> Type -> Type -> Sems ()
checkSymbatos i id t1 t2 = case symbatos (t1,t2) of
  True -> return () 
  _    -> errorAtArg (i+1) id t1 t2

errorAtArg :: Int -> Id -> Type -> Type ->Sems ()
errorAtArg i (Id posn str) t1 t2 =
  errPos posn $ concat ["Type mismatch at argument ", show i
                       ," in call of: ", str,"\n"
                       ,"\tExpected type: ", show t1,"\n"
                       ,"\tGiven type: ", show t2]

idToFunOper id = searchCallableInSymTabs id >>= \(_,op) -> return op

predefinedNames = ["writeInteger","writeBoolean","writeChar","writeReal","writeString"
                  ,"readString","readInteger","readBoolean","readChar","readReal","abs"
                  ,"arctan","ln","pi","trunc","round","ord","chr","fabs","sqrt","sin"
                  ,"cos","tan","exp"]
