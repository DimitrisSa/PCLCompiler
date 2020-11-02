module RemoveDoubles where
import Prelude hiding (lookup)
import Parser 
import Data.Map
import Control.Monad.Trans.Either
import Control.Monad.State 

type InputMap = Map String String
type Unique = EitherT String (State ([InputMap],[Integer]))

errAtId :: String -> Id -> Unique a
errAtId err (Id posn str) = errPos posn $ err ++ str

errPos (li,co) err = left $ concat [show li,":",show co,": ",err] 

initUniqueState = ([empty],list)
list = [1,2..]

transformProgram :: Program -> Unique Program
transformProgram (P id bod) = do
  newbod <- transformBody bod
  return $ P id newbod

transformBody :: Body -> Unique Body
transformBody (Body locals stmts) = do
  newlocals <- transformLocals $ reverse locals
  newstmts <- transformStmts stmts
  return $ Body (reverse newlocals) newstmts

transformLocals :: [Local] -> Unique [Local]
transformLocals = mapM transformLocal

transformLocal :: Local -> Unique Local
transformLocal = \case
  VarsWithTypeList vwtl -> do
    a <- makeUnique vwtl
    return $ VarsWithTypeList a
  Labels ls             -> return $ Labels ls
  HeaderBody h b        -> do
    (table,list) <- get
    put (empty:table,list)
    h' <- transformHeader h
    b' <- transformBody b
    (_,list') <- get
    put (table,list')
    return $ HeaderBody h' b'
  Forward h             -> return $ Forward h

transformHeader :: Header -> Unique Header
transformHeader = \case 
  ProcHeader id frmls    -> return . ProcHeader id =<< mapM transformFrml frmls
  FuncHeader id frmls ty -> do
    frmls' <- mapM transformFrml frmls
    return $ FuncHeader id frmls' ty 

transformFrml :: Frml -> Unique Frml
transformFrml (pb,ids,ty) = do
  ids' <- finalUniques ids
  return (pb,ids',ty)

makeUnique :: [([Id],Type)] -> Unique [([Id],Type)]
makeUnique = \case
  ((ids,ty):ts) -> do
    a <- finalUniques ids
    b <- makeUnique ts
    return $ (a,ty):b
  [] -> return []

finalUniques :: [Id] -> Unique [Id]
finalUniques = mapM finalUnique

finalUnique :: Id -> Unique Id
finalUnique (Id pos str) = do
  (a:as,b:bs) <- get
  case lookup str a of
    Just _ -> errAtId "Duplicate variable: " (Id pos str)
    Nothing -> do
       put (insert str (str ++ "." ++ show b) a:as,bs)
       return $ Id pos (str ++ "." ++ show b)

transformStmts :: [Stmt] -> Unique [Stmt]
transformStmts = mapM transformStmt

transformStmt :: Stmt -> Unique Stmt
transformStmt = \case
  Empty                      -> return Empty
  Assignment posn lVal expr  -> do
    lVal' <- transformLVal lVal
    expr' <- transformExpr expr
    return $ Assignment posn lVal' expr'
  Block stmts                -> return . Block =<< transformStmts stmts
  CallS (id,exprs)           -> do
    exprs' <- mapM transformExpr exprs
    return $ CallS (id,exprs')
  IfThen posn e s            -> do
    e'  <- transformExpr e
    return . IfThen posn e' =<< transformStmt s
  IfThenElse posn e s1 s2    -> do
    e'  <- transformExpr e
    s1' <- transformStmt s1
    s2' <- transformStmt s2
    return $ IfThenElse posn e' s1' s2'
  While posn e stmt          ->  do
    e'  <- transformExpr e
    return . While posn e' =<< transformStmt stmt
  Label id stmt              -> return . Label id =<< transformStmt stmt
  GoTo id                    -> return $ GoTo id
  Return                     -> return $ Return
  New posn new lVal          -> do
    new' <- transformNew new
    lVal' <- transformLVal lVal
    return $ New posn new' lVal'
  Dispose posn disptype lVal -> return . Dispose posn disptype =<< transformLVal lVal

transformNew :: New -> Unique New
transformNew = \case
  NewNoExpr -> return NewNoExpr
  NewExpr e -> return . NewExpr =<< transformExpr e

transformExpr :: Expr -> Unique Expr
transformExpr = \case
  LVal lval -> return . LVal =<< transformLVal lval
  RVal rval -> return . RVal =<< transformRVal rval 

transformLVal :: LVal -> Unique LVal
transformLVal = \case
  IdL         (Id p str)     -> return . IdL . Id p =<< searchString str
  Result      posn           -> return $ Result posn
  StrLiteral  str            -> return $ StrLiteral str
  Indexing    posn lVal expr -> do
    lVal' <- transformLVal lVal
    expr' <- transformExpr expr
    return $ Indexing posn lVal' expr'
  Dereference posn expr      -> return . Dereference posn =<< transformExpr expr
  ParenL      lVal           -> return . ParenL =<< transformLVal lVal

searchString :: String -> Unique String
searchString id = do
  (maps,_) <- get
  return $ searchString' id maps

searchString' :: String -> [InputMap] -> String
searchString' id = \case
  st:sts -> case lookup id st of
    Just val -> val
    Nothing  -> searchString' id sts
  []     -> id

transformRVal :: RVal -> Unique RVal
transformRVal = \case
  IntR    int        -> return $ IntR int
  TrueR              -> return TrueR
  FalseR             -> return FalseR
  RealR   (w16,w64)  -> return $ RealR (w16,w64)  
  CharR   char       -> return $ CharR char       
  ParenR  rVal       -> return . ParenR =<< transformRVal rVal
  NilR               -> return $ NilR               
  CallR   (id,exprs) -> do
    exprs' <- mapM transformExpr exprs
    return $ CallR (id,exprs') 
  Papaki  lVal       -> return . Papaki =<< transformLVal lVal       
  Not     posn expr  -> return . Not posn =<< transformExpr expr  
  Pos     posn expr  -> return . Pos posn =<< transformExpr expr
  Neg     posn expr  -> return . Neg posn =<< transformExpr expr  
  Plus    posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Plus posn e1' e2'
  Mul     posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Mul posn e1' e2'
  Minus   posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Minus posn e1' e2'
  RealDiv posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ RealDiv posn e1' e2' 
  Div     posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Div posn e1' e2'
  Mod     posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Mod posn e1' e2'
  Or      posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Or posn e1' e2'
  And     posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ And posn e1' e2'
  Eq      posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Eq posn e1' e2'
  Diff    posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Diff posn e1' e2'
  Less    posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Less posn e1' e2'
  Greater posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Greater posn e1' e2'
  Greq    posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Greq posn e1' e2'
  Smeq    posn e1 e2 -> do
    e1' <- transformExpr e1
    e2' <- transformExpr e2
    return $ Smeq posn e1' e2'
