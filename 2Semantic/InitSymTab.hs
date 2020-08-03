module InitSymTab where
import Common

initSymTab :: Sems ()
initSymTab = do
  insertProcToSymTab "writeInteger" [(Value,[dummy "n"],Int')]
  insertProcToSymTab "writeBoolean" [(Value,[dummy "b"],Bool')]
  insertProcToSymTab "writeChar" [(Value,[dummy "c"],Char')]
  insertProcToSymTab "writeReal" [(Value,[dummy "r"],Real')]
  insertProcToSymTab "writeString" [(Reference, [dummy "s"],Array NoSize Char')]
  insertFuncToSymTab "readInteger" [] Int'
  insertFuncToSymTab "readBoolean" [] Bool'
  insertFuncToSymTab "readChar" [] Char'
  insertFuncToSymTab "readReal" [] Real'
  insertProcToSymTab "readString" [(Value,[dummy "size"],Int')
                                  ,(Reference,[dummy "s"]
                                  ,Array NoSize Char')
                                  ]
  insertFuncToSymTab "abs" [(Value,[dummy "n"],Int')] Int'
  insertFuncToSymTab "fabs" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "sqrt" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "sin" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "cos" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "tan" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "arctan" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "exp" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "ln" [(Value,[dummy "r"],Real')] Real'
  insertFuncToSymTab "pi" [] Real'
  insertFuncToSymTab "trunc" [(Value,[dummy "r"],Real')] Int'
  insertFuncToSymTab "round" [(Value,[dummy "r"],Real')] Int'
  insertFuncToSymTab "ord" [(Value,[dummy "r"],Char')] Int'
  insertFuncToSymTab "chr" [(Value,[dummy "r"],Int')] Char'

insertProcToSymTab :: String -> [Formal] -> Sems ()
insertProcToSymTab name myArgs = insToCallableMap (dummy name) (Proc myArgs)

insertFuncToSymTab :: String -> [Formal] -> Type -> Sems ()
insertFuncToSymTab name myArgs myType = insToCallableMap (dummy name) (Func myArgs myType)
