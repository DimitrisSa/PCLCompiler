module SemsErrs where
import SemsTypes 
import Parser
import Control.Monad.Trans.Either
 
unusedLabelErr = "label declared but not used: "
undefinedDeclarationErr = "no definition for declaration: "
duplicateLabelDeclarationErr = "Duplicate label declaration: "
paramenterTypeMismatchErr = "Parameter type missmatch between"++
                            " declaration and definition for: "
resultTypeMismatchErr = "Result type missmatch between declaration and definition for: "
duplicateVariableErr = "Duplicate Variable: "
duplicateCallableErr = "Duplicate Function/Procedure name: "
duplicateArgumentErr = "Duplicate Argument: " 
noResInFunErr = "Result not set for function: " 
funcResTypeErr = "Function can't have a return type of array "
arrByValErr = "Can't pass array by value in: " 
arrayOfDeclarationErr = "Can't declare 'array of': " 
gotoErr = "Undeclared Label: "
callErr = "Undeclared function or procedure in call: "
nonBoolErr = "Non-boolean expression in " 
undefLabErr = "undefined label: " 
dupLabErr = "duplicate label: " 
strAssignmentErr = "assignment to string literal: " 
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

badArgErr i id = concat ["Type mismatch at argument ",show i, " in call of: ", id]
refErr i id = concat ["Argument ",show i, " in call of \""
                     ,id,"\" cannot be passed by reference"]

errAtId :: String -> Id -> Sems a
errAtId err (Id str li co) = left $ concat [errPos li co,err,str]

errPos :: Int -> Int -> String
errPos li co = show li ++ ":" ++ show co ++ ": "
