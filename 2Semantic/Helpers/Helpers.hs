module Helpers where
import Prelude hiding (lookup)
import SemsTypes
import SemsErrs
import Control.Monad.State
import Parser
import Data.Map
import Control.Monad.Trans.Either

getVariableMap :: Sems VariableMap
getVariableMap = return . variableMap . head =<< get

getLabelMap :: Sems LabelMap
getLabelMap = return . labelMap . head =<< get

getCallableMap :: Sems CallableMap
getCallableMap = return . callableMap . head =<< get

checkUnusedLabels :: Sems ()
checkUnusedLabels = checkFalseLabelValueInList . toList =<< getLabelMap

checkFalseLabelValueInList :: [(Id,Bool)] -> Sems ()
checkFalseLabelValueInList = mapM_ $ \case
  (id,False) -> errAtId unusedLabelErr id
  _          -> return ()

checkUndefDeclarationSems :: Sems ()
checkUndefDeclarationSems = checkUndefDeclarationInList . toList =<< getCallableMap

checkUndefDeclarationInList :: [(Id,Callable)] -> Sems ()
checkUndefDeclarationInList = mapM_ checkUndefDeclaration

checkUndefDeclaration :: (Id,Callable) -> Sems ()
checkUndefDeclaration = \case
  (id,ProcDeclaration _  ) -> errAtId undefinedDeclarationErr id
  (id,FuncDeclaration _ _) -> errAtId undefinedDeclarationErr id
  _                        -> return ()

insToSymTabLabels :: [Id] -> Sems ()
insToSymTabLabels = mapM_ insToSymTabLabel

insToSymTabLabel :: Id -> Sems ()
insToSymTabLabel label = afterlabelLookup label . lookup label =<< getLabelMap 

afterlabelLookup :: Id -> Maybe Bool -> Sems ()
afterlabelLookup label = \case 
  Nothing -> modify $ \(st:sts) -> st { labelMap = insert label False $ labelMap st }:sts
  _       -> errAtId duplicateLabelDeclarationErr label

checkFullType :: Type -> Bool
checkFullType = \case
  ArrayT NoSize _ -> False
  _               -> True

symbatos :: Type -> Type -> Bool
symbatos (PointerT (ArrayT NoSize t1)) (PointerT (ArrayT (Size _) t2)) = t1 == t2
symbatos lt et = (lt == et && checkFullType lt) || (lt == Treal && et == Tint)

forwardSems :: Header -> Sems ()
forwardSems h = case h of
  ProcHeader i a   -> insToSymTabForwardHeader i a (ProcDeclaration $ reverse a)
  FuncHeader i a t -> case t of
    ArrayT _ _ -> errAtId funcResTypeErr i
    _          -> insToSymTabForwardHeader i a (FuncDeclaration (reverse a) t)

insToSymTabForwardHeader :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabForwardHeader id fs t =
  afterForwardHeaderLookup id fs t . lookup id =<< getCallableMap

afterForwardHeaderLookup id fs t = \case
  Nothing -> insToSymTabIfFormalsOk id fs t
  _       -> errAtId duplicateCallableErr id

insToSymTabIfFormalsOk :: Id -> [Formal] -> Callable -> Sems ()
insToSymTabIfFormalsOk id fs cal = case all formalOk fs of
  True -> modify $ \(st:sts) -> st { callableMap = insert id cal $ callableMap st }:sts 
  _    -> errAtId arrByValErr id

formalOk :: Formal -> Bool
formalOk = \case (Value,_,ArrayT _ _) -> False; _ -> True
