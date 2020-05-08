module SemErrors where

dangledGotoErr = "goto label declared but not used: "
forwardErr = "no implementation for forward declaration: "
errorend l c = " at line " ++ show l ++ ", column " ++ show c
dupLabDecErr = "Duplicate label declaration: "
parErr = "Parameter missmatch between " ++
         "forward and declaration for: "
dupErr = "Duplicate Variable: "
dupArgErr = "duplicate argument: " 
noResInFunErr = "Result not set for function: " 
funErr = "Function can't have a return type of array "
arrByValErr = "Can't pass array by value in: " 
arrayOfErr = "Can't use 'array of' at: " 
gotoErr = "Undeclared Label: "
callErr = "Undeclared function or procedure in call: "
nonBoolErr = "Non-boolean expression in " 
undefLabErr = "undefined label: " 
dupLabErr = "duplicate label: " 
strAssErr = "assignment to string" 
assTypeMisErr = "type mismatch in assignment" 
nonPointNewErr = "non-pointer in new statement" 
nonIntNewErr = "non-integer expression in new statement"
badPointNewErr = "bad pointer type in new expression" 
dispNonPointErr = "non-pointer in dispose statement"
dispNullPointErr = "disposing null pointer"
badPointDispErr = "bad pointer type in dispose expression"
callSemErr = "Wrong type of identifier in call: "
varErr = "Undeclared variable: "
retErr = "'return' in function argument"
indErr = "index not integer"
arrErr = "indexing something that is not an array"
pointErr = "dereferencing non-pointer"


