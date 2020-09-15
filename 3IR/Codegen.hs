{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Codegen where

import Data.Word
import Data.String
import Data.List
import Data.Function
import Data.String.Transform
import qualified Data.Map as Map

import Control.Monad.State
import Control.Applicative

import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
import qualified LLVM.AST as AST

import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Attribute as A
import qualified LLVM.AST.CallingConvention as CC
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.IntegerPredicate as I
import LLVM.AST.AddrSpace

import Parser as P
import SemsTypes ((>>>))

type LLVM = State AST.Module

addDefn :: Definition -> LLVM ()
addDefn d = do
  defs <- gets moduleDefinitions
  modify $ \s -> s { moduleDefinitions = defs ++ [d] }

define ::  T.Type -> String -> [(T.Type, Name)] -> [BasicBlock] -> LLVM ()
define retty label argtys body = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = toShortName label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

printfDef :: LLVM ()
printfDef = addDefn $ GlobalDefinition $ functionDefaults {
    returnType = i32
  , name = Name "printf"
  , parameters = (
      [ Parameter (PointerType i8 (AddrSpace 0)) (UnName 0) [] ]
    , True
    )
  } 

writeStringDef :: [BasicBlock] -> LLVM ()
writeStringDef blks = addDefn $
  GlobalDefinition $ functionDefaults {
      returnType = T.void
    , name = Name "writeString"
    , parameters = (
        [ Parameter (PointerType i8 (AddrSpace 0)) (UnName 0) [] ]
      , True
      )
    , basicBlocks = blks
    } 

writeRealDef :: [BasicBlock] -> LLVM ()
writeRealDef blks = do
  addDefn $ GlobalDefinition $ globalVariableDefaults {
      name = Name ".str"
    , linkage = L.Private
    , unnamedAddr = Just GlobalAddr
    , isConstant = True
    , LLVM.AST.Global.type' = ArrayType 4 i8 
    , LLVM.AST.Global.alignment = 1
    , initializer = Just $ C.Array i8 [C.Int 8 37, C.Int 8 102,C.Int 8 10, C.Int 8 0]
    }
  addDefn $ GlobalDefinition $ functionDefaults {
      returnType = T.void
    , name = Name "writeReal"
    , parameters = (
        [ Parameter double (UnName 0) [] ]
      , False
      )
    , basicBlocks = blks
    } 

type Names = Map.Map String Int

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)

type SymbolTable = [(String, Operand)]

data CodegenState
  = CodegenState {
    currentBlock :: Name                     
  , blocks       :: Map.Map Name BlockState  
  , symtab       :: SymbolTable              
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

newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
  deriving (Functor, Applicative, Monad, MonadState CodegenState )

sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
sortBlocks = sortBy (compare `on` (idx . snd))

createBlocks :: CodegenState -> [BasicBlock]
createBlocks m = map makeBlock $ sortBlocks $ Map.toList (blocks m)

makeBlock :: (Name, BlockState) -> BasicBlock
makeBlock (l, (BlockState _ s t)) = BasicBlock l (reverse s) (maketerm t)
  where
    maketerm (Just x) = x
    maketerm Nothing = error $ "Block has no terminator: " ++ (show l)

entryBlockName :: String
entryBlockName = "entry"

emptyBlock :: Int -> BlockState
emptyBlock i = BlockState i [] Nothing

emptyCodegen :: CodegenState
emptyCodegen = CodegenState (toShortName entryBlockName) Map.empty [] 1 0 Map.empty

execCodegen :: Codegen a -> CodegenState
execCodegen m = execState (runCodegen m) emptyCodegen

fresh :: Codegen Word
fresh = do
  i <- gets count
  modify $ \s -> s { count = 1 + i }
  return $ i + 1

instr :: Instruction -> Codegen (Operand)
instr ins = do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (ref := ins) : i } )
  return $ local ref

instrDo :: Instruction -> Codegen ()
instrDo ins = do
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (Do ins) : i } )

terminator :: Named Terminator -> Codegen (Named Terminator)
terminator trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })
  return trm

terminatorVoid :: Named Terminator -> Codegen ()
terminatorVoid trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })

entry :: Codegen Name
entry = gets currentBlock

addBlock :: String -> Codegen Name
addBlock bname = do
  bls <- gets blocks
  ix  <- gets blockCount
  nms <- gets names
  let new = emptyBlock ix
      (qname, supply) = uniqueName bname nms
  modify $ \s -> s { blocks = Map.insert (toShortName qname) new bls
                   , blockCount = ix + 1
                   , names = supply
                   }
  return (toShortName qname)

toShortName = toShortByteString >>> Name

setBlock :: Name -> Codegen Name
setBlock bname = do
  modify $ \s -> s { currentBlock = bname }
  return bname

getBlock :: Codegen Name
getBlock = gets currentBlock

modifyBlock :: BlockState -> Codegen ()
modifyBlock new = do
  active <- gets currentBlock
  modify $ \s -> s { blocks = Map.insert active new (blocks s) }

current :: Codegen BlockState
current = do
  c <- gets currentBlock
  blks <- gets blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c

assign :: String -> Operand -> Codegen ()
assign var x = do
  lcls <- gets symtab
  modify $ \s -> s { symtab = [(var, x)] ++ lcls }

getvar :: String -> Codegen Operand
getvar var = do
  syms <- gets symtab
  case lookup var syms of
    Just x  -> return x
    Nothing -> error $ "Local variable not in scope: " ++ show var

local ::  Name -> Operand
local = LocalReference double

global ::  Name -> C.Constant
global = C.GlobalReference double

printf :: Name -> Operand
printf = ConstantOperand . C.GlobalReference printfType

writeReal :: Name -> Operand
writeReal = ConstantOperand . C.GlobalReference writeRealType

writeString :: Name -> Operand
writeString = ConstantOperand . C.GlobalReference writeStringType

printfType =
  PointerType {
    pointerReferent = FunctionType {
      resultType = IntegerType {typeBits = 32}
    , argumentTypes = [
        PointerType {
          pointerReferent = IntegerType {typeBits = 8}
        , pointerAddrSpace = AddrSpace 0}
      ]
    , isVarArg = True}
  , pointerAddrSpace = AddrSpace 0}

writeStringType =
  PointerType {
    pointerReferent = FunctionType {
      resultType = T.void
    , argumentTypes = [
        PointerType {
          pointerReferent = IntegerType {typeBits = 8}
        , pointerAddrSpace = AddrSpace 0}
      ]
    , isVarArg = True}
  , pointerAddrSpace = AddrSpace 0}

writeRealType =
  PointerType {
    pointerReferent = FunctionType {
      resultType = T.void
    , argumentTypes = [double]
    , isVarArg = False}
  , pointerAddrSpace = AddrSpace 0}

fadd :: Operand -> Operand -> Codegen Operand
fadd a b = instr $ FAdd noFastMathFlags a b []

add :: Operand -> Operand -> Codegen Operand
add a b = instr $ Add False False a b []

fsub :: Operand -> Operand -> Codegen Operand
fsub a b = instr $ FSub noFastMathFlags a b []

fmul :: Operand -> Operand -> Codegen Operand
fmul a b = instr $ FMul noFastMathFlags a b []

fdiv :: Operand -> Operand -> Codegen Operand
fdiv a b = instr $ FDiv noFastMathFlags a b []

sdiv :: Operand -> Operand -> Codegen Operand
sdiv a b = instr $ SDiv False a b []

srem :: Operand -> Operand -> Codegen Operand
srem a b = instr $ SRem a b []

orInstr :: Operand -> Operand -> Codegen Operand
orInstr a b = instr $ AST.Or a b []

andInstr :: Operand -> Operand -> Codegen Operand
andInstr a b = instr $ AST.And a b []

fcmp :: FP.FloatingPointPredicate -> Operand -> Operand -> Codegen Operand
fcmp cond a b = instr $ FCmp cond a b []

icmp :: I.IntegerPredicate -> Operand -> Operand -> Codegen Operand
icmp cond a b = instr $ ICmp cond a b []

phi :: AST.Type -> [(Operand, Name)] -> Codegen ()
phi ty incoming = instrDo $ Phi ty incoming []

cons :: C.Constant -> Operand
cons = ConstantOperand

uitofp :: T.Type -> Operand -> Codegen Operand
uitofp ty a = instr $ UIToFP a ty []

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))

call :: Operand -> [Operand] -> Codegen Operand
call fn args = instr $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

callVoid :: Operand -> [Operand] -> Codegen ()
callVoid fn args = instrDo $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

alloca :: T.Type -> Codegen Operand
alloca ty = instr $ Alloca ty Nothing 0 []

allocaNum :: Operand -> T.Type -> Codegen Operand
allocaNum oper ty = instr $ Alloca ty (Just oper) 0 []

store :: Operand -> Operand -> Codegen ()
store ptr val = instrDo $ Store False ptr val Nothing 0 []

load :: Operand -> Codegen Operand
load ptr = instr $ Load False ptr Nothing 0 []

getElemPtr :: Operand -> Operand -> Codegen Operand
getElemPtr arrPtr ind =
  instr $ GetElementPtr False arrPtr [cons $ C.Int 16 $ toInteger 0,ind] []

getElemPtrInBounds :: Operand -> Operand -> Codegen Operand
getElemPtrInBounds arrPtr ind =
  instr $ GetElementPtr True arrPtr [cons $ C.Int 16 $ toInteger 0,ind] []

getElemPtr' :: Operand -> Operand -> Codegen Operand
getElemPtr' arrPtr ind =
  instr $ GetElementPtr False arrPtr [ind] []

br :: Name -> Codegen (Named Terminator)
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Codegen (Named Terminator)
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

ret :: Operand -> Codegen (Named Terminator)
ret val = terminator $ Do $ Ret (Just val) []

retVoid :: Codegen ()
retVoid = terminatorVoid $ Do $ Ret Nothing []
