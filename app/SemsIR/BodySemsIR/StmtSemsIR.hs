{-# language LambdaCase #-}

module SemsIR.BodySemsIR.StmtSemsIR where
import Prelude hiding (lookup)
import Common (ArrSize(..),Type(..),Sems,TyOper,Id,toTType,symbatos,fullType,errPos,(>>>)
              ,toConsI64,errAtId,insToLabelMap,getEnv,Env(..),lookupInVariableMap
              ,VarType(..))
import LLVM.AST (Operand)
import LLVM.AST.Type (i8)
import InitSymTab (dummy)
import SemsCodegen (store,getElemPtrInBounds,cons,sitofp,free,callVoid,call,load,bitcast
                   ,malloc,mul,zext64,retVoid,ret,alloca,addBlock,setBlock,fresh)
import qualified LLVM.AST.Constant as C (Constant(..))

returnIR :: Sems ()
returnIR = do
  env <- getEnv 
  case env of
    InProc            -> retVoid
    InFunc id ty bool -> do
      op <- lookupInVariableMap (dummy "result",Mine) >>= \case
        Just (_,op) -> return op
        Nothing     -> error "Shouldn't happen"
      op <- load op
      ret op 

returnIRNext :: Sems ()
returnIRNext = do
  i <- fresh
  nextBlock <- addBlock $ "next" ++ show i
  setBlock nextBlock

labelCases :: Id -> Maybe Bool -> Sems ()
labelCases id = \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId "Duplicate label: " id
  Nothing    -> errAtId "Undeclared label: " id

goToCases :: Id -> Maybe Bool -> Sems ()
goToCases id = \case
  Nothing -> errAtId "Goto undefined label: " id
  _       -> return ()

boolCases :: (Int,Int) -> String -> TyOper -> Sems Operand
boolCases posn err = \case
  (BoolT,op) -> return op
  _          -> errPos posn $ "Non-boolean expression in " ++ err

pointerCases :: (Int,Int) -> String -> TyOper -> Sems TyOper
pointerCases posn err = \case
  (Pointer t,op) -> return (t,op)
  _              -> errPos posn err

newPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
newPointerCases posn = pointerCases posn "Non-pointer in new statement"

mallocBytes :: Common.Type -> Int
mallocBytes = \case
  IntT  -> 2
  CharT -> 1
  RealT -> 8
  BoolT -> 1
  Array (Size n) ty -> n * mallocBytes ty
  Pointer ty -> 8
  Array _ ty -> mallocBytes ty

mallocBytesOper = mallocBytes >>> toConsI64
  
newNoExprSemsIR :: (Int,Int) -> TyOper -> Sems ()
newNoExprSemsIR posn (lt,lOp) = do
  (lt,lOp) <- newPointerCases posn (lt,lOp)
  caseFalseThrowErr posn "new l statement: l must not be of type ^array of t" $ fullType lt
  i8ptr <- call malloc [mallocBytesOper lt]
  newPtr <- bitcast i8ptr $ toTType lt
  store lOp newPtr

newExprSemsIR :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
newExprSemsIR posn ((et,eOp),(lt,lOp)) = do
  intCases posn et 
  (lt,lOp) <- newPointerCases posn (lt,lOp)
  let bool = not $ fullType lt
  caseFalseThrowErr posn "new [e] l statement: l must be of type ^array of t" bool
  let t = case lt of
            Array NoSize t -> t
            _              -> error "Shouldn't happen"
  eOp' <- zext64 eOp
  numOfBytesOper <- mul eOp' $ mallocBytesOper lt
  i8ptr <- call malloc [numOfBytesOper]
  newPtr <- bitcast i8ptr $ toTType t
  i8ptr' <- call malloc [mallocBytesOper $ Pointer t]
  newPtr' <- bitcast i8ptr' $ toTType $ Pointer t
  store newPtr' newPtr 
  store lOp newPtr'

intCases posn = \case
  IntT -> return ()
  _    -> errPos posn "new [e] l statement: e must be of type integer" 

caseFalseThrowErr :: (Int,Int) -> String -> Bool -> Sems ()
caseFalseThrowErr posn err = \case
  True -> return ()
  _    -> errPos posn err

dispPointerCases :: (Int,Int) -> TyOper -> Sems TyOper
dispPointerCases posn = pointerCases posn "Non-pointer in dispose statement"

dispWithoutSems :: (Int,Int) -> TyOper -> Sems ()
dispWithoutSems posn (lt,lOp) = do
  (lt,lOp) <- dispPointerCases posn (lt,lOp)
  let bool = fullType lt
  caseFalseThrowErr posn "dispose l statement: l must not be of type ^array of t" bool
  lOp' <- load lOp
  newPtr <- bitcast lOp' i8
  callVoid free [newPtr]
  store lOp $ cons $ C.Null $ toTType $ Pointer lt

dispWithSems :: (Int,Int) -> TyOper -> Sems ()
dispWithSems posn (lt,lOp) = do
  (lt,lOp) <- dispPointerCases posn (lt,lOp)
  let bool = not $ fullType lt
  caseFalseThrowErr posn "dispose [] l statement: l must be of type ^array of t" bool
  lOp' <- load lOp
  newPtr <- bitcast lOp' i8
  callVoid free [newPtr]
  store lOp $ cons $ C.Null $ toTType $ Pointer lt

assignmentSemsIR' :: (Int,Int) -> (TyOper,TyOper) -> Sems ()
assignmentSemsIR' posn ((lt,lOp),(et,eOp)) = do
  caseFalseThrowErr posn (assignmentSemsIRErr lt et) (symbatos (lt,et))
  eOp' <- case (lt,et) of 
          (RealT,IntT)    -> sitofp eOp
          (Pointer t,Nil) -> return $ cons $ C.Null $ toTType $ Pointer t
          (Pointer (Array NoSize t1),Pointer (Array (Size _) _)) ->
            assignmentSizeToNoSize t1 eOp
          _               -> return eOp
  store lOp eOp'

assignmentSizeToNoSize :: Type -> Operand -> Sems Operand
assignmentSizeToNoSize t1 eOp =  do
  eOp' <- getElemPtrInBounds eOp 0
  eOp  <- alloca $ toTType  $ Pointer t1
  store eOp eOp'
  return eOp

assignmentSemsIRErr lt et = concat ["Type mismatch in assignment: \n"
                                   ,"\tLeft type: ",show lt,"\n"
                                   ,"\tRight type: ",show et]
