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
  Assignment posn lVal expr  -> assignmentSems posn lVal expr
  Block stmts                 -> stmtsSems $ reverse stmts
  CallS (id,exprs)            -> callSems id $ reverse exprs
  IfThen posn e s            -> exprType e >>= boolCases posn "if-then" >> stmtSems s
  IfThenElse posn e s1 s2    -> exprType e >>= boolCases posn "if-then-else" >>
                                 mapM_ stmtSems [s1,s2]
  While posn e stmt          -> exprType e >>= boolCases posn "while" >> stmtSems stmt
  Label lab stmt              -> lookupInLabelMap lab >>= labelCases lab >> stmtSems stmt
  GoTo lab                    -> lookupInLabelMap lab >>= goToCases lab
  Return                      -> return ()
  New posn new lVal          -> newSems posn new lVal
  Dispose posn disptype lVal -> disposeSems posn disptype lVal

callSems :: Id -> Exprs -> Sems ()
callSems id exprs = searchCallableInSymTabs id >>= \case
  ProcDclr as -> formalsExprsMatch id as exprs
  Proc  as    -> formalsExprsMatch id as exprs
  _           -> errAtId "Use of function in call statement: " id

assignmentSems :: (Int,Int) -> LVal -> Expr -> Sems ()
assignmentSems posn = \case
  StrLiteral str -> \_ -> errPos posn $ "Assignment to string literal: " ++ str
  lVal           -> lValExprTypes lVal >=> notStrLiteralSems posn

newSems :: (Int,Int) -> New -> LVal -> Sems ()
newSems posn = \case
  NewNoExpr -> lValType >=> newNoExprSems posn
  NewExpr e -> exprLValTypes e >=> newExprSems posn

disposeSems :: (Int,Int) -> DispType -> LVal -> Sems ()
disposeSems posn = \case
  Without -> lValType >=> dispWithoutSems posn
  With    -> lValType >=> dispWithSems posn

exprType :: Expr -> Sems Type
exprType = \case
  LVal lval -> lValType lval
  RVal rval -> rValType rval

lValType :: LVal -> Sems Type
lValType = \case
  IdL id                   -> searchVarInSymTabs id
  Result posn             -> resultType posn
  StrLiteral str           -> right $ Array (Size $ length str + 1) CharT
  Indexing posn lVal expr -> lValExprTypes lVal expr >>= indexingCases posn
  Dereference posn expr   -> exprType expr >>= dereferenceCases posn
  ParenL lVal              -> lValType lVal

exprLValTypes expr lVal = exprType expr >>= \et -> lValType lVal >>= \lt -> return (et,lt)

lValExprTypes lVal expr = lValType lVal >>= \lt -> exprType expr >>= \et -> return (lt,et)

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
  Papaki  lVal        -> lValType lVal >>= Pointer >>> right
  Not     posn expr  -> exprType expr >>= notCases posn
  Pos     posn expr  -> exprType expr >>= unaryOpNumCases posn "'+'"
  Neg     posn expr  -> exprType expr >>= unaryOpNumCases posn "'-'"
  Plus    posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn IntT RealT "'+'"
  Mul     posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn IntT RealT "'*'"
  Minus   posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn IntT RealT "'-'"
  RealDiv posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn RealT RealT "'/'"
  Div     posn e1 e2 -> exprsTypes e1 e2 >>= binOpIntCases posn "'div'"
  Mod     posn e1 e2 -> exprsTypes e1 e2 >>= binOpIntCases posn "'mod'"
  Or      posn e1 e2 -> exprsTypes e1 e2 >>= binOpBoolCases posn "'or'"
  And     posn e1 e2 -> exprsTypes e1 e2 >>= binOpBoolCases posn "'and'"
  Eq      posn e1 e2 -> exprsTypes e1 e2 >>= comparisonCases posn "'='"
  Diff    posn e1 e2 -> exprsTypes e1 e2 >>= comparisonCases posn "'<>'"
  Less    posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn BoolT BoolT "'<'"
  Greater posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn BoolT BoolT "'>'"
  Greq    posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn BoolT BoolT "'>='"
  Smeq    posn e1 e2 -> exprsTypes e1 e2 >>= binOpNumCases posn BoolT BoolT "'<='"

exprsTypes exp1 exp2 = mapM exprType [exp1,exp2]

callType :: Id -> Exprs -> Sems Type
callType id exprs = searchCallableInSymTabs id >>= \case
  FuncDclr fs t -> formalsExprsMatch id fs exprs >> right t
  Func  fs t    -> formalsExprsMatch id fs exprs >> right t
  _             -> errAtId "Use of procedure where a return value is required: " id

formalsExprsMatch :: Id -> [Frml] -> Exprs -> Sems ()
formalsExprsMatch id fs exprs =
  mapM exprType exprs >>= formalsExprsTypesMatch 1 id (formalsToTypes fs)
