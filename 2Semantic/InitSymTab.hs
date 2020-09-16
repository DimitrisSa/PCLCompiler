module InitSymTab where
import Common as P hiding (void) 
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type as T
import LLVM.AST.AddrSpace
import SemsCodegen

initSymTab :: Sems ()
initSymTab = do
  printfDef
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
  "writeString" -> writeStringCodeGen
  _             -> return ()

writeStringCodeGen :: Sems ()
writeStringCodeGen = do 
  entry <- addBlock "entry"
  setBlock entry
  callVoid printf [ LocalReference (ptr i8) (UnName 0) ]
  retVoid

dummy :: String -> Id
dummy s = Id (0,0) s

printfDef :: Sems ()
printfDef = addGlobalDef functionDefaults {
    returnType = i32
  , name = toName "printf"
  , parameters = (
      [ Parameter (ptr i8) (UnName 0) [] ]
    , True
    )
  } 

