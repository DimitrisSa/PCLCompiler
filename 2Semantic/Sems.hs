module Main where
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import Data.Function
import Common hiding (map)
import InitSymTab (initSymTab)
import LocalsSems 
import CheckUnusedLabels (checkUnusedLabels)
import LValTypes
import RValTypes
import StmtSems

-- same name of fun inside of other fun?
main :: IO ()
main = sems

sems :: IO ()
sems = getContents >>= parser >>> parserCases

parserCases :: Either Error Program -> IO ()
parserCases = \case 
  Left e    -> die e
  Right ast -> astSems ast

astSems :: Program -> IO ()
astSems ast =
  let runProgramSems = programSems >>> runEitherT >>> evalState
  in case runProgramSems ast initState of
    Right _  -> hPutStrLn stdout "good" >> exitSuccess
    Left s   -> die s

programSems :: Program -> Sems ()
programSems (P _ body) = initSymTab >> bodySems body

bodySems :: Body -> Sems ()
bodySems (Body locals stmts) =
  localsSems (reverse locals) >> stmtsSems (reverse stmts) >> checkUnusedLabels

localsSems :: [Local] -> Sems ()
localsSems locals = mapM_ localSems locals >> checkUndefDclrs

localSems :: Local -> Sems ()
localSems = \case
  VarsWithTypeList vwtl -> varsWithTypeListSems $ reverse vwtl
  Labels ls             -> insToSymTabLabels $ reverse ls
  HeaderBody h b        -> headerBodySems h b
  Forward h             -> forwardSems h

headerBodySems :: Header -> Body -> Sems ()
headerBodySems h b = do
  headerParentSems h
  (e,sms) <- get
  put $ (e,emptySymbolTable:sms)
  headerChildSems h
  bodySems b
  checkResult
  put (e,sms)

stmtsSems :: [Stmt] -> Sems ()
stmtsSems ss = mapM_ stmtSems ss

stmtSems :: Stmt -> Sems ()
stmtSems = \case
  Empty                       -> return ()
  Assignment li co lVal expr  -> assignmentSems li co lVal expr
  Block stmts                 -> stmtsSems $ reverse stmts
  CallS (id,exprs)            -> callSems id $ reverse exprs
  IfThen li co e s            -> exprType e >>= boolCases li co "if-then" >> stmtSems s
  IfThenElse li co e s1 s2    -> exprType e >>= boolCases li co "if-then-else" >>
                                 mapM_ stmtSems [s1,s2]
  While li co e stmt          -> exprType e >>= boolCases li co "while" >> stmtSems stmt
  Label lab stmt              -> lookupInLabelMap lab >>= labelCases lab >> stmtSems stmt
  GoTo lab                    -> lookupInLabelMap lab >>= goToCases lab
  Return                      -> return ()
  New li co new lVal          -> newSems li co new lVal
  Dispose li co disptype lVal -> disposeSems li co disptype lVal

callSems :: Id -> Exprs -> Sems ()
callSems id exprs = searchCallableInSymTabs id >>= \case
  ProcDclr as -> formalsExprsMatch id as exprs
  Proc  as    -> formalsExprsMatch id as exprs
  _           -> errAtId "Use of function in call statement: " id

assignmentSems :: Int -> Int -> LVal -> Expr -> Sems ()
assignmentSems li co = \case
  StrLiteral str -> \_ -> errPos li co $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypes lVal >=> notStrLiteralSems li co

newSems :: Int -> Int -> New -> LVal -> Sems ()
newSems li co = \case
  NewNoExpr -> lValType >=> newNoExprSems li co
  NewExpr e -> exprLValTypes e >=> newExprSems li co

disposeSems :: Int -> Int -> DispType -> LVal -> Sems ()
disposeSems li co = \case
  Without -> lValType >=> dispWithoutSems li co
  With    -> lValType >=> dispWithSems li co

exprType :: Expr -> Sems Type
exprType = \case
  LVal lval -> lValType lval
  RVal rval -> rValType rval

lValType :: LVal -> Sems Type
lValType = \case
  IdL id                   -> searchVarInSymTabs id
  Result li co             -> resultType li co
  StrLiteral str           -> right $ Array (Size $ length str + 1) CharT
  Indexing li co lVal expr -> lValExprTypes lVal expr >>= indexingCases li co
  Dereference li co expr   -> exprType expr >>= dereferenceCases li co
  ParenL lVal              -> lValType lVal

exprLValTypes expr lVal =
  exprType expr >>= \etype -> lValType lVal >>= \ltype -> return (etype,ltype)

lValExprTypes lVal expr =
  lValType lVal >>= \ltype -> exprType expr >>= \etype -> return (ltype,etype)

rValType :: RVal -> Sems Type
rValType = \case
  IntR _              -> right IntT
  TrueR               -> right BoolT
  FalseR              -> right BoolT
  RealR _             -> right RealT
  CharR _             -> right CharT
  ParenR  rVal        -> rValType rVal
  NilR                -> right Nil
  CallR   (id,exprs)  -> callType id $ reverse exprs
  Papaki  _ _ lVal    -> lValType lVal >>= Pointer >>> right
  Not     li co expr  -> exprType expr >>= notCases li co
  Pos     li co expr  -> exprType expr >>= unaryOpNumCases li co "'+'"
  Neg     li co expr  -> exprType expr >>= unaryOpNumCases li co "'-'"
  Plus    li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co IntT RealT "'+'"
  Mul     li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co IntT RealT "'*'"
  Minus   li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co IntT RealT "'-'"
  RealDiv li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co RealT RealT "'/'"
  Div     li co e1 e2 -> exprsTypes e1 e2 >>= binOpIntCases li co "'div'"
  Mod     li co e1 e2 -> exprsTypes e1 e2 >>= binOpIntCases li co "'mod'"
  Or      li co e1 e2 -> exprsTypes e1 e2 >>= binOpBoolCases li co "'or'"
  And     li co e1 e2 -> exprsTypes e1 e2 >>= binOpBoolCases li co "'and'"
  Eq      li co e1 e2 -> exprsTypes e1 e2 >>= comparisonCases li co "'='"
  Diff    li co e1 e2 -> exprsTypes e1 e2 >>= comparisonCases li co "'<>'"
  Less    li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co BoolT BoolT "'<'"
  Greater li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co BoolT BoolT "'>'"
  Greq    li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co BoolT BoolT "'>='"
  Smeq    li co e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases li co BoolT BoolT "'<='"

exprsTypes exp1 exp2 = mapM exprType [exp1,exp2]

callType :: Id -> Exprs -> Sems Type
callType id exprs = searchCallableInSymTabs id >>= \case
  FuncDclr fs t -> formalsExprsMatch id fs exprs >> right t
  Func  fs t    -> formalsExprsMatch id fs exprs >> right t
  _             -> errAtId "Use of procedure where a return value is required: " id

formalsExprsMatch :: Id -> [Frml] -> Exprs -> Sems ()
formalsExprsMatch id fs exprs =
  mapM exprType exprs >>= formalsExprsTypesMatch 1 id (formalsToTypes fs)
