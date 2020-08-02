module InitSymTab where
import Common

initSymTab :: Sems ()
initSymTab = do
  insertProcToSymTab "writeInteger" [(Value,[dummy "n"],Tint)]
  insertProcToSymTab "writeBoolean" [(Value,[dummy "b"],Tbool)]
  insertProcToSymTab "writeChar" [(Value,[dummy "c"],Tchar)]
  insertProcToSymTab "writeReal" [(Value,[dummy "r"],Treal)]
  insertProcToSymTab "writeString" [(Reference, [dummy "s"],ArrayT NoSize Tchar)]
  insertFuncToSymTab "readInteger" [] Tint
  insertFuncToSymTab "readBoolean" [] Tbool
  insertFuncToSymTab "readChar" [] Tchar
  insertFuncToSymTab "readReal" [] Treal
  insertProcToSymTab "readString" [(Value,[dummy "size"],Tint)
                                  ,(Reference,[dummy "s"]
                                  ,ArrayT NoSize Tchar)
                                  ]
  insertFuncToSymTab "abs" [(Value,[dummy "n"],Tint)] Tint
  insertFuncToSymTab "fabs" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "sqrt" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "sin" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "cos" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "tan" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "arctan" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "exp" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "ln" [(Value,[dummy "r"],Treal)] Treal
  insertFuncToSymTab "pi" [] Treal
  insertFuncToSymTab "trunc" [(Value,[dummy "r"],Treal)] Tint
  insertFuncToSymTab "round" [(Value,[dummy "r"],Treal)] Tint
  insertFuncToSymTab "ord" [(Value,[dummy "r"],Tchar)] Tint
  insertFuncToSymTab "chr" [(Value,[dummy "r"],Tint)] Tchar

insertProcToSymTab :: String -> [Formal] -> Sems ()
insertProcToSymTab name myArgs = insToCallableMap (dummy name) (Proc myArgs)

insertFuncToSymTab :: String -> [Formal] -> Type -> Sems ()
insertFuncToSymTab name myArgs myType = insToCallableMap (dummy name) (Func myArgs myType)
