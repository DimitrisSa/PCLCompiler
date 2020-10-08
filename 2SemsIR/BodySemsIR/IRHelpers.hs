module IRHelpers where
import Prelude hiding (abs,cos,sin,tan,sqrt,exp,pi,round)
import SemsCodegen (writeInteger,writeBoolean,writeChar,writeReal,writeString,readString
                   ,readInteger,readBoolean,readChar,readReal,abs,fabs,sqrt,sin,cos,tan
                   ,arctan,exp,ln,pi,trunc,round,ordOp,chr)
import Parser (idString)
import SemsIRTypes ((>>>))

idToFunOper = idString >>> \case
  "writeInteger" -> writeInteger
  "writeBoolean" -> writeBoolean
  "writeChar"    -> writeChar 
  "writeReal"    -> writeReal
  "writeString"  -> writeString 
  "readString"   -> readString
  "readInteger"  -> readInteger
  "readBoolean"  -> readBoolean
  "readChar"     -> readChar
  "readReal"     -> readReal
  "abs"          -> abs
  "fabs"         -> fabs
  "sqrt"         -> sqrt
  "sin"          -> sin
  "cos"          -> cos
  "tan"          -> tan
  "arctan"       -> arctan
  "exp"          -> exp
  "ln"           -> ln
  "pi"           -> pi
  "trunc"        -> trunc
  "round"        -> round
  "ord"          -> ordOp
  "chr"          -> chr
  _              -> undefined
