module Main where
import Prelude hiding (lookup)
import Control.Monad.Trans.Either
import System.IO
import System.Exit
import Data.Function
import Common hiding (map)
import InitSymTab (initSymTab)
import VarsWithTypeListSems (varsWithTypeListSems)
import InsToSymTabLabels (insToSymTabLabels)
import ForwardSems (forwardSems)
import CheckUndefDeclarationSems (checkUndefDeclarationSems)
import CheckUnusedLabels (checkUnusedLabels)
import HeaderParentSems (headerParentSems)
import HeaderChildSems (headerChildSems)
import LValTypes
import RValTypesCases
import CheckResult (checkResult)

-- same name of fun inside of other fun?

main :: IO ()
main = sems

sems :: IO ()
sems = getContents >>= parser >>> parserErrOrAstSems

parserErrOrAstSems :: Either Error Program -> IO ()
parserErrOrAstSems = \case 
  Left e -> die e
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
bodySems (Body locals stmts) = do
  localsSems $ reverse locals
  stmtsSems $ reverse stmts
  checkUnusedLabels

localsSems :: [Local] -> Sems ()
localsSems locals = mapM_ localSems locals >> checkUndefDeclarationSems

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
  Empty                             -> return ()
  Assignment li co lVal expr        -> equalSems li co expr lVal
  Block stmts                       -> stmtsSems $ reverse stmts
  CallS (id,exprs)                  -> callSems id $ reverse exprs
  IfThen  li co  expr stmt          -> ifThenSems li co expr stmt
  IfThenElse li co expr stmt1 stmt2 -> ifThenElseSems li co expr stmt1 stmt2
  While li co expr stmt             -> whileSems li co expr stmt
  Label label stmt                  -> checkDuplicateUndefined label >> stmtSems stmt
  GoTo label                        -> checkLabelExists label
  Return                            -> return ()
  New li co new lVal                -> newSems li co new lVal
  Dispose li co disptype lVal       -> disposeSems li co disptype lVal

ifThenSems :: Int -> Int -> Expr -> Stmt -> Sems ()
ifThenSems li co expr stmt = checkBoolExpr expr (errPos li co ++ "if-then") (stmtSems stmt)

ifThenElseSems :: Int -> Int -> Expr -> Stmt -> Stmt -> Sems ()
ifThenElseSems li co expr s1 s2 =
  checkBoolExpr expr (errPos li co ++ "if-then-else") (stmtSems s1 >> stmtSems s2)

whileSems :: Int -> Int -> Expr -> Stmt -> Sems ()
whileSems li co expr stmt = 
  checkBoolExpr expr (errPos li co ++ "while") (stmtSems stmt)

checkBoolExpr expr stmtDesc action = exprType expr >>= \case
  BoolT -> action
  _     -> left $ nonBoolErr ++ stmtDesc

callSems :: Id -> Exprs -> Sems ()
callSems id exprs =
  get >>= snd >>> searchCallableInSymTabs id (errAtId callErr id) >>= \case
    ProcDeclaration as -> formalsExprsMatch id as exprs
    Proc  as           -> formalsExprsMatch id as exprs
    _                  -> errAtId callSemErr id

equalSems :: Int -> Int -> Expr -> LVal -> Sems ()
equalSems li co expr = \case
  StrLiteral str -> left $ errPos li co ++ strAssignmentErr ++ str
  lVal           -> notStrLiteralEqualSems li co lVal expr

notStrLiteralEqualSems li co lVal expr = do
  lt <- lValType lVal
  et <- exprType expr
  symbatos' lt et $ errPos li co ++ assTypeMisErr

checkLabelExists :: Id -> Sems ()
checkLabelExists id = lookupInLabelMap id >>= \case
  Nothing -> errAtId undefLabErr id
  _       -> return ()

checkDuplicateUndefined :: Id -> Sems ()
checkDuplicateUndefined id = lookupInLabelMap id >>= \case
  Just False -> insToLabelMap id True
  Just True  -> errAtId dupLabErr id
  Nothing    -> errAtId undefLabErr id

checkpointer :: LVal -> Error -> Sems Type
checkpointer lVal err = lValType lVal >>= \case
  Pointer t -> return t
  _         -> left err

newSems :: Int -> Int -> New -> LVal -> Sems ()
newSems li co new lVal = do
  insToNewMap lVal ()
  t <- checkpointer lVal $ errPos li co ++ nonPointNewErr
  case (new,checkFullType t) of
    (NewEmpty,True)   -> return ()
    (NewExpr e,False) -> exprType e >>= \case
      IntT -> return ()
      _    -> left $ errPos li co ++ nonIntNewErr
    _ -> left $ errPos li co ++ badPointNewErr

disposeSems :: Int -> Int -> DispType -> LVal -> Sems ()
disposeSems li co disptype lVal = do
  (e,st:sts) <- get
  newnm <- deleteNewMap lVal (newMap st) $ errPos li co ++ dispNullPointErr
  put $ (e,st:sts)
  t <- checkpointer lVal $ errPos li co ++ dispNonPointErr
  case (disptype,checkFullType t) of
    (With,False)   -> return ()
    (Without,True) -> return ()
    _ -> left $ errPos li co ++ badPointDispErr

deleteNewMap :: LVal -> NewMap -> String -> Sems NewMap
deleteNewMap l nm errmsg = case lookup l nm of
  Nothing -> left errmsg
  _       -> right $ delete l nm

errorAtArg err i (Id str li co) = errPos li co ++ err i str

--exprstart
exprType :: Expr -> Sems Type
exprType = \case
  LVal lval -> lValType lval
  RVal rval -> rValType rval

--lstart
lValType :: LVal -> Sems Type
lValType = \case
  IdL id                   -> idType id
  Result li co             -> resultType li co
  StrLiteral str           -> right $ Array (Size $ length str + 1) CharT
  Indexing li co lVal expr -> exprLValTypes expr lVal >>= indexingCases li co
  Dereference li co expr   -> exprType expr >>= dereferenceCases li co
  ParenL lVal              -> lValType lVal

exprLValTypes expr lVal =
  exprType expr >>= \etype -> lValType lVal >>= \ltype -> return (etype,ltype)

--rstart
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
callType id exprs = 
  get >>= snd >>> searchCallableInSymTabs id (errAtId callErr id) >>= \case
    FuncDeclaration fs t -> formalsExprsMatch id fs exprs >> right t
    Func  fs t           -> formalsExprsMatch id fs exprs >> right t
    _                    -> errAtId callSemErr id

formalsExprsMatch :: Id -> [Formal] -> Exprs -> Sems ()
formalsExprsMatch id fs exprs =
  mapM exprType exprs >>= formalsExprsTypesMatch 1 id (formalsToTypes fs)

formalsExprsTypesMatch :: Int -> Id -> [(PassBy,Type)] -> [Type] -> Sems ()
formalsExprsTypesMatch i id t1s t2s = case (t1s,t2s) of
  ((Value,t1):t1s,t2:t2s)     -> formalExprTypeMatch i id t1 t2 t1s t2s
  ((Reference,t1):t1s,t2:t2s) -> formalExprTypeMatch i id (Pointer t1) (Pointer t2) t1s t2s
  ([],[])                     -> return ()
  _                           -> errAtId argsExprsErr id

formalExprTypeMatch i id t1 t2 t1s t2s = do
  symbatos' t1 t2 $ errorAtArg badArgErr i id 
  formalsExprsTypesMatch (i+1) id t1s t2s
