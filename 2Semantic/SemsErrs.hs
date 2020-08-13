module SemsErrs where
import Parser
 
duplicateCallableErr = "Duplicate Function/Procedure name: "
nonIntAfErr = "non-integer expression after "
nonIntBefErr = "non-integer expression before "
nonBoolAfErr = "non-boolean expression after "
nonBoolBefErr = "non-boolean expression before "
mismTypesErr = "mismatched types at "
argsExprsErr = "Wrong number of args for: "
typeExprsErr = "Type mismatch of args for: "

refErr i id = concat ["Argument ",show i, " in call of \""
                     ,id,"\" cannot be passed by reference"]
