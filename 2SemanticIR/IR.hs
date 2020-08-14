module IR where
import Common
import LLVM.AST
import LLVM.AST.Type as T
import Data.String.Transform
import LLVM.AST.Global

nameModule :: Id -> Sems ()
nameModule (Id _ str) = modifyModule $ \mod -> mod { moduleName = toShortByteString str }

addDefinition :: Definition -> Sems ()
addDefinition d = modifyModule $
  \mod -> mod { moduleDefinitions = moduleDefinitions mod ++ [d] }

define :: String -> [(T.Type, Name)] -> T.Type -> [BasicBlock] -> Sems ()
define label argtys retty body = addDefinition $
  GlobalDefinition $ functionDefaults {
    name        = Name $ toShortByteString label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }
