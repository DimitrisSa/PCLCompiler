module Main where
import Sems
import SemsTypes
import Codegen
import Emit

main :: IO ()
main = process
--main = sems >>= show >>> putStrLn
