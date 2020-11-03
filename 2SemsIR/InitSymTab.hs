module InitSymTab where
import Prelude hiding (abs,acos,atan,log,EQ)
import LLVM.AST (Name(..),Operand(..))
import LLVM.AST.Global (parameters,name,returnType,initializer,alignment,type',isConstant
                       ,unnamedAddr,linkage,Parameter(..),functionDefaults,UnnamedAddr(..)
                       ,globalVariableDefaults)
import LLVM.AST.Float (SomeFloat(..))
import LLVM.AST.Linkage (Linkage(..))
import LLVM.AST.IntegerPredicate (IntegerPredicate(..))
import Data.Char (ord)
import Data.Word (Word64)
import Helpers (x8680Read)
import SemsCodegen (ret,phi,setBlock,br,printf,callVoid,cbr,add,icmp,call,strcmp
                   ,scanf,allocaNum,getElemPtrInBounds,addBlock,retVoid,cons,fpext
                   ,store,getElemPtrOp',load,sub,alloca,fresh,getBlock,acosl,fcmp,fsub
                   ,fptosi,sitofp,zext,truncTo,defineFun,atanl,logl,orInstr
                   ,fabsl,sqrtl,sinl,cosl,tanl,expl)
import LLVM.AST.Float as F (SomeFloat(..))
import Common as P hiding (void) 
import LLVM.AST.Type as T (Type,i1,i8,i16,i32,i64,ptr,x86_fp80,void,Type(..))
import qualified LLVM.AST.Constant as C (Constant(..))
import qualified LLVM.AST.FloatingPointPredicate as FP (FloatingPointPredicate(..))

initSymTab :: Sems ()
initSymTab = do
  addGlobalStr "scanfChar" 3 "%c\0"
  printfDef
  scanfDef
  acosDef
  atanDef
  logDef
  mathDefs
  strcmpDef
  freeDef
  mallocDef
  insertProcToSymTabAndDefs "writeInteger" [(Val,[dummy "n"],IntT)]
  insertProcToSymTabAndDefs "writeBoolean" [(Val,[dummy "b"],BoolT)]
  insertProcToSymTabAndDefs "writeChar" [(Val,[dummy "c"],CharT)]
  insertProcToSymTabAndDefs "writeReal" [(Val,[dummy "r"],RealT)]
  insertProcToSymTabAndDefs "writeString" [(Ref, [dummy "s"],Array NoSize CharT)]
  insertProcToSymTabAndDefs "readString" [(Val,[dummy "size"],IntT)
                                         ,(Ref,[dummy "s"],Array NoSize CharT)
                                         ]
  insertFuncToSymTabAndDefs "readInteger" [] IntT
  insertFuncToSymTabAndDefs "readBoolean" [] BoolT
  insertFuncToSymTabAndDefs "readChar" [] CharT
  insertFuncToSymTabAndDefs "readReal" [] RealT
  insertFuncToSymTabAndDefs "abs" [(Val,[dummy "n"],IntT)] IntT
  insertFuncToSymTabAndDefs "fabs" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "sqrt" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "sin" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "cos" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "tan" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "arctan" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "exp" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "ln" [(Val,[dummy "r"],RealT)] RealT
  insertFuncToSymTabAndDefs "pi" [] RealT
  insertFuncToSymTabAndDefs "trunc" [(Val,[dummy "r"],RealT)] IntT
  insertFuncToSymTabAndDefs "round" [(Val,[dummy "r"],RealT)] IntT
  insertFuncToSymTabAndDefs "ord" [(Val,[dummy "r"],CharT)] IntT
  insertFuncToSymTabAndDefs "chr" [(Val,[dummy "r"],IntT)] CharT
--getDefs >>= error . ("\n"++). concat . fmap
--  ((++"\n").show.(\(GlobalDefinition x)-> (name x,parameters x,returnType x)))

-- insert Procedures/Functions to the Symbol Table and the Module
insertProcToSymTabAndDefs :: String -> [Frml] -> Sems ()
insertProcToSymTabAndDefs name frmls = do
  insToCallableMap [] (dummy name) (Proc frmls) False
  defineFun [] [] (name ++ ".") void frmls (codegenFromName name)

insertFuncToSymTabAndDefs :: String -> [Frml] -> P.Type -> Sems ()
insertFuncToSymTabAndDefs name frmls retty = do
  insToCallableMap [] (dummy name) (Func frmls retty) False
  defineFun [] [] (name ++ ".") (toTType retty) frmls (codegenFromName name)

-- Get Code Generation Function from name
codegenFromName = \case
  "writeInteger" -> writeCodeGen ".intStr" "hi"
  "writeBoolean" -> writeBooleanCodeGen
  "writeChar"    -> writeCodeGen ".charStr" "c"
  "writeReal"    -> writeCodeGen ".realStr" "Lf"
  "writeString"  -> writeStringCodeGen
  "readString"   -> readStringCodeGen
  "readInteger"  -> readCodeGen ".scanInt" "hi"
  "readBoolean"  -> readBooleanCodeGen
  "readChar"     -> readCodeGen ".scanChar" "c"
  "readReal"     -> readCodeGen ".scanReal" "Lf"
  "abs"          -> absCodeGen
  "fabs"         -> mathCodeGen fabsl
  "sqrt"         -> mathCodeGen sqrtl
  "sin"          -> mathCodeGen sinl
  "cos"          -> mathCodeGen cosl
  "tan"          -> mathCodeGen tanl
  "exp"          -> mathCodeGen expl
  "arctan"       -> arctanCodeGen
  "ln"           -> lnCodeGen
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
  , linkage = Private
  , unnamedAddr = Just GlobalAddr
  , isConstant = True
  , LLVM.AST.Global.type' = ArrayType strLen i8 
  , LLVM.AST.Global.alignment = 1
  , initializer = Just $ C.Array i8 $ fmap toConsI8 $ strVal
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
  cond <- icmp SGE intIn $ toConsI16 0
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
  int <- fptosi $ LocalReference x86_fp80 (UnName 0)
  ret int

(w16,w64) = x8680Read "0.0"
zeroCons = cons $ C.Float $ X86_FP80 w16 w64

roundCodeGen :: Sems ()
roundCodeGen = do
  let arg = LocalReference x86_fp80 (UnName 0)
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
  cond1 <- fcmp FP.OLT arg $ cons $ C.Float $ F.X86_FP80 w16 w64
  cbr cond1 neg pos

  setBlock neg
  let (w16',w64') = x8680Read "0.5"
  let fp80_0_5 = cons $ C.Float $ F.X86_FP80 w16' w64'
  fp80_minus_0_5 <- fsub zeroCons fp80_0_5 
  cond2 <- fcmp FP.OGT diff fp80_minus_0_5 
  cbr cond2 negUp negDown

  setBlock negUp
  int1 <- add int $ toConsI16 0
  br exit

  setBlock negDown
  int2 <- add int $ toConsI16 (-1)
  br exit

  setBlock pos
  cond3 <- fcmp FP.OGE diff fp80_0_5
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
  let (w16_1,w64_1) = x8680Read "1.0"
  let oneCons = cons $ C.Float $ X86_FP80 w16_1 w64_1
  minusOne <- fsub zeroCons oneCons
  pi <- call acosl [minusOne]
  ret pi

writeCodeGen :: String -> String -> Sems ()
writeCodeGen str1 str2 = do 
  let len = fromIntegral $ 2 + length str2
  addGlobalStr str1 len $ "%" ++ str2 ++ "\0"
  entry <- addBlock "entry"
  setBlock entry
  str1 <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType len i8)) $ toName str1) 0
  callVoid printf [str1,LocalReference (typeFromStr str2) (UnName 0)]
  retVoid

typeFromStr :: String -> T.Type
typeFromStr = \case
  "c"  -> i8
  "hi" -> i16
  "Lf"  -> x86_fp80
  s    -> error $ "typeFromStr: invalid str: " ++ s

writeBooleanCodeGen :: Sems ()
writeBooleanCodeGen = do 
  addGlobalStr "true" 5 "true\0"
  addGlobalStr "false" 6 "false\0"
  entry <- addBlock "entry"
  setBlock entry
  ifthen <- addBlock "if.then"
  ifelse <- addBlock "if.else"
  ifexit <- addBlock "if.exit"

  cbr (LocalReference i1 (UnName 0)) ifthen ifelse

  setBlock ifthen
  trueStr <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 5 i8)) $ toName "true") 0
  br ifexit     
  ifthen <- getBlock

  setBlock ifelse
  falseStr <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 6 i8)) $ toName "false") 0
  br ifexit     
  ifelse <- getBlock

  setBlock ifexit
  str <- phi (ptr i8) [(trueStr,ifthen),(falseStr,ifelse)]
  
  callVoid printf [str]
  retVoid

mathCodeGen fun = do 
  entry <- addBlock "entry"
  setBlock entry
  call fun [ LocalReference x86_fp80 (UnName 0) ] >>= ret

arctanCodeGen :: Sems ()
arctanCodeGen = do 
  entry <- addBlock "entry"
  setBlock entry
  call atanl [ LocalReference x86_fp80 (UnName 0) ] >>= ret

lnCodeGen :: Sems ()
lnCodeGen = do 
  entry <- addBlock "entry"
  setBlock entry
  call logl [ LocalReference x86_fp80 (UnName 0) ] >>= ret

writeStringCodeGen :: Sems ()
writeStringCodeGen = do 
  entry <- addBlock "entry"
  setBlock entry
  strOp <- load $ LocalReference (ptr $ ptr i8) (UnName 0)
  callVoid printf [ strOp ]
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
  ret op

eatSpace opPtr = do
  while1    <- addBlock "while"
  whileExit <- addBlock "while.exit"

  op <- load opPtr
  cond <- opIsSpace op
  cbr cond while1 whileExit

  setBlock while1
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 3 i8)) $ toName "scanfChar") 0
  callVoid scanf [str,opPtr] -- eat the space
  op <- load opPtr
  cond <- opIsSpace op
  cbr cond while1 whileExit

  setBlock whileExit

opIsSpace op = do
  cond1 <- icmp EQ (toConsI8Op '\n') op
  cond2 <- icmp EQ (toConsI8Op '\t') op
  cond3 <- icmp EQ (toConsI8Op ' ') op
  cond4 <- orInstr cond1 cond2
  orInstr cond3 cond4

readStringCodeGen :: Sems ()
readStringCodeGen = do 

  fresh
  entry <- addBlock "entry"
  setBlock entry
  let intOp = LocalReference i16 (UnName 0)
  let strOp = LocalReference (ptr $ ptr i8) (UnName 1)
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 3 i8)) $ toName "scanfChar") 0

  while1    <- addBlock "while1"
  while2    <- addBlock "while2"
  whileExit <- addBlock "while.exit"

  --eatSpace strOp
  strOp <- load strOp

  counter <- alloca i16
  store counter (toConsI16 0)
  intOpMinus1 <- sub intOp (toConsI16 1)
  cond <- icmp SLT (toConsI16 0) intOpMinus1 
  cbr cond while1 whileExit

  setBlock while1
  counterVal <- load counter
  strOp' <- getElemPtrOp' strOp counterVal
  callVoid scanf [str,strOp']
  char <- load strOp'
  cond1 <- icmp NE char (cons $ toConsI8 '\n')
  cbr cond1 while2 whileExit

  setBlock while2
  counterVal' <- add counterVal (toConsI16 1)
  store counter counterVal'
  cond2 <- icmp SLT counterVal' intOpMinus1
  cbr cond2 while1 whileExit

  setBlock whileExit
  counterVal'' <- load counter
  strOp'' <- getElemPtrOp' strOp counterVal''
  store strOp'' (cons $ toConsI8 '\0')
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
  cond21 <- icmp EQ intTrue $ toConsI32 0
  true <- add (toConsI1 0) (toConsI1 1)
  cbr cond21 whileExit whileFalse

  setBlock whileFalse
  intFalse <- call strcmp [inputStartChar,readBoolFalse]
  cond22 <- icmp EQ intFalse $ toConsI32 0
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
    returnType = x86_fp80
  , name = toName "acosl"
  , parameters = (
      [ Parameter x86_fp80 (UnName 0) [] ]
    , False
    )
  } 

atanDef :: Sems ()
atanDef = addGlobalDef functionDefaults {
    returnType = x86_fp80
  , name = toName "atanl"
  , parameters = (
      [ Parameter x86_fp80 (UnName 0) [] ]
    , False
    )
  } 

logDef :: Sems ()
logDef = addGlobalDef functionDefaults {
    returnType = x86_fp80
  , name = toName "logl"
  , parameters = (
      [ Parameter x86_fp80 (UnName 0) [] ]
    , False
    )
  } 


mathDefs :: Sems ()
mathDefs = mapM_ mathDef ["fabsl","sqrtl","sinl","cosl","tanl","expl"] 

mathDef :: String -> Sems ()
mathDef name = addGlobalDef functionDefaults {
    returnType = x86_fp80
  , name = toName name
  , parameters = (
      [ Parameter x86_fp80 (UnName 0) [] ]
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
toConsI8 :: Char -> C.Constant
toConsI8 = ord >>> toInteger >>> C.Int 8

toConsI8Op :: Char -> Operand
toConsI8Op = toConsI8 >>> ConstantOperand

dummy :: String -> Id
dummy s = Id (0,0) s
