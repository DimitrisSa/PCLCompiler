module InitSymTab where
import Prelude hiding (abs,acos)
import Common as P hiding (void) 
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
import LLVM.AST.AddrSpace
import LLVM.AST.Float
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.IntegerPredicate as I
import qualified LLVM.AST.FloatingPointPredicate as FP
import Data.Char (ord)
import Data.Word
import SemsCodegen

initSymTab :: Sems ()
initSymTab = do
  addGlobalStr "scanfChar" 3 "%c\0"
  printfDef
  scanfDef
  acosDef
  strcmpDef
  freeDef
  mallocDef
  insertProcToSymTabAndDefs "writeInteger" [(Value,[dummy "n"],IntT)]
  insertProcToSymTabAndDefs "writeBoolean" [(Value,[dummy "b"],BoolT)]
  insertProcToSymTabAndDefs "writeChar" [(Value,[dummy "c"],CharT)]
  insertProcToSymTabAndDefs "writeReal" [(Value,[dummy "r"],RealT)]
  insertProcToSymTabAndDefs "writeString" [(Reference, [dummy "s"],Array NoSize CharT)]
  --insertProcToSymTabAndDefs "readString" [(Value,[dummy "size"],IntT)
  --                                       ,(Reference,[dummy "s"],Array NoSize CharT)
  --                                       ]
  insertFuncToSymTabAndDefs "readInteger" [] IntT
  insertFuncToSymTabAndDefs "readBoolean" [] BoolT
  insertFuncToSymTabAndDefs "readChar" [] CharT
  insertFuncToSymTabAndDefs "readReal" [] RealT
  insertFuncToSymTabAndDefs "abs" [(Value,[dummy "n"],IntT)] IntT
  insertFuncToSymTabAndDefs "fabs" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "sqrt" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "sin" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "cos" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "tan" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "arctan" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "exp" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "ln" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "pi" [] RealT
  insertFuncToSymTabAndDefs "trunc" [(Value,[dummy "r"],RealT)] IntT
  insertFuncToSymTabAndDefs "round" [(Value,[dummy "r"],RealT)] IntT
  insertFuncToSymTabAndDefs "ord" [(Value,[dummy "r"],CharT)] IntT
  insertFuncToSymTabAndDefs "chr" [(Value,[dummy "r"],IntT)] CharT
--getDefs >>= error . ("\n"++). concat . fmap
--  ((++"\n").show.(\(GlobalDefinition x)-> (name x,parameters x,returnType x)))

-- insert Procedures/Functions to the Symbol Table and the Module
insertProcToSymTabAndDefs :: String -> [Frml] -> Sems ()
insertProcToSymTabAndDefs name frmls = do
  insToCallableMap (dummy name) (Proc frmls)
  defineFun name void frmls (codegenFromName name)

insertFuncToSymTabAndDefs :: String -> [Frml] -> P.Type -> Sems ()
insertFuncToSymTabAndDefs name frmls retty = do
  insToCallableMap (dummy name) (Func frmls retty)
  defineFun name (toTType retty) frmls (codegenFromName name)

-- Get Code Generation Function from name
codegenFromName = \case
  "writeInteger" -> writeCodeGen ".intStr" "hi"
  "writeBoolean" -> writeBooleanCodeGen
  "writeChar"    -> writeCodeGen ".charStr" "c"
  "writeReal"    -> writeCodeGen ".realStr" "lf"
  "writeString"  -> writeStringCodeGen
  --"readString"   -> readStringCodeGen
  "readInteger"  -> readCodeGen ".scanInt" "hi"
  "readBoolean"  -> readBooleanCodeGen
  "readChar"     -> readCodeGen ".scanChar" "c"
  "readReal"     -> readCodeGen ".scanReal" "lf"
  "abs"          -> absCodeGen
  "pi"           -> piCodeGen
  "trunc"        -> truncCodeGen
  "round"        -> roundCodeGen
  "ord"          -> ordCodeGen
  "chr"          -> chrCodeGen
  _              -> return ()

-- Add Global String Variable and initialize it
addGlobalStr :: String -> Word64 -> String -> Sems ()
addGlobalStr strName strLen strVal =
  addGlobalDef globalVariableDefaults {
    name = toName strName
  , linkage = L.Private
  , unnamedAddr = Just GlobalAddr
  , isConstant = True
  , LLVM.AST.Global.type' = ArrayType strLen i8 
  , LLVM.AST.Global.alignment = 1
  , initializer = Just $ C.Array i8 $ fmap toI8Cons $ strVal
  }

-- Code Generaton Functions
absCodeGen :: Sems ()
absCodeGen = do
  let intIn = LocalReference i16 (UnName 0)
  entry <- addBlock "entry"
  pos   <- addBlock "pos"
  neg   <- addBlock "neg"
  exit  <- addBlock "exit"

  setBlock entry
  cond <- icmp I.SGE intIn $ toConsI16 0
  cbr cond pos neg
  
  setBlock pos
  int1 <- add intIn $ toConsI16 0
  br exit

  setBlock neg
  int2 <- sub (toConsI16 0) intIn
  br exit

  setBlock exit
  intOut <- phi i16 [(int1,pos),(int2,neg)]
  ret intOut

chrCodeGen :: Sems ()
chrCodeGen = do
  entry <- addBlock "entry"
  setBlock entry
  int <- truncTo $ LocalReference i16 (UnName 0)
  ret int

ordCodeGen :: Sems ()
ordCodeGen = do
  entry <- addBlock "entry"
  setBlock entry
  int <- zext $ LocalReference i8 (UnName 0)
  ret int

truncCodeGen :: Sems ()
truncCodeGen = do
  entry <- addBlock "entry"
  setBlock entry
  int <- fptosi $ LocalReference double (UnName 0)
  ret int

roundCodeGen :: Sems ()
roundCodeGen = do
  let arg = LocalReference double (UnName 0)
  entry   <- addBlock "entry"
  pos     <- addBlock "pos"
  posUp   <- addBlock "posUp"
  posDown <- addBlock "posDown"
  neg     <- addBlock "neg"
  negUp   <- addBlock "negUp"
  negDown <- addBlock "negDown"
  exit    <- addBlock "exit"

  setBlock entry
  int <- fptosi arg
  intDouble <- sitofp int
  diff <- fsub arg intDouble
  cond1 <- fcmp FP.OLT arg $ cons $ C.Float $ Double 0
  cbr cond1 neg pos

  setBlock neg
  cond2 <- fcmp FP.OGT diff $ cons $ C.Float $ Double (-0.5)
  cbr cond2 negUp negDown

  setBlock negUp
  int1 <- add int $ toConsI16 0
  br exit

  setBlock negDown
  int2 <- add int $ toConsI16 (-1)
  br exit

  setBlock pos
  cond3 <- fcmp FP.OGE diff $ cons $ C.Float $ Double 0.5
  cbr cond3 posUp posDown

  setBlock posUp
  int3 <- add int $ toConsI16 1
  br exit

  setBlock posDown
  int4 <- add int $ toConsI16 0
  br exit

  setBlock exit
  int' <- phi i16 [(int1,negUp),(int2,negDown),(int3,posUp),(int4,posDown)]
  ret int'

piCodeGen :: Sems ()
piCodeGen = do
  entry <- addBlock "entry"
  setBlock entry
  pi <- call acos [cons $ C.Float $ Double (-1)]
  ret pi

writeCodeGen :: String -> String -> Sems ()
writeCodeGen str1 str2 = do 
  let len = fromIntegral $ 3 + length str2
  addGlobalStr str1 len $ "%" ++ str2 ++ "\n\0"
  entry <- addBlock "entry"
  setBlock entry
  str1 <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType len i8)) $ toName str1) 0
  callVoid printf [str1,LocalReference (typeFromStr str2) (UnName 0)]
  retVoid

typeFromStr :: String -> T.Type
typeFromStr = \case
  "c"  -> i8
  "hi" -> i16
  "lf"  -> double
  s    -> error $ "typeFromStr: invalid str: " ++ s

writeBooleanCodeGen :: Sems ()
writeBooleanCodeGen = do 
  addGlobalStr "true" 6 "true\n\0"
  addGlobalStr "false" 7 "false\n\0"
  entry <- addBlock "entry"
  setBlock entry
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cbr (LocalReference i1 (UnName 0)) ifthen ifelse

  setBlock ifthen
  trueStr <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 6 i8)) $ toName "true") 0
  br ifexit     
  ifthen <- getBlock

  setBlock ifelse
  falseStr <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 7 i8)) $ toName "false") 0
  br ifexit     
  ifelse <- getBlock

  setBlock ifexit
  str <- phi (ptr i8) [(trueStr,ifthen),(falseStr,ifelse)]
  
  callVoid printf [str]
  retVoid

writeStringCodeGen :: Sems ()
writeStringCodeGen = do 
  entry <- addBlock "entry"
  setBlock entry
  callVoid printf [ LocalReference (ptr i8) (UnName 0) ]
  retVoid

readCodeGen :: String -> String -> Sems ()
readCodeGen str1 str2 = do 
  let len = fromIntegral $ 2 + length str2
  addGlobalStr str1 len $ "%" ++ str2 ++ "\0"
  entry <- addBlock "entry"
  setBlock entry
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType len i8)) $ toName str1) 0
  opPtr <- alloca $ typeFromStr str2
  callVoid scanf [str,opPtr]
  op <- load opPtr
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 3 i8)) $ toName "scanfChar") 0
  charPtr <- alloca i8
  callVoid scanf [str,charPtr] -- eat the newline
  ret op

readStringCodeGen :: Sems ()
readStringCodeGen = do 

  fresh
  entry <- addBlock "entry"
  setBlock entry
  let intOp = LocalReference i16 (UnName 0)
  let strOp = LocalReference (ptr i8) (UnName 1)
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 3 i8)) $ toName "scanfChar") 0

  while1    <- addBlock "while1"
  while2    <- addBlock "while2"
  whileExit <- addBlock "while.exit"

  counter <- alloca i16
  store counter (toConsI16 0)
  intOpMinus1 <- sub intOp (toConsI16 1)
  cond <- icmp I.SLT (toConsI16 0) intOpMinus1 
  cbr cond while1 whileExit

  setBlock while1
  counterVal <- load counter
  strOp' <- getElemPtrOp' strOp counterVal
  callVoid scanf [str,strOp']
  char <- load strOp'
  cond1 <- icmp I.NE char (cons $ toI8Cons '\n')
  cbr cond1 while2 whileExit

  setBlock while2
  counterVal' <- add counterVal (toConsI16 1)
  store counter counterVal'
  cond2 <- icmp I.SLT counterVal' intOpMinus1
  cbr cond2 while1 whileExit

  setBlock whileExit
  counterVal'' <- load counter
  strOp'' <- getElemPtrOp' strOp counterVal''
  store strOp'' (cons $ toI8Cons '\0')
  retVoid

readBooleanCodeGen :: Sems ()
readBooleanCodeGen = do 
  addGlobalStr "scanfStr" 2 "%s"
  addGlobalStr "printStr" 4 "%s\n\0"
  addGlobalStr "notBool" 20 "Not a boolean value\0"
  addGlobalStr "readBoolTrue" 5 "true\0"
  addGlobalStr "readBoolFalse" 6 "false\0"

  entry      <- addBlock "entry"
  entry'     <- addBlock "entry."
  whileTrue  <- addBlock "while.true"
  whileFalse <- addBlock "while.false"
  whileError <- addBlock "while.error"
  whileExit  <- addBlock "while.exit"

  setBlock entry
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 2 i8)) $ toName "scanfStr") 0
  str' <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 4 i8)) $ toName "printStr") 0
  notBool <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 20 i8))
                                  $ toName "notBool") 0
  readBoolTrue <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 5 i8))
                                      $ toName "readBoolTrue") 0
  readBoolFalse <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 6 i8))
                                      $ toName "readBoolFalse") 0
  br entry'

  setBlock entry'
  inputStartChar <- allocaNum (toConsI16 100) i8
  callVoid scanf [str,inputStartChar]
  br whileTrue

  setBlock whileTrue
  intTrue <- call strcmp [inputStartChar,readBoolTrue]
  cond21 <- icmp I.EQ intTrue $ toConsI32 0
  true <- add (toConsI1 0) (toConsI1 1)
  cbr cond21 whileExit whileFalse

  setBlock whileFalse
  intFalse <- call strcmp [inputStartChar,readBoolFalse]
  cond22 <- icmp I.EQ intFalse $ toConsI32 0
  false <- add (toConsI1 0) (toConsI1 0)
  cbr cond22 whileExit whileError

  setBlock whileError
  callVoid printf [str',notBool]
  br entry'

  setBlock whileExit
  boolVal <- phi i1 [(true,whileTrue),(false,whileFalse)]
  ret boolVal

-- Built-in function declarations
printfDef :: Sems ()
printfDef = addGlobalDef functionDefaults {
    returnType = i32
  , name = toName "printf"
  , parameters = (
      [ Parameter (ptr i8) (UnName 0) [] ]
    , True
    )
  } 

scanfDef :: Sems ()
scanfDef = addGlobalDef functionDefaults {
    returnType = i32
  , name = toName "__isoc99_scanf"
  , parameters = (
      [ Parameter (ptr i8) (UnName 0) [] ]
    , True
    )
  } 

freeDef :: Sems ()
freeDef = addGlobalDef functionDefaults {
    returnType = void
  , name = toName "free"
  , parameters = (
      [ Parameter (ptr i8) (UnName 0) [] ]
    , False
    )
  } 

acosDef :: Sems ()
acosDef = addGlobalDef functionDefaults {
    returnType = double
  , name = toName "acos"
  , parameters = (
      [ Parameter double (UnName 0) [] ]
    , False
    )
  } 

strcmpDef :: Sems ()
strcmpDef = addGlobalDef functionDefaults {
    returnType = i32
  , name = toName "strcmp"
  , parameters = (
      [ Parameter (ptr i8) (UnName 0) []
      , Parameter (ptr i8) (UnName 1) [] ]
    , False
    )
  } 

mallocDef :: Sems ()
mallocDef = addGlobalDef functionDefaults {
    returnType = ptr i8 
  , name = toName "malloc"
  , parameters = (
      [ Parameter i64 (UnName 0) [] ]
    , False
    )
  } 

-- Helpers
toI8Cons :: Char -> C.Constant
toI8Cons = ord >>> toInteger >>> C.Int 8

dummy :: String -> Id
dummy s = Id (0,0) s
