{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module SemsCodegen where

import Data.List
import Data.Function
import qualified Data.Map as Map
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
import LLVM.AST.FunctionAttribute 
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Attribute as A
import qualified LLVM.AST.CallingConvention as CC
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.IntegerPredicate as I
import Parser as P
import SemsTypes
import Data.List.Index
import Data.String.Transform

-- Add function definition to Module in state
defineFun :: String -> T.Type -> [Frml] -> Sems () -> Sems ()
defineFun name retty frmls codegen = do
  modifyCodegen $ \_ -> emptyCodegen -- flush previous codegen state
  codegen                            -- modify codegen state 
  blocks <- createBlocks             -- create blocks based on the new codegen state
  addGlobalDef functionDefaults {
      returnType = retty
    , name = toName $ case name of 
                        "arctan" -> "atan"
                        "ln"     -> "log"
                        _        -> name
    , parameters =  (
        fmap (frmlToTy >>> tyToParam) $ indexed frmls
      , case name of "writeString" -> True; _ -> False
      )
    , basicBlocks = blocks
    } 

toName :: String -> Name
toName = toShortByteString >>> Name

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
frmlToTy :: (Int,Frml) -> (Word,T.Type)
frmlToTy (i,(by,_,ty)) = (fromIntegral i,case by of
  Value -> toTType ty 
  _     -> case ty of
    Array NoSize _ -> toTType ty
    _              -> toTType $ Pointer ty)

tyToParam :: (Word,T.Type) -> Parameter
tyToParam (i,ty) = Parameter ty (UnName i) []

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

-- Symtab operations
assign :: String -> Operand -> Sems ()
assign var x = do
  lcls <- getFromCodegen symtab
  modifyCodegen $ \s -> s { symtab = [(var, x)] ++ lcls }

getvar :: String -> Sems Operand
getvar var = do
  syms <- getFromCodegen symtab
  case lookup var syms of
    Just x  -> return x
    Nothing -> error $ "Local variable not in scope: " ++ show var

-- Constant Global References
consGlobalRef :: T.Type -> Name -> Operand
consGlobalRef ty name = ConstantOperand $ C.GlobalReference ty name

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

writeGlobalRef :: (T.Type,Name) -> Operand
writeGlobalRef (argType,name) = consGlobalRef (writeType argType) name

writeType argType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [argType]
  , isVarArg = False
  }

[writeInteger, writeBoolean, writeChar, writeReal] =
  map writeGlobalRef [(i16,"writeInteger")
                     ,(i1,"writeBoolean")
                     ,(i8,"writeChar")
                     ,(double,"writeReal")
                     ]

writeString :: Operand
writeString = consGlobalRef writeStringType "writeString"

writeStringType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [ptr i8]
  , isVarArg = True
  }

readString :: Operand
readString = consGlobalRef readStringType "readString"

readStringType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [i16, ptr i8]
  , isVarArg = False
  }

readGlobalRef :: (T.Type,Name) -> Operand
readGlobalRef (resType,name) = consGlobalRef (readType resType) name

readType resType = ptr $ FunctionType {
    resultType = resType
  , argumentTypes = []
  , isVarArg = False
  }

[readInteger, readBoolean, readChar, readReal] =
  map readGlobalRef [(i16,"readInteger")
                     ,(i1,"readBoolean")
                     ,(i8,"readChar")
                     ,(double,"readReal")
                     ]

abs :: Operand
abs = consGlobalRef absType "abs"

absType = ptr $ FunctionType {
    resultType = i16
  , argumentTypes = [i16]
  , isVarArg = False
  }

[fabs,sqrt,sin,cos,tan,arctan,exp,ln,acos] =
  map (consGlobalRef mathType) ["fabs","sqrt","sin","cos","tan","arctan","exp","ln","acos"]

mathType = ptr $ FunctionType {
    resultType = double
  , argumentTypes = [double]
  , isVarArg = False
  }

pi :: Operand
pi = consGlobalRef piType "pi"

piType = ptr $ FunctionType {
    resultType = double
  , argumentTypes = []
  , isVarArg = False
  }

trunc :: Operand
trunc = consGlobalRef truncRoundType "trunc"

round :: Operand
round = consGlobalRef truncRoundType "round"

truncRoundType = ptr $ FunctionType {
    resultType = i16
  , argumentTypes = [double]
  , isVarArg = False
  }

ordOp :: Operand
ordOp = consGlobalRef ordType "ord"

ordType = ptr $ FunctionType {
    resultType = i16
  , argumentTypes = [i8]
  , isVarArg = False
  }

chr :: Operand
chr = consGlobalRef chrType "chr"

chrType = ptr $ FunctionType {
    resultType = i8
  , argumentTypes = [i16]
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
fadd a b = instr double $ FAdd noFastMathFlags a b []

add :: Operand -> Operand -> Sems Operand
add a b = instr i16 $ Add False False a b []

fsub :: Operand -> Operand -> Sems Operand
fsub a b = instr double $ FSub noFastMathFlags a b []

sub :: Operand -> Operand -> Sems Operand
sub a b = instr i16 $ Sub False False a b []

fmul :: Operand -> Operand -> Sems Operand
fmul a b = instr double $ FMul noFastMathFlags a b []

mul :: Operand -> Operand -> Sems Operand
mul a b = instr i16 $ LLVM.AST.Mul False False a b []

fdiv :: Operand -> Operand -> Sems Operand
fdiv a b = instr double $ FDiv noFastMathFlags a b []

sdiv :: Operand -> Operand -> Sems Operand
sdiv a b = instr i16 $ SDiv False a b []

srem :: Operand -> Operand -> Sems Operand
srem a b = instr i16 $ SRem a b []

orInstr :: Operand -> Operand -> Sems Operand
orInstr a b = instr i1 $ LLVM.AST.Or a b []

andInstr :: Operand -> Operand -> Sems Operand
andInstr a b = instr i1 $ LLVM.AST.And a b []

fcmp :: FP.FloatingPointPredicate -> Operand -> Operand -> Sems Operand
fcmp cond a b = instr i1 $ FCmp cond a b []

icmp :: I.IntegerPredicate -> Operand -> Operand -> Sems Operand
icmp cond a b = instr i1 $ ICmp cond a b []

phi :: T.Type -> [(Operand, Name)] -> Sems Operand
phi ty incoming = instr ty $ Phi ty incoming []

sitofp :: Operand -> Sems Operand
sitofp a = instr double $ SIToFP a double []

fptosi :: Operand -> Sems Operand
fptosi a = instr i16 $ FPToSI a i16 []

call :: Operand -> [Operand] -> Sems Operand
call fn args = case fn of
  ConstantOperand (C.GlobalReference ty _) ->
    instr (resultType ty) $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []
  _ -> undefined


callVoid :: Operand -> [Operand] -> Sems ()
callVoid fn args = instrDo $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
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
  instr double $ GetElementPtr False arrPtr [toConsI16 0,ind] []

getElemPtrInt :: Operand -> Int -> Sems Operand
getElemPtrInt arrPtr ind =
  instr double $ GetElementPtr False arrPtr [toConsI16 0,toConsI16 ind] []

getElemPtrInBounds :: Operand -> Int -> Sems Operand
getElemPtrInBounds arrPtr ind =
  instr double $ GetElementPtr True arrPtr [toConsI16 0,toConsI16 ind] []

getElemPtrInBounds' :: Operand -> Operand -> Sems Operand
getElemPtrInBounds' arrPtr ind =
  instr double $ GetElementPtr True arrPtr [toConsI16 0,ind] []

getElemPtr' :: Operand -> Int -> Sems Operand
getElemPtr' arrPtr ind =
  instr double $ GetElementPtr False arrPtr [toConsI16 ind] []

getElemPtrOp' :: Operand -> Operand -> Sems Operand
getElemPtrOp' arrPtr ind =
  instr double $ GetElementPtr False arrPtr [ind] []

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
