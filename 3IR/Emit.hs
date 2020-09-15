{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.Module
import LLVM.Context

import LLVM.AST as AST
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.IntegerPredicate as I
import LLVM.AST.AddrSpace

import Data.Word
import Data.Int
import Control.Monad.Except
import Control.Applicative
import qualified Data.Map as Map

import Codegen
import Parser as P
import SemsTypes ((>>>),Env(InProc))
import LLVM.AST.Type as T
import Data.Bits.Extras
import Data.String.Transform
import Data.Char (ord)
import Data.ByteString.Char8 (unpack)
import Control.Monad.State
import Control.Monad.Trans.Either
import System.Process

codegen :: Program -> IO ()
codegen program =
  withContext $ \context -> withModuleFromAST context newast $ \m -> do
    llstr <- moduleLLVMAssembly m
    --putStrLn $ unpack llstr
    writeFile "llvmhs.ll" $ unpack llstr
    callCommand "./usefulHs.sh"
  where
    newast = execState (codegenProgram program) defaultModule

codegenProgram :: Program -> LLVM ()
codegenProgram (P id body) = do
  modify $ \mod -> mod { moduleName = idToShort id }
  codegenBody body

writeRealBlocks :: Codegen ()
writeRealBlocks = do 
  entry <- addBlock entryBlockName
  setBlock entry
  str <- getElemPtrInBounds
    (cons $ C.GlobalReference (PointerType (ArrayType 4 i8) (AddrSpace 0)) ".str")	  
    (cons $ C.Int 16 $ toInteger 0)
  call (printf $ toName $ "printf") [str,LocalReference double (UnName 0)]
  retVoid

writeStringBlocks :: Codegen ()
writeStringBlocks = do 
  entry <- addBlock entryBlockName
  setBlock entry
  res <- call (printf $ toName $ "printf") [
      LocalReference (PointerType i8 (AddrSpace 0)) (UnName 0)
    ]
  retVoid

codegenBody :: Body -> LLVM ()
codegenBody body = do
  printfDef
  writeRealDef $ createBlocks $ execCodegen writeRealBlocks
  writeStringDef (createBlocks $ execCodegen $  writeStringBlocks )
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
cgenVars (ids,ty) = mapM_ (cgenVar ty) $ reverse ids

cgenVar :: P.Type -> Id -> Codegen ()
cgenVar ty id = do 
  var <- alloca $ toTType ty
  assign (idString id) var

cgenStmt :: Stmt -> Codegen () 
cgenStmt = \case
  Empty                         -> return ()
  Assignment _ lVal expr        -> cgenAssign lVal expr
  Block      stmts              -> mapM_ cgenStmt stmts
  CallS      (id,exprs)         -> cgenCallStmt id exprs
  IfThen     _ expr stmt        -> cgenIfThen expr stmt
  IfThenElse _ expr stmt1 stmt2 -> cgenIfThenElse expr stmt1 stmt2
  While      _ expr stmt        -> cgenWhile expr stmt
  Label      id stmt            -> undefined
  GoTo       id                 -> undefined
  Return                        -> undefined
  New        _ new lVal         -> cgenNew lVal new
  Dispose    _ dispType lVal    -> cgenDispType lVal dispType

cgenDispType :: LVal -> DispType -> Codegen ()
cgenDispType lVal = \case
  With    -> cgenDispWith lVal
  Without -> cgenDispWithout lVal 

cgenDispWith :: LVal -> Codegen ()
cgenDispWith lVal = undefined

cgenDispWithout :: LVal -> Codegen ()
cgenDispWithout lVal = undefined

cgenNew :: LVal -> New -> Codegen ()
cgenNew lVal = \case
  NewNoExpr     -> cgenNewNoExpr lVal
  NewExpr expr  -> cgenNewExpr lVal expr

cgenNewNoExpr :: LVal -> Codegen ()
cgenNewNoExpr lVal = do
  lValOper <- cgenLVal lVal
  newPtr <- alloca $ case lValOper of
    LocalReference ty name -> ty
    _                      -> error "cgenNewNoExpr: should not happen"
  store lValOper newPtr

cgenNewExpr :: LVal -> Expr -> Codegen ()
cgenNewExpr lVal expr = do
  lValOper <- cgenLVal lVal
  exprOper <- cgenExpr expr
  newPtr <- allocaNum exprOper $ case lValOper of
    LocalReference ty name -> ty
    _                      -> error "cgenNewExpr: should not happen"
  store lValOper newPtr

cgenCallStmt :: Id -> [Expr] -> Codegen ()
cgenCallStmt id exprs = do
  largs <- mapM cgenExpr exprs
  case idToName id of
    "writeReal" -> callVoid (writeReal $ idToName id) largs
    "writeString" -> callVoid (writeString $ idToName id) largs
    _ -> undefined

cgenCallR :: Id -> [Expr] -> Codegen Operand
cgenCallR id exprs = undefined

cgenIfThen :: Expr -> Stmt -> Codegen ()
cgenIfThen expr stmt = do
  ifthen <- addBlock "if.then"
  ifexit <- addBlock "if.exit"

  cond <- cgenExpr expr
  cbr cond ifthen ifexit

  setBlock ifthen
  cgenStmt stmt          
  br ifexit              

  setBlock ifexit
  return ()

cgenIfThenElse :: Expr -> Stmt -> Stmt -> Codegen ()
cgenIfThenElse expr stmt1 stmt2 = do
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cond <- cgenExpr expr
  cbr cond ifthen ifelse

  setBlock ifthen
  cgenStmt stmt1
  br ifexit     

  setBlock ifelse
  cgenStmt stmt2
  br ifexit     

  setBlock ifexit
  return ()

cgenWhile :: Expr -> Stmt -> Codegen ()
cgenWhile expr stmt = do
  while     <- addBlock "while"
  whileExit <- addBlock "while.exit"

  cond <- cgenExpr expr
  cbr cond while whileExit

  setBlock while
  cgenStmt stmt          
  cond <- cgenExpr expr
  cbr cond while whileExit

  setBlock whileExit
  return ()


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
  LVal lVal -> cgenLVal lVal >>= load
  RVal rVal -> cgenRVal rVal

cgenLVal :: LVal -> Codegen Operand
cgenLVal = \case
  IdL         id          -> getvar $ idString id
  Result      _           -> undefined
  StrLiteral  string      -> cgenStrLiteral string
  Indexing    _ lVal expr -> cgenIndexing lVal expr
  Dereference _ expr      -> cgenExpr expr 
  ParenL      lVal        -> cgenLVal lVal

cgenStrLiteral :: String -> Codegen Operand
cgenStrLiteral string = do
  num <- cgenRVal $ IntR $ length string + 1
  strPtrOper <- alloca $ toTType $ Pointer CharT
  strOper <- allocaNum num $ toTType CharT
  mapM_ (cgenStrLitChar strOper) $ indexed 0 $ string ++ ['\0']
  store strPtrOper strOper
  return strPtrOper

cgenStrLitChar :: Operand -> (Int,Char) -> Codegen ()
cgenStrLitChar strOper (ind,char) = do
  charPtr <- getElemPtr' strOper (cons $ C.Int 16 $ toInteger ind)
  store charPtr $ cons $ C.Int 8 $ toInteger $ ord char

indexed :: Int -> String -> [(Int,Char)]
indexed i = \case
  c:cs -> (i,c):indexed (i+1) cs
  []   -> []

cgenIndexing :: LVal -> Expr -> Codegen Operand
cgenIndexing lVal expr = do
  lOper <- cgenLVal lVal
  eOper <- cgenExpr expr
  getElemPtr lOper eOper >>= return

cgenRVal :: RVal -> Codegen Operand
cgenRVal = \case
  IntR    int           -> return $ cons $ C.Int 16 $ toInteger int
  TrueR                 -> return $ cons $ C.Int 1 1
  FalseR                -> return $ cons $ C.Int 1 0
  RealR   double        -> return $ cons $ C.Float  $ F.Double double --X86_FP80
  CharR   char          -> return $ cons $ C.Int 8 $ toInteger $ ord char
  ParenR  rVal          -> cgenRVal rVal
  NilR                  -> return $ cons $ C.Null $ ptr VoidType --Void? if not how to know
  CallR   (id,exprs)    -> cgenCallR id exprs
  Papaki  lVal          -> cgenLVal lVal
  Not     _ expr        -> cgenBinOp (icmp I.EQ) expr $ RVal FalseR
  Pos     _ expr        -> cgenExpr expr
  Neg     _ expr        -> cgenBinOp fsub (RVal $ RealR 0) expr
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

type InstType = Operand -> Operand -> Codegen Operand
cgenBinOp :: InstType -> Expr -> Expr -> Codegen Operand
cgenBinOp inst expr1 expr2 = do
  op1 <- cgenExpr expr1
  op2 <- cgenExpr expr2
  inst op1 op2

idToName :: Id -> Name
idToName = idString >>> toName

toName :: String -> Name
toName = toShortByteString >>> Name

idToShort = idString >>> toShortByteString

toTType :: P.Type -> T.Type
toTType = \case
  Nil           -> undefined
  IntT          -> i16
  RealT         -> double
  BoolT         -> i1
  CharT         -> i8
  Array size ty -> arrayToTType ty size
  Pointer ty    -> ptr $ toTType ty

arrayToTType :: P.Type -> ArrSize -> T.Type
arrayToTType ty = \case
  NoSize -> toTType ty -- is this right? what could the type be
  Size n -> ArrayType (w64 n) $ toTType ty
