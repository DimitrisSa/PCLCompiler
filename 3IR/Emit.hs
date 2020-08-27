{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.Module
import LLVM.Context

import LLVM.AST as AST
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import qualified LLVM.AST.FloatingPointPredicate as FP

import Data.Word
import Data.Int
import Control.Monad.Except
import Control.Applicative
import qualified Data.Map as Map

import Codegen
import Parser as P
import Sems
import SemsTypes ((>>>))
import LLVM.AST.Type as T
import Data.Bits.Extras
import Data.String.Transform
import Data.Char (ord)
import Data.ByteString.Char8 (unpack)

--toSig :: [String] -> [(AST.Type, AST.Name)]
--toSig = map (\x -> (double, AST.Name x))

process :: IO ()
process = sems >>= codegenProgram

codegenProgram :: Program -> IO ()
codegenProgram (P id body) = codegen (emptyModule $ idString id) body

codegen :: AST.Module -> Body -> IO ()
codegen mod b = withContext $ \context -> withModuleFromAST context newast $ \m -> do
  llstr <- moduleLLVMAssembly m
  putStrLn $ unpack llstr
  where
    modn    = codegenBody b
    newast  = runLLVM mod modn

codegenBody :: Body -> LLVM ()
codegenBody body = 
  define T.void "main" [] blks
  where
    blks = createBlocks $ execCodegen $ do
      entry <- addBlock entryBlockName
      setBlock entry
      cgenBody body
      retVoid

cgenBody :: Body -> Codegen ()
cgenBody (Body lcls stmts) = do
  mapM_ cgenLcl $ reverse lcls
  mapM_ cgenStmt $ reverse stmts

cgenLcl :: Local -> Codegen ()
cgenLcl = \case
  VarsWithTypeList idsWithTylist -> mapM_ cgenVars $ reverse idsWithTylist
  Labels ids                     -> return () -- should we do anything ?
  HeaderBody hdr bd              -> undefined
  Forward hdr                    -> cgenHdr hdr

cgenVars :: ([Id],P.Type) -> Codegen ()
cgenVars (ids,ty) = mapM_ (cgenVar ty) ids

cgenVar :: P.Type -> Id -> Codegen ()
cgenVar ty id = do -- undefined -- do we do anything ?
  var <- alloca $ toTType ty
  assign (idString id) var

cgenStmt :: Stmt -> Codegen () -- Operand?, Unit?
cgenStmt = \case
  Empty                         -> return ()
  Assignment _ lVal expr        -> cgenAssign lVal expr
  Block      stmts              -> mapM_ cgenStmt stmts
  CallS      (id,exprs)         -> undefined
--cgen (S.Call fn args) = do
--  largs <- mapM cgen args
--  call (externf (AST.Name fn)) largs
  IfThen     _ expr stmt        -> undefined
  IfThenElse _ expr stmt1 stmt2 -> undefined
  While      _ expr stmt        -> undefined
  Label      id stmt            -> undefined
  GoTo       id                 -> undefined
  Return                        -> undefined
  New        _ new lVal         -> undefined
  Dispose    _ dispType lVal    -> undefined

cgenAssign :: LVal -> Expr -> Codegen ()
cgenAssign lVal expr = do
  lValOper <- cgenLVal lVal
  exprOper <- cgenExpr expr
  store lValOper exprOper

cgenHdr :: Header -> Codegen ()
cgenHdr = \case
  ProcHeader id frmls    -> undefined
  FuncHeader id frmls ty -> undefined

cgenExpr :: Expr -> Codegen Operand
cgenExpr = \case
  LVal lVal -> cgenLVal lVal
  RVal rVal -> cgenRVal rVal

cgenLVal :: LVal -> Codegen Operand
cgenLVal = \case
  IdL         id          -> getvar $ idString id
  Result      _           -> undefined
  StrLiteral  string      -> undefined
  Indexing    _ lVal expr -> undefined
  Dereference _ expr      -> undefined --cgenExpr expr
  ParenL      lVal        -> cgenLVal lVal

cgenRVal :: RVal -> Codegen Operand
cgenRVal = \case
  IntR    int           -> return $ cons $ C.Int 16 $ toInteger int
  TrueR                 -> return $ cons $ C.Int 8 $ toInteger 1
  FalseR                -> return $ cons $ C.Int 8 $ toInteger 0
  RealR   double        -> return $ cons $ C.Float  $ F.Double double --X86_FP80
  CharR   char          -> return $ cons $ C.Int 8 $ toInteger $ ord char
  ParenR  rVal          -> cgenRVal rVal
  NilR                  -> return $ cons $ C.Null $ ptr VoidType --Void? if not how to know
  CallR   (id,exprs)    -> undefined
  Papaki  lVal          -> undefined -- cgenLVal lVal
  Not     _ expr        -> cgenExpr expr >>= cgenNot
  Pos     _ expr        -> cgenExpr expr -- ?
  Neg     _ expr        -> undefined --fneg?
  Plus    _ expr1 expr2 -> cgenBinOp fadd expr1 expr2
  P.Mul   _ expr1 expr2 -> cgenBinOp fmul expr1 expr2
  Minus   _ expr1 expr2 -> cgenBinOp fsub expr1 expr2
  RealDiv _ expr1 expr2 -> cgenBinOp fdiv expr1 expr2
  Div     _ expr1 expr2 -> cgenBinOp sdiv expr1 expr2
  Mod     _ expr1 expr2 -> cgenBinOp srem expr1 expr2
  P.Or    _ expr1 expr2 -> cgenBinOp orInstr expr1 expr2
  P.And   _ expr1 expr2 -> cgenBinOp andInstr expr1 expr2
  Eq      _ expr1 expr2 -> cgenBinOp (fcmp FP.OEQ) expr1 expr2
  Diff    _ expr1 expr2 -> cgenBinOp (fcmp FP.ONE) expr1 expr2
  Less    _ expr1 expr2 -> cgenBinOp (fcmp FP.OLT) expr1 expr2
  Greater _ expr1 expr2 -> cgenBinOp (fcmp FP.OGT) expr1 expr2
  Greq    _ expr1 expr2 -> cgenBinOp (fcmp FP.OGE) expr1 expr2
  Smeq    _ expr1 expr2 -> cgenBinOp (fcmp FP.OLE) expr1 expr2

cgenBinOp inst expr1 expr2 = do
  op1 <- cgenExpr expr1
  op2 <- cgenExpr expr2
  inst op1 op2

cgenNot :: Operand -> Codegen Operand
cgenNot op 
  | op == (cons $ C.Int 8 $ toInteger 1) = return $ cons $ C.Int 8 $ toInteger 0
  | op == (cons $ C.Int 8 $ toInteger 0) = return $ cons $ C.Int 8 $ toInteger 1
  | otherwise = error $ "cgenNot: should not have this value" ++ show op

idToName :: Id -> Name
idToName =  idString >>> toShortByteString >>> Name

toTType :: P.Type -> T.Type
toTType = \case
  Nil           -> undefined
  IntT          -> i16
  RealT         -> x86_fp80  
  BoolT         -> i8
  CharT         -> i8
  Array size ty -> arrayToTType ty size
  Pointer ty    -> ptr $ toTType ty
 
arrayToTType :: P.Type -> ArrSize -> T.Type
arrayToTType ty = \case
  NoSize -> ptr $ toTType ty
  Size n -> ArrayType (w64 n) $ toTType ty

--codegenTop :: S.Expr -> LLVM ()
--codegenTop (S.Function name args body) = do
--  define double name fnargs bls
--  where
--    fnargs = toSig args
--    bls = createBlocks $ execCodegen $ do
--      entry <- addBlock entryBlockName
--      setBlock entry
--      forM args $ \a -> do
--        var <- alloca double
--        store var (local (AST.Name a))
--        assign a var
--      cgen body >>= ret
--
--codegenTop (S.Extern name args) = do
--  external double name fnargs
--  where fnargs = toSig args
--
--codegenTop exp = do
--  define double "main" [] blks
--  where
--    blks = createBlocks $ execCodegen $ do
--      entry <- addBlock entryBlockName
--      setBlock entry
--      cgen exp >>= ret
--
---------------------------------------------------------------------------------
---- Operations
---------------------------------------------------------------------------------
--
--lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
--lt a b = do
--  test <- fcmp FP.ULT a b
--  uitofp double test
--
--binops = Map.fromList [
--      ("+", fadd)
--    , ("-", fsub)
--    , ("*", fmul)
--    , ("/", fdiv)
--    , ("<", lt)
--  ]
--
--cgen :: S.Expr -> Codegen AST.Operand
--cgen (S.UnaryOp op a) = do
--  cgen $ S.Call ("unary" ++ op) [a]
--cgen (S.BinaryOp "=" (S.Var var) val) = do
--  a <- getvar var
--  cval <- cgen val
--  store a cval
--  return cval
--cgen (S.BinaryOp op a b) = do
--  case Map.lookup op binops of
--    Just f  -> do
--      ca <- cgen a
--      cb <- cgen b
--      f ca cb
--    Nothing -> error "No such operator"
--cgen (S.Var x) = getvar x >>= load
--cgen (S.Float n) = return $ cons $ C.Float (F.Double n)
--cgen (S.Call fn args) = do
--  largs <- mapM cgen args
--  call (externf (AST.Name fn)) largs
--
