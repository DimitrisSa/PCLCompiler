module IR where

import LLVM.AST
import LLVM.AST.Float
import LLVM.AST.FloatingPointPredicate
import LLVM.AST.Type

double :: Type
double = FloatingPointType DoubleFP

