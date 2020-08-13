module InitSymTab where
import Common

initSymTab :: Sems ()
initSymTab = do
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
insertProcToSymTab name myArgs = insToCallableMap (dummy name) (Proc myArgs)

insertFuncToSymTab :: String -> [Frml] -> Type -> Sems ()
insertFuncToSymTab name myArgs myType = insToCallableMap (dummy name) (Func myArgs myType)
