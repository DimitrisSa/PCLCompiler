module Main where
import Sems
import SemsTypes
import IR
import Codegen
import Emit

main :: IO ()
main = process
--main = sems >>= show >>> putStrLn
