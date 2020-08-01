module SemErrs where
 
unusedLabelErr = "label declared but not used: "
undefinedDeclarationErr = "no definition for declaration: "
errorPosition l c = " at line " ++ show l ++ ", column " ++ show c
duplicateLabelDeclarationErr = "Duplicate label declaration: "
parErr = "Parameter missmatch between " ++
         "forward and declaration for: "
duplicateVariableErr = "Duplicate Variable: "
dupplicateCallableErr = "Duplicate Function/Procedure name: "
dupArgErr = "duplicate argument: " 
noResInFunErr = "Result not set for function: " 
funErr = "Function can't have a return type of array "
arrByValErr = "Can't pass array by value in: " 
arrayOfDeclarationErr = "Can't declare 'array of': " 
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
resultNoFunErr = "Can only use result in a function call "  
nonNumAfErr = "non-number expression after " 
nonNumBefErr = "non-number expression before "
nonIntAfErr = "non-integer expression after "
nonIntBefErr = "non-integer expression before "
nonBoolAfErr = "non-boolean expression after "
nonBoolBefErr = "non-boolean expression before "
mismTypesErr = "mismatched types at "
argsExprsErr = "Wrong number of args for: "
typeExprsErr = "Type mismatch of args for: "
badArgErr i id = concat ["Type mismatch at argument ",show i,
                         " in call of: ", id]
refErr i id = concat
  ["Argument ",show i, " in call of \"",
   id,"\" cannot be passed by reference"]
