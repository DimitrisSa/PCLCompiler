{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module SemsCodegen where

--import Data.Word
--import Data.String
import Data.List
import Data.Function
--import Data.String.Transform
import qualified Data.Map as Map
--
--import Control.Monad.State
--import Control.Applicative
--
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
--import qualified LLVM.AST as AST
--
--import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Attribute as A
import qualified LLVM.AST.CallingConvention as CC
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.IntegerPredicate as I
--import LLVM.AST.AddrSpace
--
import Parser as P
import SemsTypes
import Data.List.Index
import Data.String.Transform
--
--type LLVM = State AST.Module
--
--define ::  T.Type -> String -> [(T.Type, Name)] -> [BasicBlock] -> Sems ()
--define retty label argtys body = do
--  
--  addGlobalDef functionDefaults {
--    name        = toShortName label
--  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
--  , returnType  = retty
--  , basicBlocks = body
--  }
defineFun :: String -> T.Type -> [Frml] -> Sems () -> Sems ()
defineFun name retty frmls codegen = do
  modifyCodegen $ \_ -> emptyCodegen
  codegen
  blocks <- createBlocks
  addGlobalDef functionDefaults {
      returnType = retty
    , name = toName name
    , parameters =  (
        fmap (frmlToTy >>> tyToParam) $ indexed frmls
      , False
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

--
--writeRealDef :: [BasicBlock] -> LLVM ()
--writeRealDef blks = do
--  addDefn $ GlobalDefinition $ globalVariableDefaults {
--      name = Name ".str"
--    , linkage = L.Private
--    , unnamedAddr = Just GlobalAddr
--    , isConstant = True
--    , LLVM.AST.Global.type' = ArrayType 4 i8 
--    , LLVM.AST.Global.alignment = 1
--    , initializer = Just $ C.Array i8 [C.Int 8 37, C.Int 8 102,C.Int 8 10, C.Int 8 0]
--    }
--  addDefn $ GlobalDefinition $ functionDefaults {
--      returnType = T.void
--    , name = Name "writeReal"
--    , parameters = (
--        [ Parameter double (UnName 0) [] ]
--      , False
--      )
--    , basicBlocks = blks
--    } 
--
--type Names = Map.Map String Int
--

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)
--
--type SymbolTable = [(String, Operand)]
--
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

instr :: Instruction -> Sems Operand
instr ins = do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (ref := ins) : i } )
  return $ local ref

instrDo :: Instruction -> Sems ()
instrDo ins = do
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (Do ins) : i } )

--terminator :: Named Terminator -> Sems (Named Terminator)
--terminator trm = do
--  blk <- current
--  modifyBlock (blk { term = Just trm })
--  return trm
--
terminatorVoid :: Named Terminator -> Sems ()
terminatorVoid trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })

--entry :: Sems Name
--entry = gets currentBlock

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

setBlock :: Name -> Sems Name
setBlock bname = do
  modifyCodegen $ \s -> s { currentBlock = bname }
  return bname

--getBlock :: Sems Name
--getBlock = gets currentBlock
--
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

local ::  Name -> Operand
local = LocalReference double
--
--global ::  Name -> C.Constant
--global = C.GlobalReference double
--

consGlobalRef :: T.Type -> Name -> Operand
consGlobalRef ty name = ConstantOperand $ C.GlobalReference ty name

printf :: Operand
printf = consGlobalRef printfType "printf"

printfType = ptr $ FunctionType {
    resultType = i32
  , argumentTypes = [ptr i8]
  , isVarArg = True
  }

--
--writeReal :: Name -> Operand
--writeReal = ConstantOperand . C.GlobalReference writeRealType
--
--writeString :: Name -> Operand
--writeString = ConstantOperand . C.GlobalReference writeStringType
--
--
--writeStringType = ptr $ FunctionType {
--    resultType = T.void
--  , argumentTypes = [ptr i8]
--  , isVarArg = True
--  }
--
--writeRealType = ptr $ FunctionType {
--    resultType = T.void
--  , argumentTypes = [double]
--  , isVarArg = False
--  }
--  
fadd :: Operand -> Operand -> Sems Operand
fadd a b = instr $ FAdd noFastMathFlags a b []

add :: Operand -> Operand -> Sems Operand
add a b = instr $ Add False False a b []

fsub :: Operand -> Operand -> Sems Operand
fsub a b = instr $ FSub noFastMathFlags a b []

sub :: Operand -> Operand -> Sems Operand
sub a b = instr $ Sub False False a b []

fmul :: Operand -> Operand -> Sems Operand
fmul a b = instr $ FMul noFastMathFlags a b []

mul :: Operand -> Operand -> Sems Operand
mul a b = instr $ LLVM.AST.Mul False False a b []

fdiv :: Operand -> Operand -> Sems Operand
fdiv a b = instr $ FDiv noFastMathFlags a b []

sdiv :: Operand -> Operand -> Sems Operand
sdiv a b = instr $ SDiv False a b []

srem :: Operand -> Operand -> Sems Operand
srem a b = instr $ SRem a b []

orInstr :: Operand -> Operand -> Sems Operand
orInstr a b = instr $ LLVM.AST.Or a b []

andInstr :: Operand -> Operand -> Sems Operand
andInstr a b = instr $ LLVM.AST.And a b []

fcmp :: FP.FloatingPointPredicate -> Operand -> Operand -> Sems Operand
fcmp cond a b = instr $ FCmp cond a b []
--
icmp :: I.IntegerPredicate -> Operand -> Operand -> Sems Operand
icmp cond a b = instr $ ICmp cond a b []

--phi :: AST.Type -> [(Operand, Name)] -> Sems ()
--phi ty incoming = instrDo $ Phi ty incoming []
--
cons :: C.Constant -> Operand
cons = ConstantOperand
--
sitofp :: Operand -> Sems Operand
sitofp a = instr $ SIToFP a double []
--
toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))
--
--call :: Operand -> [Operand] -> Sems Operand
--call fn args = instr $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []
--
callVoid :: Operand -> [Operand] -> Sems ()
callVoid fn args = instrDo $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []
--
alloca :: T.Type -> Sems Operand
alloca ty = instr $ Alloca ty Nothing 0 []

allocaNum :: Operand -> T.Type -> Sems Operand
allocaNum oper ty = instr $ Alloca ty (Just oper) 0 []

store :: Operand -> Operand -> Sems ()
store ptr val = instrDo $ Store False ptr val Nothing 0 []
--
--load :: Operand -> Sems Operand
--load ptr = instr $ Load False ptr Nothing 0 []
--
--getElemPtr :: Operand -> Operand -> Sems Operand
--getElemPtr arrPtr ind =
--  instr $ GetElementPtr False arrPtr [cons $ C.Int 16 $ toInteger 0,ind] []
--
--getElemPtrInBounds :: Operand -> Operand -> Sems Operand
--getElemPtrInBounds arrPtr ind =
--  instr $ GetElementPtr True arrPtr [cons $ C.Int 16 $ toInteger 0,ind] []
--
getElemPtr' :: Operand -> Operand -> Sems Operand
getElemPtr' arrPtr ind =
  instr $ GetElementPtr False arrPtr [ind] []

--br :: Name -> Sems (Named Terminator)
--br val = terminator $ Do $ Br val []
--
--cbr :: Operand -> Name -> Name -> Sems (Named Terminator)
--cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []
--
--ret :: Operand -> Sems (Named Terminator)
--ret val = terminator $ Do $ Ret (Just val) []
--
retVoid :: Sems ()
retVoid = terminatorVoid $ Do $ Ret Nothing []
