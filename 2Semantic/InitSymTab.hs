module InitSymTab where
import Common
import LLVM.AST
import LLVM.AST.Global
import LLVM.AST.Type
import LLVM.AST.AddrSpace
import Data.Word
import Data.String
import Data.List
import Data.Function
import Data.String.Transform


initSymTab :: Sems ()
initSymTab = do
  printfDef
  insertProcToSymTab "writeInteger" [(Value,[dummy "n"],IntT)]
  insertProcToSymTab "writeBoolean" [(Value,[dummy "b"],BoolT)]
  insertProcToSymTab "writeChar" [(Value,[dummy "c"],CharT)]
  insertProcToSymTab "writeReal" [(Value,[dummy "r"],RealT)]
  insertProcToSymTab "writeString" [(Reference, [dummy "s"],Array NoSize CharT)]
  insertFuncToSymTab "readInteger" [] IntT
  insertFuncToSymTab "readBoolean" [] BoolT
  insertFuncToSymTab "readChar" [] CharT
  insertFuncToSymTab "readReal" [] RealT
  insertProcToSymTab "readString" [(Value,[dummy "size"],IntT)
                                  ,(Reference,[dummy "s"]
                                  ,Array NoSize CharT)
                                  ]
  insertFuncToSymTab "abs" [(Value,[dummy "n"],IntT)] IntT
  insertFuncToSymTab "fabs" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "sqrt" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "sin" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "cos" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "tan" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "arctan" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "exp" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "ln" [(Value,[dummy "r"],RealT)] RealT
  insertFuncToSymTab "pi" [] RealT
  insertFuncToSymTab "trunc" [(Value,[dummy "r"],RealT)] IntT
  insertFuncToSymTab "round" [(Value,[dummy "r"],RealT)] IntT
  insertFuncToSymTab "ord" [(Value,[dummy "r"],CharT)] IntT
  insertFuncToSymTab "chr" [(Value,[dummy "r"],IntT)] CharT

insertProcToSymTab :: String -> [Frml] -> Sems ()
insertProcToSymTab name myArgs = do
  insToCallableMap (dummy name) (Proc myArgs)

insertFuncToSymTab :: String -> [Frml] -> Common.Type -> Sems ()
insertFuncToSymTab name myArgs myType = do
  insToCallableMap (dummy name) (Func myArgs myType)

dummy :: String -> Id
dummy s = Id (0,0) s

printfDef :: Sems ()
printfDef = addGlobalDef $ functionDefaults {
    returnType = i32
  , name = Name $ toShortByteString "printf"
  , parameters = (
      [ Parameter (PointerType i8 (AddrSpace 0)) (UnName 0) [] ]
    , True
    )
  } 

