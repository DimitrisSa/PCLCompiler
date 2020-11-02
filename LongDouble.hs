module LongDouble where
import Numeric.LongDouble
import Data.Bits.Floating
import Data.Bits.Extras
import Data.Word

myRead :: String -> LongDouble
myRead = read 

myCoerce :: LongDouble -> (Integer,Int)
myCoerce = decodeFloat 

myReadCoerce :: String -> (Integer,Int)
myReadCoerce = myCoerce . myRead

myMetatropi :: (Integer,Int) -> (Int,Integer)
myMetatropi (inte,int) = (int + (floor . logBase 2 . fromIntegral) inte, inte)

wholeMetatropi :: String -> (Word16,Word64)
wholeMetatropi = extraMetatropi . (\(x,y) -> (w16 x,w64 y)) . myMetatropi . myReadCoerce

extraMetatropi :: (Word16,Word64) -> (Word16,Word64)
extraMetatropi ww = case ww of
  (65535,0) -> (0,0)
  (x,y)     -> (16383 + x,y)
