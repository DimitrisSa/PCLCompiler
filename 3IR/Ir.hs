{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module IR where

import Data.ByteString.Short (ShortByteString)
import LLVM.AST
import LLVM.AST.Float
--import LLVM.AST.FloatingPointPredicate
import LLVM.AST.Type as T
import LLVM.AST.Global
import Parser as P
import SemTypes
import Semantics
import Control.Monad.State hiding (void)
import Data.Map as Map
import Data.Function
import Data.List

codeGenProgram :: Program -> LLVM ()
codeGenProgram (P id body) = do
  modify $ \s -> s { moduleName = tsp $ idString id}
  define void "main" [] []
  codeGenBody body

codeGenBody :: Body -> LLVM ()
codeGenBody (Body ls blc) = do
  codeGenLocals ls
  codeGenBlock blc

codeGenLocals :: [Local] -> LLVM ()
codeGenLocals = mapM_ codeGenLocal

current :: Codegen BlockState
current = do
  c <- gets currentBlock
  blks <- gets blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c

modifyBlock :: BlockState -> Codegen ()
modifyBlock new = do
  active <- gets currentBlock
  modify $ \s -> s { blocks = Map.insert active new (blocks s) }

local ::  Name -> Operand
local = LocalReference double

codeGenLocal :: Local -> LLVM ()
codeGenLocal = \case
  LoVar variables       -> return ()
  LoLabel ids           -> return () 
  LoHeadBod header body -> codeGenHeadBod header body
  LoForward header      -> undefined

codeGenHeadBod :: Header -> Body -> LLVM ()
codeGenHeadBod = \case
  ProcedureHeader id args    -> undefined
  P.FunctionHeader  id args ty -> \body -> codeGenFun id args ty body

codeGenBlock :: Block -> LLVM ()
codeGenBlock _ = return ()

codeGenFun :: Id -> Args -> P.Type -> Body -> LLVM ()
codeGenFun i a t b = do
  let name = idString i
  let ty = tollvmTy t
  let args = toSig a
  define ty name args []
--where
--  bls = createBlocks $ execCodegen $ do
--    entry <- addBlock entryBlockName
--    setBlock entry
--    forM args $ \(t,n) -> do
--      var <- alloca t
--      store var (local n)
--      assign a var
--    cgen body >>= ret

--assign :: Id -> Operand -> Codegen ()
--assign var x = do
--  (vm,lm,cm,nm):sms <- gets symtab
--  modify $ \s -> s {
--    symtab = (Map.insert var x vm,lm,cm,nm):sms }
--
----insInVmOper :: String -> Operand -> VarMap -> VarMap
----insInVmOper = 
--
--alloca :: T.Type -> Codegen Operand
--alloca ty = instr $ Alloca ty Nothing 0 []
--
--store :: Operand -> Operand -> Codegen Operand
--store ptr val = instr $ Store False ptr val Nothing 0 []
--
--instr :: Instruction -> Codegen (Operand)
--instr ins = do
--  n <- fresh
--  let ref = (UnName n)
--  blk <- current
--  let i = stack blk
--  modifyBlock (blk { stack = (ref := ins) : i } )
--  return $ local ref
--
--fresh :: Codegen Word
--fresh = do
--  i <- gets count
--  modify $ \s -> s { count = 1 + i }
--  return $ i + 1
--
--emptyBlock :: Int -> BlockState
--emptyBlock i = BlockState i [] Nothing
--
--addBlock :: String -> Codegen Name
--addBlock bname = do
--  bls <- gets blocks
--  ix  <- gets blockCount
--  nms <- gets names
--
--  let new = emptyBlock ix
--      (qname, supply) = uniqueName bname nms
--
--  modify $ \s -> s {
--      blocks = Map.insert (Name $ tsp qname) new bls
--    , blockCount = ix + 1
--    , names = supply
--    }
--  return (Name $ tsp qname)
--
--setBlock :: Name -> Codegen Name
--setBlock bname = do
--  modify $ \s -> s { currentBlock = bname }
--  return bname
--
--makeBlock :: (Name, BlockState) -> BasicBlock
--makeBlock (l, (BlockState _ s t)) =
--  BasicBlock l (reverse s) (maketerm t)
--  where
--    maketerm (Just x) = x
--    maketerm Nothing =
--      error $ "Block has no terminator: " ++ (show l)
--
--createBlocks :: CodegenState -> [BasicBlock]
--createBlocks m =
--  Prelude.map makeBlock $ sortBlocks $ Map.toList (blocks m)
--
--sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
--sortBlocks = sortBy (compare `on` (idx . snd))
--
--
newtype Codegen a =
  Codegen { runCodegen :: State CodegenState a }
  deriving (Functor, Applicative, Monad,
            MonadState CodegenState )

execCodegen :: Codegen a -> CodegenState
execCodegen m = execState (runCodegen m) emptyCodegen

emptyCodegen :: CodegenState
emptyCodegen = CodegenState (Name entryBlockName) Map.empty [] 1 0 Map.empty

entryBlockName :: ShortByteString
entryBlockName = tsp "entry"

define :: T.Type -> String -> [(T.Type, Name)] -> [BasicBlock] -> LLVM ()
define retty label argtys body = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = Name $ tsp label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

--codegenFun :: Header -> Body -> LLVM ()
--codegenFun header body = do
--  let name = idValue $ fname header
--  let ty = tollvmTy $ fty header
--  let args = toSig $ fargs header
--  define ty name args bls
--  where
--    bls = createBlocks $ execCodegen $ do
--      entry <- addBlock entryBlockName
--      setBlock entry
--      forM args $ \a -> do
--        var <- alloca double
--        store var (local (AST.Name a))
--        assign a var
--      cgen body >>= ret
--
--codegenProc :: Header -> Body -> LLVM ()
--codegenProc header body = undefined
--
--codegenHeadBod :: Local -> LLVM ()
--codegenHeadBod (LoHeadBod header body) = case header of
--  P.Procedure _ _   -> codegenFun header body
--  P.Function  _ _ _ -> codegenProc header body
--
-- Type Sizes
