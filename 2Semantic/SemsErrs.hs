module SemsErrs where
import Parser
import Control.Monad.Trans.Either
 
duplicateCallableErr = "Duplicate Function/Procedure name: "
funcResTypeErr = "Function can't have a return type of array "
arrByValErr = "Can't pass array by value in: " 
arrayOfDeclarationErr = "Can't declare 'array of': " 
callErr = "Undeclared function or procedure in call: "
dupLabErr = "duplicate label: " 
strAssignmentErr = "assignment to string literal: " 
dispNonPointErr = "non-pointer in dispose statement"
dispNullPointErr = "disposing null pointer"
badPointDispErr = "bad pointer type in dispose expression"
callSemErr = "Wrong type of identifier in call: "
varErr = "Undeclared variable: "
retErr = "'return' in function argument"
nonNumAfErr = "non-number expression after " 
nonNumBefErr = "non-number expression before "
nonIntAfErr = "non-integer expression after "
nonIntBefErr = "non-integer expression before "
nonBoolAfErr = "non-boolean expression after "
nonBoolBefErr = "non-boolean expression before "
mismTypesErr = "mismatched types at "
argsExprsErr = "Wrong number of args for: "
typeExprsErr = "Type mismatch of args for: "

refErr i id = concat ["Argument ",show i, " in call of \""
                     ,id,"\" cannot be passed by reference"]
