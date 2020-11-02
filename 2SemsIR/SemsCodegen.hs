module SemsCodegen where

import Prelude hiding (lookup)
import Data.List (sortBy)
import Data.Function (on)
import LLVM.AST (Operand(..),Name(..),Instruction(..),Named(..),Terminator(..)
                ,noFastMathFlags)
import LLVM.AST.Global (Parameter(..),BasicBlock(..),parameters,basicBlocks,returnType
                       ,name,functionDefaults)
import LLVM.AST.Attribute (ParameterAttribute)
import LLVM.AST.FloatingPointPredicate (FloatingPointPredicate)
import LLVM.AST.IntegerPredicate (IntegerPredicate)
import SemsIRTypes (Sems,blocks,BlockState(..),currentBlock,Names,names,count,VarType(..)
                   ,blockCount,toConsI16,getFromCodegen,modifyCodegen,toShortName,toTType
                   ,(>>>),addGlobalDef,emptyCodegen,consGlobalRef,toName,variableMap
                   ,get2ndVarMap,parIdsToParTys,setCount,getCount,getSymTabs,getVariableMap
                   ,lookupIn2ndVarNumMap,get2ndVarIds,VariableMap,searchCallableInSymTabs)
import Data.List.Index (indexed)
import Data.Map (lookup,toList)
import Data.String.Transform (toShortByteString)
import Parser as P (Id(..),Frml,PassBy(..),ArrSize(..),Type(..))
import LLVM.AST.Type as T (Type(..),void,x86_fp80,i1,i8,i16,i32,i64,ptr)
import Control.Monad.State (modify)
import qualified Data.Map as Map (toList,lookup,insert)
import qualified LLVM.AST.CallingConvention as CC (CallingConvention(..))
import qualified LLVM.AST.Constant as C (Constant(..))

type InsType = Id -> T.Type -> P.Type -> Int -> Sems ()

insVarsInMap :: InsType -> [Id] -> [(Int,(P.Type,T.Type))] -> Sems ()
insVarsInMap insf parIds parTys = mapM_ (insVarInMap insf) $ zip parIds parTys

insVarInMap :: InsType -> (Id,(Int,(P.Type,T.Type))) -> Sems ()
insVarInMap insf (id,(n,(pt,tt))) = insf id tt pt n

forIdsToForTys :: VariableMap -> [Id] -> [(P.Type,T.Type)]
forIdsToForTys parVM = map (forIdsToForTy parVM) 
  
forIdsToForTy :: VariableMap -> Id -> (P.Type,T.Type)
forIdsToForTy parVM fid = case lookup (fid,ToPass) parVM of
  Just (ty,_) -> (ty,toTType $ Pointer ty)
  Nothing     -> error $ "Should have found: " ++ idString fid ++ " map: \n" ++
                    show parVM

-- Add function definition to Module in state
defineFun :: [Id] -> [Id] -> String -> T.Type -> [Frml] -> Sems () -> Sems ()
defineFun parIds forIds name retty frmls codegen = do
  tys <- case length parIds + length forIds == 0 of --
    True -> return []
    _    -> do
      parVM <-get2ndVarMap --
      let n = sum $ map (\(_,ids,_) -> length ids) frmls
      let parTys = map (\(x,a) -> (x+n,a) ) $ indexed $ parIdsToParTys parVM parIds --
      insVarsInMap insToVariableMapPar parIds parTys
      let n' = length parTys
      let parTys' = map (\(_,(_,t)) -> t) parTys
      --case name == "strlen" of
      --  True -> error $ show (map idString forIds) -- ++ "\n" ++ show parVM
      --  _    -> return ()
      --case name == "ok2" of
      --  True -> getVariableMap >>= error . show 
      --  _    -> return ()
      --let diff = maxVarNum - myVarNum
      let forTys = map (\(x,a) -> (x+n+n',a) ) $ indexed $ forIdsToForTys parVM forIds --
      --error $ show $ forTys
      insVarsInMap insToVariableMapFor forIds forTys
      let forTys' = map (\(_,(_,t)) -> t) forTys
      --error $ show $ forTys
      --(cal,op) <- searchCallableInSymTabs $ dummy name
      --error $ show ref
      return $ parTys' ++ forTys'
  modifyCodegen $ \_ -> emptyCodegen -- flush previous codegen state
  codegen                            -- modify codegen state 
  blocks <- createBlocks             -- create blocks based on the new codegen state
  --case name == "ok3" of
  --  True -> getVariableMap >>=
  --            error . show . map (\(x,y) -> (idString x,y)). map fst . toList
  --  _    -> return ()
  addGlobalDef functionDefaults {
      returnType = retty
    , name = toName name
    , parameters =  (
        map tyToParam $ indexed $ (concat $ map frmlToTys frmls) ++ tys -- ++ forTys'
      , False
      )
    , basicBlocks = blocks
    } 

-- Create Basic Blocks from Codegen State
createBlocks :: Sems [BasicBlock]
createBlocks = do
  codegenState <- getFromCodegen id
  return $ map makeBlock $ sortBlocks $ Map.toList $ blocks codegenState

sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
sortBlocks = sortBy (compare `on` (idx . snd))

makeBlock :: (Name, BlockState) -> BasicBlock
makeBlock (l, (BlockState _ s t)) = BasicBlock l (reverse s) (maketerm t)
  where
    maketerm (Just x) = x
    maketerm Nothing = error $ "Block has no terminator: " ++ (show l)

-- Create Parameter from Formal
frmlToTys :: Frml -> [T.Type]
frmlToTys (by,ids,ty) = replicate (length ids) $ case by of
  Val -> toTType ty 
  _   -> toTType $ Pointer ty

tyToParam :: (Int,T.Type) -> Parameter
tyToParam (i,ty) = Parameter ty (UnName $ fromIntegral i) []

-- fresh number for Unnamed Operands
fresh :: Sems Word
fresh = do
  i <- getFromCodegen count
  modifyCodegen $ \s -> s { count = 1 + i }
  return $ i + 1

-- add instruction to block, with or without a local reference
instr :: T.Type -> Instruction -> Sems Operand
instr retty ins =  do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (ref := ins) : i } )
  return $ LocalReference retty ref

instrDo :: Instruction -> Sems ()
instrDo ins = do
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (Do ins) : i } )

-- Add terminator to block
terminator :: Named Terminator -> Sems ()
terminator trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })

-- Add Block to codegen state
addBlock :: String -> Sems Name
addBlock bname = do
  bls <- getFromCodegen blocks
  ix  <- getFromCodegen blockCount
  nms <- getFromCodegen names
  let new = emptyBlock ix
      (qname, supply) = uniqueName bname nms
  modifyCodegen $ \s -> s { blocks = Map.insert (toShortName qname) new bls
                          , blockCount = ix + 1
                          , names = supply
                          }
  return (toShortName qname)

emptyBlock :: Int -> BlockState
emptyBlock i = BlockState i [] Nothing

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)

-- Other Block operations
setBlock :: Name -> Sems ()
setBlock bname = modifyCodegen $ \s -> s { currentBlock = bname }

getBlock :: Sems Name
getBlock = getFromCodegen currentBlock

modifyBlock :: BlockState -> Sems ()
modifyBlock new = do
  active <- getFromCodegen currentBlock
  modifyCodegen $ \s -> s { blocks = Map.insert active new (blocks s) }

current :: Sems BlockState
current = do
  c <- getFromCodegen currentBlock
  blks <- getFromCodegen blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c

-- Constant Global References
printf :: Operand
printf = consGlobalRef printfScanfType "printf"

scanf :: Operand
scanf = consGlobalRef printfScanfType "__isoc99_scanf"

printfScanfType = ptr $ FunctionType {
    resultType = i32
  , argumentTypes = [ptr i8]
  , isVarArg = True
  }

malloc :: Operand
malloc = consGlobalRef mallocType "malloc"

mallocType = ptr $ FunctionType {
    resultType = ptr i8
  , argumentTypes = [i64]
  , isVarArg = False
  }

free :: Operand
free = consGlobalRef freeType "free"

freeType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [ptr i8]
  , isVarArg = False
  }

[acosl,atanl,logl] = map (consGlobalRef mathType) ["acosl","atanl","logl"]

[fabsl,sqrtl,sinl,cosl,tanl,expl] = map (consGlobalRef mathType)
  ["fabsl","sqrtl","sinl","cosl","tanl","expl"] 


mathType = ptr $ FunctionType {
    resultType = x86_fp80
  , argumentTypes = [x86_fp80]
  , isVarArg = False
  }

strcmp :: Operand
strcmp = consGlobalRef strcmpType "strcmp"

strcmpType = ptr $ FunctionType {
    resultType = i32
  , argumentTypes = [ptr i8,ptr i8]
  , isVarArg = False
  }

-- Instructions
fadd :: Operand -> Operand -> Sems Operand
fadd a b = instr x86_fp80 $ FAdd noFastMathFlags a b []

add :: Operand -> Operand -> Sems Operand
add a b = instr i16 $ Add False False a b []

fsub :: Operand -> Operand -> Sems Operand
fsub a b = instr x86_fp80 $ FSub noFastMathFlags a b []

sub :: Operand -> Operand -> Sems Operand
sub a b = instr i16 $ Sub False False a b []

fmul :: Operand -> Operand -> Sems Operand
fmul a b = instr x86_fp80 $ FMul noFastMathFlags a b []

mul :: Operand -> Operand -> Sems Operand
mul a b = instr i16 $ LLVM.AST.Mul False False a b []

fdiv :: Operand -> Operand -> Sems Operand
fdiv a b = instr x86_fp80 $ FDiv noFastMathFlags a b []

sdiv :: Operand -> Operand -> Sems Operand
sdiv a b = instr i16 $ SDiv False a b []

srem :: Operand -> Operand -> Sems Operand
srem a b = instr i16 $ SRem a b []

orInstr :: Operand -> Operand -> Sems Operand
orInstr a b = instr i1 $ LLVM.AST.Or a b []

andInstr :: Operand -> Operand -> Sems Operand
andInstr a b = instr i1 $ LLVM.AST.And a b []

fcmp :: FloatingPointPredicate -> Operand -> Operand -> Sems Operand
fcmp cond a b = instr i1 $ FCmp cond a b []

icmp :: IntegerPredicate -> Operand -> Operand -> Sems Operand
icmp cond a b = instr i1 $ ICmp cond a b []

phi :: T.Type -> [(Operand, Name)] -> Sems Operand
phi ty incoming = instr ty $ Phi ty incoming []

sitofp :: Operand -> Sems Operand
sitofp a = instr x86_fp80 $ SIToFP a x86_fp80 []

fptosi :: Operand -> Sems Operand
fptosi a = instr i16 $ FPToSI a i16 []

call :: Operand -> [Operand] -> Sems Operand
call fn args = case fn of
  ConstantOperand (C.GlobalReference ty _) ->
    instr (resultType ty) $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []
  _ -> undefined


callVoid :: Operand -> [Operand] -> Sems ()
callVoid fn args = instrDo $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

toArgs :: [Operand] -> [(Operand, [ParameterAttribute])]
toArgs = map (\x -> (x, []))

alloca :: T.Type -> Sems Operand
alloca ty = instr (ptr ty) $ Alloca ty Nothing 0 []

allocaNum :: Operand -> T.Type -> Sems Operand
allocaNum oper ty = instr (ptr ty) $ Alloca ty (Just oper) 0 []

store :: Operand -> Operand -> Sems ()
store ptr val = instrDo $ Store False ptr val Nothing 0 []

load :: Operand -> Sems Operand
load ptr = instr (ptrToRetty ptr) $ Load False ptr Nothing 0 []

zext :: Operand -> Sems Operand
zext op = instr i16 $ ZExt op i16 []

fpext :: Operand -> Sems Operand
fpext op = instr x86_fp80 $ FPExt op x86_fp80 []

zext64 :: Operand -> Sems Operand
zext64 op = instr i64 $ ZExt op i64 []

truncTo :: Operand -> Sems Operand
truncTo op = instr i8 $ Trunc op i8 []

bitcast :: Operand -> T.Type -> Sems Operand
bitcast op ty = instr (ptr ty) $ BitCast op (ptr ty) []

ptrToRetty :: Operand -> T.Type
ptrToRetty = \case
  LocalReference (PointerType t _) _ -> t
  ConstantOperand (C.GlobalReference (PointerType t _) _) -> t
  t -> error $ "Not a pointer: " ++ show t
  
getElemPtr :: Operand -> Operand -> Sems Operand
getElemPtr arrPtr ind =
  instr x86_fp80 $ GetElementPtr False arrPtr [toConsI16 0,ind] []

getElemPtrInt :: Operand -> Int -> Sems Operand
getElemPtrInt arrPtr ind =
  instr x86_fp80 $ GetElementPtr False arrPtr [toConsI16 0,toConsI16 ind] []

getElemPtrInBounds :: Operand -> Int -> Sems Operand
getElemPtrInBounds arrPtr ind =
  instr x86_fp80 $ GetElementPtr True arrPtr [toConsI16 0,toConsI16 ind] []

getElemPtrInBounds' :: Operand -> Operand -> Sems Operand
getElemPtrInBounds' arrPtr ind =
  instr x86_fp80 $ GetElementPtr True arrPtr [toConsI16 0,ind] []

getElemPtr' :: Operand -> Int -> Sems Operand
getElemPtr' arrPtr ind =
  instr x86_fp80 $ GetElementPtr False arrPtr [toConsI16 ind] []

getElemPtrOp' :: Operand -> Operand -> Sems Operand
getElemPtrOp' arrPtr ind =
  instr x86_fp80 $ GetElementPtr False arrPtr [ind] []

-- Terminators
br :: Name -> Sems ()
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Sems ()
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

ret :: Operand -> Sems ()
ret val = terminator $ Do $ Ret (Just val) []

retVoid :: Sems ()
retVoid = terminator $ Do $ Ret Nothing []

cons :: C.Constant -> Operand
cons = ConstantOperand

insToVariableMap :: Id -> P.Type -> Sems ()
insToVariableMap id ty = do
  var <- alloca $ toTType ty
  modify $ \(e,st:sts,m,cgen,i) ->
    (e,st { variableMap = Map.insert (id,Mine) (ty,var) $ variableMap st }:sts,m,cgen,i)

insToVariableMapFormalVal :: Id -> P.Type -> Int -> Sems ()
insToVariableMapFormalVal id ty n = do
  i <- fresh
  let tty = toTType ty
  let refI = LocalReference tty (UnName (i-1))
  let nameN = (UnName (i+fromIntegral (n-1)))
  blk <- current
  modifyBlock (blk { stack = (nameN := Alloca tty Nothing 0 []) : stack blk } )
  let refN = LocalReference (ptr tty) nameN
  store refN refI
  modify $ \(e,st:sts,m,cgen,i) -> (e,st {
      variableMap = Map.insert (id,Mine) (ty,refN) $ variableMap st
    }:sts,m,cgen,i)

insToVariableMapFormalRef :: Id -> P.Type -> Int -> Sems ()
insToVariableMapFormalRef id ty n = do
  i <- fresh
  let tty = toTType ty
  let refI = LocalReference tty (UnName (i-1))
  modify $ \(e,st:sts,m,cgen,i) -> (e,st {
      variableMap = Map.insert (id,Mine) (ty,refI) $ variableMap st
    }:sts,m,cgen,i)

insToVariableMapPar :: Id -> T.Type -> P.Type -> Int -> Sems ()
insToVariableMapPar id tty ty n = do
  let refI = LocalReference tty (UnName $ fromIntegral n)
  modify $ \(e,st:sts,m,cgen,i) -> (e,st {
      variableMap = Map.insert (id,ToUse) (ty,refI) $ variableMap st
    }:sts,m,cgen,i)

insToVariableMapFor :: Id -> T.Type -> P.Type -> Int -> Sems ()
insToVariableMapFor id tty ty n = do
  let refI = LocalReference tty (UnName $ fromIntegral n)
  modify $ \(e,st:sts,m,cgen,i) -> (e,st {
      variableMap = Map.insert (id,ToPass) (ty,refI) $ variableMap st
    }:sts,m,cgen,i)

dummy :: String -> Id
dummy s = Id (0,0) s
