{-# language LambdaCase #-}

module SemsIR.SemsIR where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either (right)
import Common (Sems,Expr(..),Id(..),Frml,TyOper,Type(..),Callable(..),RVal(..),LVal(..)
              ,DispType(..),New(..),ArrSize(..),Stmt(..),Header(..),Body(..),Program(..)
              ,Local(..),(>=>),errAtId,searchCallableInSymTabs,(>>>),TyOperBool,elems
              ,lookupInLabelMap,toTType,errPos,put,get,modifyMod,delete,modifyVarIds
              ,getLabelMap,toList,emptySymbolTable,getCallableMap,toName,emptyCodegen
              ,modifyCodegen,VariableMap,getVariableMap,setEnv,Env(..),insToFatherMap
              ,getFatherMap,lookup,variableMap,labelMap,callableMap,fatherMap,getEnv
              ,SymbolTable(..),CallableMap,insert,VariableMap,insToForwardIds,getVarIds
              ,VarType(..),insToVarNumMap,getVarIdsNum,getVarNumMap,VarNumMap,adjust
              ,lookupIn2ndVarNumMap,get2ndVarIds,insTo2ndVarMap,modify2ndCallableMap
              ,lookupInVarNumMap,modifyCallableMap)
import InitSymTab (initSymTab,dummy)
import LocalsSemsIR (varsWithTypeListSemsIR,insToSymTabLabels,forwardSems
                    ,headerParentSems,headerChildSems,checkResult)
import ValSemsIR (binOpNumCases,comparisonCases,binOpBoolCases
                 ,binOpIntCases,unaryOpNumCases,notCases,dereferenceCases,indexingCases
                 ,resultTypeOper)
import StmtSemsIR (dispWithSems,dispWithoutSems,newNoExprSemsIR,newExprSemsIR
                  ,assignmentSemsIR',boolCases,labelCases,goToCases,returnIR,returnIRNext)
import SemsCodegen (cons,call,store,load,getElemPtr',alloca,setBlock,br,insToVariableMap
                   ,cbr,addBlock,fresh,retVoid,defineFun,ret,getElemPtrInt)
import LLVM.AST (Operand(..),moduleName,Name,argumentTypes)
import qualified LLVM.AST.Type as T (void,Type(..),ptr)
import Data.String.Transform (toShortByteString)
import Data.Char (ord)
import Data.List (nub,partition)
import Data.List.Index (indexed)
import BodySemsIRHelpers (callRValueSemsIR',callStmtSemsIR',lookUpChildThenParentVars)
import LLVM.AST.Float as F (SomeFloat(..))
import qualified LLVM.AST.Constant as C (Constant(..))

semanticsAndIRFunction :: Program -> Sems ()
semanticsAndIRFunction (P id body) = do
  modifyMod $ \mod -> mod { moduleName = toShortByteString $ idString id }
  initSymTab
  defineFun [] [] "main" T.void [] $ do
    entry <- addBlock "entry"
    setBlock entry
    bodySemsIR body
    retVoid

bodySemsIR :: Body -> Sems ()
bodySemsIR (Body locals stmts) = do
  localsSemsIR (reverse locals) 
  stmtsSemsIR (reverse stmts) 
  getLabelMap >>= toList >>> (mapM_ $ \case
    (id,False) -> errAtId "Label declared but not used: " id
    _          -> return ())

localsSemsIR :: [Local] -> Sems ()
localsSemsIR locals = do
  mapM_ localSemsIR1 locals 
  modifyVarIds $ \(i,ids) -> (i,reverse ids)
  mapM_ localSemsIR2 locals 
  getCallableMap >>= toList >>> mapM_ (\case
    (id,(ProcDclr _  ,_,_)) -> errAtId "No definition for procedure declaration: " id
    (id,(FuncDclr _ _,_,_)) -> errAtId "No definition for function declaration: " id
    _                       -> return ())

addIdsToVarIds :: [([Id],Type)] -> Sems () 
addIdsToVarIds = mapM_ addIdsToVarIds' . reverse

addIdsToVarIds' :: ([Id],Type) -> Sems () 
addIdsToVarIds' = mapM_ addIdToVarIds . reverse . fst

addIdToVarIds :: Id -> Sems () 
addIdToVarIds id = modifyVarIds (\(i,ids) -> (i+1,id:ids))

localSemsIR1 :: Local -> Sems ()
localSemsIR1 = \case
  VarsWithTypeList vwtl -> varsWithTypeListSemsIR (reverse vwtl) >>
                           addIdsToVarIds vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySemsIR h b >>
                           getVarIdsNum >>= insToVarNumMap (idFromHeader h)
  Forward h             -> forwardSems h 

idFromHeader :: Header -> Id
idFromHeader = \case
  ProcHeader id _   -> id
  FuncHeader id _ _ -> id

getForwardCals :: CallableMap -> [Id] -> [(Id,Callable,Operand)]
getForwardCals cm = map (getForwardCal $ cm)  

getForwardCal :: CallableMap -> Id -> (Id,Callable,Operand)
getForwardCal cm id = case lookup id cm of
  Just (cal,op,b) -> (id,cal,op)
  _               -> error $ errString ++ idString id

errString = "Should have found in callable map forward id: "

insToCalMapForwardCals :: CallableMap -> [(Id,Callable,Operand)] -> CallableMap
insToCalMapForwardCals cm = foldl insToCalMapForwardCal cm 

insToCalMapForwardCal :: CallableMap -> (Id,Callable,Operand) -> CallableMap
insToCalMapForwardCal cm (id,cal,op) = insert id (cal,op,True) cm 

calcToPassIds :: Int -> Sems ([Id],[Id])
calcToPassIds myVarNum = do
  (_,ids) <- get2ndVarIds
  return $ splitAt myVarNum ids 

calcToPassIdsForward :: Int -> Sems ([Id],[Id])
calcToPassIdsForward myVarNum = do
  (_,ids) <- getVarIds
  return $ splitAt myVarNum ids 

insForIdsTo2ndVarMap :: VariableMap -> [Id] -> Sems ()
insForIdsTo2ndVarMap varMap2 = mapM_ (insForIdTo2ndVarMap varMap2)

insForIdTo2ndVarMap :: VariableMap -> Id -> Sems ()
insForIdTo2ndVarMap varMap2 forId = case lookup (forId,ToPass) varMap2 of
  Just tyop -> insTo2ndVarMap forId tyop
  Nothing   -> case lookup (forId,ToUse) varMap2 of
    Just tyop -> insTo2ndVarMap forId tyop 
    Nothing   -> case lookup (forId,Mine) varMap2 of
      Just tyop -> insTo2ndVarMap forId tyop 
      Nothing   -> error $ "Should have found: " ++ idString forId ++ " varMap2: \n" ++
                        show varMap2 

correctReference :: VariableMap -> Id -> [Id] -> Sems ()
correctReference varMap2 id forIds = do
  let forTys = getAdditionalReferenceTypes varMap2 forIds 
  correctReference' id forTys

correctReferenceForward :: VariableMap -> Id -> [Id] -> Sems ()
correctReferenceForward varMap2 id forIds = do
  let forTys = getAdditionalReferenceTypes varMap2 forIds 
  correctReferenceForward' id forTys

correctReferenceForward' :: Id -> [T.Type] -> Sems ()
correctReferenceForward' id forTys = do
  --case idString id == "print3" of
  --  True -> error $ show forTys
  --  _    -> return ()
  modifyCallableMap id $ f forTys

getAdditionalReferenceTypes :: VariableMap -> [Id] -> [T.Type]
getAdditionalReferenceTypes varMap2 = map (getAdditionalReferenceType varMap2)

--correctReference' :: Id -> [T.Type] -> Sems ()
--correctReference' id forTys = modify2ndCallableMap id $
--  \(ConstantOperand (C.GlobalReference ty name)) -> (
--    ConstantOperand $ C.GlobalReference (ty { argumentTypes = argumentTypes ty ++ forTys })
--      name)

correctReferenceVarMap2 :: VariableMap -> CallableMap -> Id -> [Id] -> CallableMap
correctReferenceVarMap2 varMap2 calMap2 id forIds = 
  --case idString id == "print3" of
  --  True -> error $ show forIds
  --  _    -> 
  let forTys = getAdditionalReferenceTypes varMap2 forIds in
  adjust (\(cal,op,b) -> (cal,f forTys op,b)) id calMap2

correctReference' :: Id -> [T.Type] -> Sems ()
correctReference' id forTys = do
  modify2ndCallableMap id $ f forTys

f forTys (ConstantOperand (C.GlobalReference (T.PointerType ty pas) name)) = 
    ConstantOperand $ C.GlobalReference (
      T.ptr $ ty { argumentTypes = argumentTypes ty ++ forTys }) name

getAdditionalReferenceType :: VariableMap -> Id -> T.Type
getAdditionalReferenceType varMap2 forId = case lookup (forId,ToPass) varMap2 of
  Just (ty,_) -> toTType $ Pointer ty
  Nothing   -> case lookup (forId,ToUse) varMap2 of
    Just (ty,_) -> toTType $ Pointer ty 
    Nothing   -> case lookup (forId,Mine) varMap2 of
      Just (ty,_) -> toTType $ Pointer ty 
      Nothing   -> error $ "Should have found: " ++ idString forId ++ " varMap2: \n" ++
                        show varMap2 

localSemsIR2 :: Local -> Sems ()
localSemsIR2 = \case
  VarsWithTypeList vwtl -> return () -- addIdsToForwardMap vwtl 
  Labels ls             -> return ()
  HeaderBody h b        -> do --2nd parse -> do the definition
    let id = idFromHeader h
              -- Table passed from 1st parse -> only the variables I need
    (toUseIds,parToPassIds,_,SymbolTable varMap labMap calMap _ _ _ _:smsf) <- getFatherMap >>=
      lookup id >>> \case
        Just fatherStuff -> return fatherStuff
        Nothing          -> error "Shouldn't happen"
       -- Table in the 2nd parse -> all the father variables
    (e,SymbolTable varMap2 lm calMap2 fathMap forIds varNumMap varIds:sms,m,cgen,i) <- get
    let calMap' = insToCalMapForwardCals calMap $ getForwardCals calMap2 $ map fst forIds
    let st = SymbolTable varMap labMap calMap' fathMap [] varNumMap varIds
    put $ (e,emptySymbolTable:st:smsf,m,cgen,i+1)
    myVarNum <- lookupIn2ndVarNumMap id >>= \case
      Nothing -> error $ "Sould have found in varNumMap myVarNum: " ++ idString id
      Just mvn -> return mvn
    (_,toPassIds) <- calcToPassIds myVarNum
    --error $ show (map idString toUseIds,map idString parIds)
    let toPassIds' = toPassIds ++ parToPassIds
    insForIdsTo2ndVarMap varMap2 toPassIds
    case elem (id,True) forIds of
      True -> return ()
      _    -> correctReference varMap2 id toPassIds'
    let calMap2' = case elem (id,True) forIds of
          True -> calMap2
          _    -> correctReferenceVarMap2 varMap2 calMap2 id toPassIds'
    let codegen = do
                    entry <- addBlock "entry"
                    setBlock entry
                    headerChildSems (length toUseIds + length toPassIds') h
                    functionBodySemsIR b
    case h of
      ProcHeader id fs   ->
        defineFun toUseIds toPassIds' (idString id) T.void (reverse fs) codegen 
      FuncHeader id fs t ->
        defineFun toUseIds toPassIds' (idString id) (toTType t) (reverse fs) codegen
    --varNumMap <- error $ show varNumMap
    (_,_,m',_,_) <- get
    put (e,SymbolTable varMap2 lm calMap2' fathMap forIds varNumMap varIds:sms,m',cgen,i)
    insToForwardIds (idFromHeader h) False
  Forward h             -> do
    let id = idFromHeader h
    varMap <- getVariableMap
    myVarNum <- lookupInVarNumMap id >>= \case
      Nothing  -> error $ "Sould have found in varNumMap myVarNum: " ++ idString id
      Just mvn -> return mvn
    (_,toPassIds) <- calcToPassIdsForward myVarNum
    --error $ show myVarNum
    (_,parToPassIds,_,_) <- getFatherMap >>= lookup id >>> \case
      Just fatherStuff -> return fatherStuff
      Nothing          -> error "Shouldn't happen"
    let toPassIds' = toPassIds ++ parToPassIds
    correctReferenceForward varMap id toPassIds'
    insToForwardIds id True

functionBodySemsIR :: Body -> Sems ()
functionBodySemsIR b = do
  bodySemsIR b
  checkResult
  returnIR

getVarIdsNeeded :: VariableMap -> ([Id],[Id])
getVarIdsNeeded = partitionIds . map fst . toList

partitionIds :: [(Id,VarType)] -> ([Id],[Id])
partitionIds = (\(idvts1,idvts2) -> (map fst idvts1,map fst idvts2)) . partitionIdVTs

partitionIdVTs :: [(Id,VarType)] -> ([(Id,VarType)],[(Id,VarType)])
partitionIdVTs = partition partitionf

partitionf :: (Id,VarType) -> Bool
partitionf (id,vt) = case vt of
   ToPass -> False
   _      -> True
--Header -> 
--filter (not . flip elem (toHIds h)) $
--toHIds :: Header -> [Id]
--toHIds = \case
--  ProcHeader _ fs   -> toFrmlIds fs
--  FuncHeader _ fs _ -> toFrmlIds fs
--
--toFrmlIds :: [Frml] -> [Id]
--toFrmlIds = concat . map (\(_,ids,_) -> ids)

headerBodySemsIR :: Header -> Body -> Sems ()
headerBodySemsIR h b = do
  (parToUseIds,parToPassIds) <- getVariableMap >>= getVarIdsNeeded >>> return
  --(_,toUseIds) <- getVarIds
  headerParentSems parToUseIds h
  --case idString (idFromHeader h) == "print3" of
  --  True -> error $ show (map idString parIds,map idString $ reverse toUseIds)
  --  _    -> return ()
  --modifyForwardMap (delete $ idFromHeader h)
  (_,sms,_,_,i) <- get
  case h of
    ProcHeader id _   -> insToFatherMap id (parToUseIds,parToPassIds,i+1,sms) 
    FuncHeader id _ _ -> insToFatherMap id (parToUseIds,parToPassIds,i+1,sms)

stmtsSemsIR :: [Stmt] -> Sems ()
stmtsSemsIR ss = mapM_ stmtSemsIR ss

stmtSemsIR :: Stmt -> Sems ()
stmtSemsIR = \case
  Empty                      -> return ()
  Assignment posn lVal expr  -> assignmentSemsIR posn lVal expr
  Block stmts                -> stmtsSemsIR $ reverse stmts
  CallS (id,exprs)           -> callStmtSemsIR id $ reverse exprs
  IfThen posn e s            -> ifThenSemsIR posn e s
  IfThenElse posn e s1 s2    -> ifThenElseSemsIR posn e s1 s2
  While posn e stmt          -> whileSemsIR posn e stmt
  Label id stmt              -> labelSemsIR id stmt
  GoTo id                    -> gotoSemsIR id
  Return                     -> returnIR  >> returnIRNext
  New posn new lVal          -> newSemsIR posn new lVal
  Dispose posn disptype lVal -> disposeSemsIR posn disptype lVal

assignmentSemsIR :: (Int,Int) -> LVal -> Expr -> Sems ()
assignmentSemsIR posn = \case
  StrLiteral str -> \_ -> errPos posn $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypeOpers lVal >=> assignmentSemsIR' posn

lValExprTypeOpers lVal expr = do
  lto <- lValTypeOper lVal 
  eto <- exprTypeOper expr
  return (lto,eto)

callStmtSemsIR :: Id -> [Expr] -> Sems ()
callStmtSemsIR id exprs = searchCallableInSymTabs id >>= \case
  (ProcDclr fs,_,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs 
  (Proc     fs,_,_) -> mapM exprTypeOperBool exprs >>= callStmtSemsIR' id fs
  _               -> errAtId "Use of function in call statement: " id

ifThenSemsIR :: (Int,Int) -> Expr -> Stmt -> Sems ()
ifThenSemsIR posn e s = do
  cond <- boolCases posn "if-then" =<< exprTypeOper e

  ifthen <- addBlock "if.then"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifexit

  setBlock ifthen
  stmtSemsIR s
  br ifexit              

  setBlock ifexit

ifThenElseSemsIR :: (Int,Int) -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseSemsIR posn e s1 s2 = do
  cond <- boolCases posn "if-then-else" =<< exprTypeOper e

  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cbr cond ifthen ifelse

  setBlock ifthen
  stmtSemsIR s1
  br ifexit     

  setBlock ifelse
  stmtSemsIR s2
  br ifexit     

  setBlock ifexit

whileSemsIR :: (Int,Int) -> Expr -> Stmt -> Sems ()
whileSemsIR posn expr stmt = do
  while     <- addBlock "while"
  whileExit <- addBlock "while.exit"

  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock while
  stmtSemsIR stmt          
  cond <- exprTypeOper expr >>= boolCases posn "while"
  cbr cond while whileExit

  setBlock whileExit

labelSemsIR :: Id -> Stmt -> Sems ()
labelSemsIR id stmt = do
  bool <- lookupInLabelMap id
  labelCases id bool
  label <- addBlock $ idString id
  br label 
  
  setBlock label
  stmtSemsIR stmt

gotoSemsIR :: Id -> Sems ()
gotoSemsIR id = do
  bool <- lookupInLabelMap id 
  goToCases id bool
  br $ toName $ idString id
  i <- fresh
  nextBlock <- addBlock $ "next" ++ show i
  setBlock nextBlock

newSemsIR :: (Int,Int) -> New -> LVal -> Sems ()
newSemsIR posn = \case
  NewNoExpr -> lValTypeOper >=> newNoExprSemsIR posn
  NewExpr e -> exprLValTypeOpers e >=> newExprSemsIR posn

exprLValTypeOpers expr lVal = do
  eto <- exprTypeOper expr
  lto <- lValTypeOper lVal
  return (eto,lto)

disposeSemsIR :: (Int,Int) -> DispType -> LVal -> Sems ()
disposeSemsIR posn = \case
  Without -> lValTypeOper >=> dispWithoutSems posn
  With    -> lValTypeOper >=> dispWithSems posn

toTyOper :: TyOperBool -> Sems TyOper
toTyOper = \case
  (ty,op,True)  -> load op >>= \op' -> return (ty,op')
  (ty,op,False) -> return (ty,op)

exprTypeOper :: Expr -> Sems TyOper
exprTypeOper = exprTypeOperBool >=> toTyOper

exprTypeOperBool :: Expr -> Sems TyOperBool
exprTypeOperBool = \case
  LVal lval -> lValTypeOper lval >>= \(ty,op) -> return (ty,op,True)
  RVal rval -> rValTypeOper rval >>= \(ty,op) -> return (ty,op,False)

lValTypeOper :: LVal -> Sems (Type,Operand)
lValTypeOper = \case
  IdL         id             -> getVariableMap >>= lookUpChildThenParentVars id >>> \case
                                  Just tyop -> return tyop
                                  Nothing   -> errAtId "Undeclared variable: " id 
  Result      posn           -> resultTypeOper posn
  StrLiteral  str            -> strLiteralSemsIR str
  Indexing    posn lVal expr -> lValExprTypeOpers lVal expr >>= indexingCases posn
  Dereference posn expr      -> exprTypeOper expr >>= dereferenceCases posn
  ParenL      lVal           -> lValTypeOper lVal

strLiteralSemsIR :: String -> Sems TyOper
strLiteralSemsIR string = do
  let n = length string + 1
  let t = Array (Size n) CharT
  strOper <- alloca $ toTType t
  mapM_ (cgenStrLitChar strOper) $ indexed $ string ++ ['\0']
  return (t,strOper)

cgenStrLitChar :: Operand -> (Int,Char) -> Sems ()
cgenStrLitChar strOper (ind,char) = do
  charPtr <- getElemPtrInt strOper ind
  store charPtr $ cons $ C.Int 8 $ toInteger $ ord char

rValTypeOper :: RVal -> Sems (Type,Operand)
rValTypeOper = \case
  IntR    int        -> right (IntT,cons $ C.Int 16 $ toInteger int)
  TrueR              -> right (BoolT,cons $ C.Int 1 1)
  FalseR             -> right (BoolT,cons $ C.Int 1 0)
  RealR   (w16,w64)  -> right (RealT,cons $ C.Float $ F.X86_FP80 w16 w64) 
  CharR   char       -> right (CharT,cons $ C.Int 8 $ toInteger $ ord char)
  ParenR  rVal       -> rValTypeOper rVal
  NilR               -> right (Nil,cons $ C.Int 1 0)
  CallR   (id,exprs) -> callRValueSemsIR id $ reverse exprs
  Papaki  lVal       -> lValTypeOper lVal >>= \(ty,op) -> right (Pointer ty,op)
  Not     posn expr  -> exprTypeOper expr >>= notCases posn
  Pos     posn expr  -> exprTypeOper expr >>= unaryOpNumCases posn "'+'"
  Neg     posn expr  -> exprTypeOper expr >>= unaryOpNumCases posn "'-'"
  Plus    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'+'"
  Mul     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'*'"
  Minus   posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn IntT RealT "'-'"
  RealDiv posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn RealT RealT "'/'"
  Div     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpIntCases posn "'div'"
  Mod     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpIntCases posn "'mod'"
  Or      posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpBoolCases posn "'or'"
  And     posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpBoolCases posn "'and'"
  Eq      posn e1 e2 -> exprsTypeOpers e1 e2 >>= comparisonCases posn "'='"
  Diff    posn e1 e2 -> exprsTypeOpers e1 e2 >>= comparisonCases posn "'<>'"
  Less    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'<'"
  Greater posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'>'"
  Greq    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'>='"
  Smeq    posn e1 e2 -> exprsTypeOpers e1 e2 >>= binOpNumCases posn BoolT BoolT "'<='"

exprsTypeOpers exp1 exp2 = mapM exprTypeOper [exp1,exp2]

callRValueSemsIR :: Id -> [Expr] -> Sems (Type,Operand)
callRValueSemsIR id exprs = searchCallableInSymTabs id >>= \case
  (FuncDclr fs t,_,_) -> mapM exprTypeOperBool exprs >>= callRValueSemsIR' id fs t 
  (Func  fs t   ,_,_) -> mapM exprTypeOperBool exprs >>= callRValueSemsIR' id fs t
  _                   -> errAtId "Use of procedure where a return value is required: " id

