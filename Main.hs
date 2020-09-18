module Main where
import Sems
import SemsTypes
import SemsCodegen

main :: IO ()
main = process
--main = sems >>= show >>> putStrLn
