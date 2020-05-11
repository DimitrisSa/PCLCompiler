module IR where

import LLVM.AST
import LLVM.AST.Float
import LLVM.AST.FloatingPointPredicate
import LLVM.AST.Type
import Parser as P
import SemTypes

--codeGenProgram :: Program -> LLVM ()
--codeGenProgram (P id body) = 
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
