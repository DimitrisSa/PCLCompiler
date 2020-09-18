module InitSymTab where
import Common as P hiding (void) 
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
import LLVM.AST.AddrSpace
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.IntegerPredicate as I
import Data.Char (ord)
import Data.Word
import SemsCodegen

initSymTab :: Sems ()
initSymTab = do
  printfDef
  scanfDef
  insertProcToSymTabAndDefs "writeInteger" [(Value,[dummy "n"],IntT)]
  insertProcToSymTabAndDefs "writeBoolean" [(Value,[dummy "b"],BoolT)]
  insertProcToSymTabAndDefs "writeChar" [(Value,[dummy "c"],CharT)]
  insertProcToSymTabAndDefs "writeReal" [(Value,[dummy "r"],RealT)]
  insertProcToSymTabAndDefs "writeString" [(Reference, [dummy "s"],Array NoSize CharT)]
  insertProcToSymTabAndDefs "readString" [(Value,[dummy "size"],IntT)
                                         ,(Reference,[dummy "s"],Array NoSize CharT)
                                         ]
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

insertProcToSymTabAndDefs :: String -> [Frml] -> Sems ()
insertProcToSymTabAndDefs name frmls = do
  insToCallableMap (dummy name) (Proc frmls)
  defineFun name T.void frmls (codegenFromName name)

insertFuncToSymTabAndDefs :: String -> [Frml] -> P.Type -> Sems ()
insertFuncToSymTabAndDefs name frmls retty = do
  insToCallableMap (dummy name) (Func frmls retty)
  defineFun name (toTType retty) frmls (codegenFromName name)

codegenFromName = \case
  "writeInteger" -> writeCodeGen ".intStr" 'd'
  "writeBoolean" -> writeBooleanCodeGen
  "writeChar"    -> writeCodeGen ".charStr" 'c'
  "writeReal"    -> writeCodeGen ".realStr" 'f'
  "writeString"  -> writeStringCodeGen
  "readString"   -> readStringCodeGen
  _              -> return ()

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

writeCodeGen :: String -> Char -> Sems ()
writeCodeGen str char = do 
  addGlobalStr str 4 ['%',char,'\n','\0']
  entry <- addBlock "entry"
  setBlock entry
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 4 i8)) $ toName str) 0
  callVoid printf [str,LocalReference (typeFromChar char) (UnName 0)]
  retVoid

typeFromChar :: Char -> T.Type
typeFromChar = \case
  'c' -> i8
  'd' -> i16
  'f' -> double
  c   -> error $ "typeFromChar: invalid char " ++ [c]

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

readStringCodeGen :: Sems ()
readStringCodeGen = do 
  addGlobalStr "scanfStr" 3 "%c\0"

  fresh
  entry <- addBlock "entry"
  setBlock entry
  let intOp = LocalReference i16 (UnName 0)
  let strOp = LocalReference (ptr i8) (UnName 1)
  str <- getElemPtrInBounds (consGlobalRef (ptr (ArrayType 3 i8)) $ toName "scanfStr") 0

  while     <- addBlock "while"
  whileExit <- addBlock "while.exit"

  counter <- alloca i16
  store counter (toConsI16 0)
  intOpMinus1 <- sub intOp (toConsI16 1)
  cond <- icmp I.SLT (toConsI16 0) intOpMinus1 
  cbr cond while whileExit

  setBlock while
  counterVal <- load counter
  strOp' <- getElemPtrOp' strOp counterVal
  callVoid scanf [str,strOp']
  char <- load strOp'
  cond1 <- icmp I.NE char (cons $ toI8Cons '\n')
  counterVal' <- add counterVal (toConsI16 1)
  store counter counterVal'
  cond2 <- icmp I.SLT counterVal' intOpMinus1
  cond' <- andInstr cond1 cond2
  cbr cond' while whileExit

  setBlock whileExit
  counterVal'' <- load counter
  strOp'' <- getElemPtrOp' strOp counterVal''
  store strOp'' (cons $ toI8Cons '\0')
  retVoid

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

toI8Cons :: Char -> C.Constant
toI8Cons = ord >>> toInteger >>> C.Int 8

dummy :: String -> Id
dummy s = Id (0,0) s
