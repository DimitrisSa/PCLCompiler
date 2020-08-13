module Helpers where
import Parser
import SemsTypes
import SemsErrs
import Control.Monad.Trans.Either

fullType :: Type -> Bool
fullType = \case Array NoSize _ -> False; _ -> True

symbatos :: (Type,Type) -> Bool
symbatos (Pointer (Array NoSize t1),Pointer (Array (Size _) t2)) = t1 == t2
symbatos (lt,et) = (lt == et && fullType lt) || (lt == RealT && et == IntT)

dummy :: String -> Id
dummy s = Id s 0 0 

formalsToTypes :: [Frml] -> [(PassBy,Type)]
formalsToTypes = map formalToTypes >>> concat

formalToTypes :: Frml -> [(PassBy,Type)]
formalToTypes (pb,ids,ty) = map (\_ -> (pb,ty)) ids
