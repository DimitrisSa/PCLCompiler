module IR where
import Common as P hiding (map)
import LLVM.AST
import LLVM.AST.Type as T
import Data.String.Transform
import LLVM.AST.Global
import Data.Bits.Extras

nameModule :: Id -> Sems ()
nameModule (Id _ str) = modifyModule $ \mod -> mod { moduleName = toShortByteString str }

addDefinition :: Definition -> Sems ()
addDefinition d = modifyModule $
  \mod -> mod { moduleDefinitions = moduleDefinitions mod ++ [d] }

strToName :: String -> Name
strToName = Name . toShortByteString

define :: String -> [(Name, T.Type)] -> T.Type -> [BasicBlock] -> Sems ()
define fname argtys retty body = addDefinition $ GlobalDefinition $ functionDefaults {
    name        = strToName fname
  , parameters  = ([Parameter ty nm [] | (nm, ty) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

frmlsDefine fname fs retty = define fname (frmlsToNmTys fs) (toTType retty) [] 

frmlsToNmTys :: [Frml] -> [(Name,T.Type)]
frmlsToNmTys = concat . map frmlToNmTys

frmlToNmTys :: (PassBy,[Id],P.Type) -> [(Name,T.Type)]
frmlToNmTys (_,ids,ty) = map (\id -> (strToName $ idString id, toTType ty)) ids

toTType :: P.Type -> T.Type
toTType = \case
  Nil           -> undefined
  IntT          -> i16
  RealT         -> x86_fp80  
  BoolT         -> i8
  CharT         -> i8
  Array size ty -> arrayToTType ty size
  Pointer ty    -> ptr $ toTType ty
 
arrayToTType ty = \case
  NoSize -> undefined
  Size n -> ArrayType (w64 n) $ toTType ty

