module IR where
import Common as P hiding (map)
import LLVM.AST
import LLVM.AST.Type as T
import Data.String.Transform
import LLVM.AST.Global
import Data.Bits.Extras

--nameModule :: Id -> Sems ()
--nameModule (Id _ str) = modifyModule $ \mod -> mod { moduleName = toShortByteString str }
--
--addDefinition :: Definition -> Sems ()
--addDefinition d = modifyModule $
--  \mod -> mod { moduleDefinitions = moduleDefinitions mod ++ [d] }

--idToName :: Id -> Name
--idToName =  Name . toShortByteString . idString
--
--define :: Id -> [(Name, T.Type)] -> T.Type -> [BasicBlock] -> Sems ()
--define fname argtys retty body = addDefinition $ GlobalDefinition $ functionDefaults {
--    name        = idToName fname
--  , parameters  = ([Parameter ty nm [] | (nm, ty) <- argtys], False)
--  , returnType  = retty
--  , basicBlocks = body
--  }

--irCallable :: Header -> Body -> Sems ()
--irCallable h b = case h of
--  ProcHeader id frmls    -> frmlsProcDefine id frmls $ bodyToBasicBls b
--  FuncHeader id frmls ty -> frmlsFuncDefine id frmls ty $ bodyToBasicBls b
--
--bodyToBasicBls :: Body -> [BasicBlock]
--bodyToBasicBls b = _a

--frmlsFuncDefine :: Id -> [Frml] -> P.Type  -> [BasicBlock] -> Sems ()
--frmlsFuncDefine id fs retty body = define id (frmlsToNmTys fs) (toTType retty) body 
--
--frmlsProcDefine :: Id -> [Frml] -> [BasicBlock] -> Sems ()
--frmlsProcDefine id fs body = define id (frmlsToNmTys fs) VoidType body 
--
--frmlsToNmTys :: [Frml] -> [(Name,T.Type)]
--frmlsToNmTys = concat . map frmlToNmTys
--
--frmlToNmTys :: (PassBy,[Id],P.Type) -> [(Name,T.Type)]
--frmlToNmTys (_,ids,ty) = map (\id -> (idToName id, toTType ty)) ids
--
--toTType :: P.Type -> T.Type
--toTType = \case
--  Nil           -> undefined
--  IntT          -> i16
--  RealT         -> x86_fp80  
--  BoolT         -> i8
--  CharT         -> i8
--  Array size ty -> arrayToTType ty size
--  Pointer ty    -> ptr $ toTType ty
-- 
--arrayToTType ty = \case
--  NoSize -> ptr $ toTType ty
--  Size n -> ArrayType (w64 n) $ toTType ty
