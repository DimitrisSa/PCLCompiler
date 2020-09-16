module Main where
import Sems
import SemsTypes
import Codegen
import Emit
import SemsCodegen

main :: IO ()
main = process
--main = sems >>= show >>> putStrLn
