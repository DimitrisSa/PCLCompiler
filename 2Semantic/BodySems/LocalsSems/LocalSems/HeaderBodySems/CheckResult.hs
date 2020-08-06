module CheckResult where
import Common

checkResult :: Sems ()
checkResult = getEnv >>= \case
  InFunc id _ False -> errAtId noResInFunErr id
  _                 -> return ()
