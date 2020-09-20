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

defineFun :: String -> T.Type -> [Frml] -> Sems () -> Sems ()
defineFun name retty frmls codegen = do
  modifyCodegen $ \_ -> emptyCodegen
  codegen
  blocks <- createBlocks
  addGlobalDef functionDefaults {
      returnType = retty
    , name = toName $ case name of 
                        "arctan" -> "atan"
                        "ln"     -> "log"
                        _        -> name
    , parameters =  (
        (fmap (frmlToTy >>> tyToParam) $ indexed frmls) 
      , case name of "writeString" -> True; _ -> False
      )
    , basicBlocks = blocks
    } 

tyToParam :: (Word,T.Type) -> Parameter
tyToParam (i,ty) = Parameter ty (UnName i) []

frmlToTy :: (Int,Frml) -> (Word,T.Type)
frmlToTy (i,(by,_,ty)) = (fromIntegral i,case by of
  Value -> toTType ty 
  _     -> toTType $ Pointer ty)

toName :: String -> Name
toName = toShortByteString >>> Name

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)

sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
sortBlocks = sortBy (compare `on` (idx . snd))

createBlocks :: Sems [BasicBlock]
createBlocks = do
  m <- getFromCodegen id
  return $ map makeBlock $ sortBlocks $ Map.toList (blocks m)

makeBlock :: (Name, BlockState) -> BasicBlock
makeBlock (l, (BlockState _ s t)) = BasicBlock l (reverse s) (maketerm t)
  where
    maketerm (Just x) = x
    maketerm Nothing = error $ "Block has no terminator: " ++ (show l)

emptyBlock :: Int -> BlockState
emptyBlock i = BlockState i [] Nothing

fresh :: Sems Word
fresh = do
  i <- getFromCodegen count
  modifyCodegen $ \s -> s { count = 1 + i }
  return $ i + 1

instr :: T.Type -> Instruction -> Sems Operand
instr retty ins =  do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (ref := ins) : i } )
  return $ local retty ref

instrDo :: Instruction -> Sems ()
instrDo ins = do
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (Do ins) : i } )

terminator :: Named Terminator -> Sems ()
terminator trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })

terminatorVoid :: Named Terminator -> Sems ()
terminatorVoid trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })

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

local :: T.Type -> Name -> Operand
local = LocalReference

consGlobalRef :: T.Type -> Name -> Operand
consGlobalRef ty name = ConstantOperand $ C.GlobalReference ty name

printf :: Operand
printf = consGlobalRef printfType "printf"

printfType = ptr $ FunctionType {
    resultType = i32
  , argumentTypes = [ptr i8]
  , isVarArg = True
  }

scanf :: Operand
scanf = consGlobalRef scanfType "__isoc99_scanf"

scanfType = ptr $ FunctionType {
    resultType = i32
  , argumentTypes = [ptr i8]
  , isVarArg = True
  }

writeInteger :: Operand
writeInteger = consGlobalRef writeIntegerType "writeInteger"

writeIntegerType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [i16]
  , isVarArg = False
  }
  
writeBoolean :: Operand
writeBoolean = consGlobalRef writeBooleanType "writeBoolean"

writeBooleanType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [i1]
  , isVarArg = False
  }
  
writeChar :: Operand
writeChar = consGlobalRef writeCharType "writeChar"

writeCharType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [i8]
  , isVarArg = False
  }
  
writeReal :: Operand
writeReal = consGlobalRef writeRealType "writeReal"

writeRealType = ptr $ FunctionType {
    resultType = T.void
  , argumentTypes = [double]
  , isVarArg = False
  }
  
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

readInteger :: Operand
readInteger = consGlobalRef readIntegerType "readInteger"

readIntegerType = ptr $ FunctionType {
    resultType = i16
  , argumentTypes = []
  , isVarArg = False
  }

readBoolean :: Operand
readBoolean = consGlobalRef readBooleanType "readBoolean"

readBooleanType = ptr $ FunctionType {
    resultType = i1
  , argumentTypes = []
  , isVarArg = False
  }

readChar :: Operand
readChar = consGlobalRef readCharType "readChar"

readCharType = ptr $ FunctionType {
    resultType = i8
  , argumentTypes = []
  , isVarArg = False
  }

readReal :: Operand
readReal = consGlobalRef readRealType "readReal"

readRealType = ptr $ FunctionType {
    resultType = double
  , argumentTypes = []
  , isVarArg = False
  }

abs :: Operand
abs = consGlobalRef absType "abs"

absType = ptr $ FunctionType {
    resultType = i16
  , argumentTypes = [i16]
  , isVarArg = False
  }

fabs :: Operand
fabs = consGlobalRef mathType "fabs"

sqrt :: Operand
sqrt = consGlobalRef mathType "sqrt"

sin :: Operand
sin = consGlobalRef mathType "sin"

cos :: Operand
cos = consGlobalRef mathType "cos"

tan :: Operand
tan = consGlobalRef mathType "tan"

arctan :: Operand
arctan = consGlobalRef mathType "atan"

exp :: Operand
exp = consGlobalRef mathType "exp"

ln :: Operand
ln = consGlobalRef mathType "log"

acos :: Operand
acos = consGlobalRef mathType "acos"

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

cons :: C.Constant -> Operand
cons = ConstantOperand

sitofp :: Operand -> Sems Operand
sitofp a = instr double $ SIToFP a double []

fptosi :: Operand -> Sems Operand
fptosi a = instr i16 $ FPToSI a i16 []

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))

call :: Operand -> [Operand] -> Sems Operand
call fn args = case fn of
  ConstantOperand (C.GlobalReference ty _) ->
    instr (resultType ty) $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []
  _ -> undefined


callVoid :: Operand -> [Operand] -> Sems ()
callVoid fn args = instrDo $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

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

truncTo :: Operand -> Sems Operand
truncTo op = instr i8 $ Trunc op i8 []

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

getElemPtr' :: Operand -> Int -> Sems Operand
getElemPtr' arrPtr ind =
  instr double $ GetElementPtr False arrPtr [toConsI16 ind] []

getElemPtrOp' :: Operand -> Operand -> Sems Operand
getElemPtrOp' arrPtr ind =
  instr double $ GetElementPtr False arrPtr [ind] []

br :: Name -> Sems ()
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Sems ()
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

ret :: Operand -> Sems ()
ret val = terminator $ Do $ Ret (Just val) []

retVoid :: Sems ()
retVoid = terminatorVoid $ Do $ Ret Nothing []
