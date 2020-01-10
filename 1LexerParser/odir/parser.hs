{-# OPTIONS_GHC -w #-}
module Parser where
import Lexer (Token(..))
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.8

data HappyAbsSyn t15 t22
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (Program)
	| HappyAbsSyn5 (Body)
	| HappyAbsSyn6 ([Local])
	| HappyAbsSyn7 (Local)
	| HappyAbsSyn8 (Variables)
	| HappyAbsSyn9 ((Ids,Type))
	| HappyAbsSyn10 (Ids)
	| HappyAbsSyn11 (Header)
	| HappyAbsSyn12 (Args)
	| HappyAbsSyn13 ([Formal])
	| HappyAbsSyn14 (Formal)
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 (Type)
	| HappyAbsSyn17 (ArrSize)
	| HappyAbsSyn18 (Block)
	| HappyAbsSyn19 (Stmts)
	| HappyAbsSyn20 (Stmt)
	| HappyAbsSyn21 (Expr)
	| HappyAbsSyn22 t22
	| HappyAbsSyn24 (LValue)
	| HappyAbsSyn25 (RValue)
	| HappyAbsSyn26 (Call)
	| HappyAbsSyn27 (Exprs)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,477) ([0,0,0,16,0,0,0,0,2048,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,512,0,32768,8960,2064,0,0,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,0,0,18432,14536,16216,8752,0,0,4096,128,0,0,0,0,0,128,0,0,0,0,16384,0,0,0,0,0,32,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,49152,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,32768,16,0,0,0,0,256,0,0,0,0,8192,0,0,0,0,0,0,0,0,4,0,2048,0,0,0,0,0,0,0,8320,8448,61440,127,0,0,0,0,32768,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,2,0,0,0,6148,7972,4376,0,0,0,0,0,128,0,0,0,0,0,0,0,128,58499,8963,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12296,15944,8752,0,0,0,0,0,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,8384,49401,136,0,0,24592,31888,17504,0,0,2048,18480,12350,34,0,0,6148,7972,4376,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,36,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,2,0,0,0,32768,0,0,0,0,0,32768,0,0,0,0,8192,0,0,32768,33536,996,547,0,16384,50754,64193,4481,1,0,1544,528,65280,7,0,0,0,0,512,0,0,2048,18480,12350,34,0,0,6148,7972,4376,0,32768,32,2081,32752,0,0,0,0,0,0,0,0,128,58499,8963,2,0,0,0,0,8192,0,0,49184,63776,35008,0,0,4096,36960,24700,68,0,0,12296,15944,8752,0,0,1024,9240,6175,17,0,0,3074,3986,2188,0,0,256,51462,17927,4,0,32768,33536,996,547,0,0,32832,62017,4481,1,0,8192,8384,49401,136,0,0,24592,31888,17504,0,0,2048,18480,12350,34,0,0,6148,7972,4376,0,0,512,37388,35855,8,0,0,1537,1993,1094,0,0,128,58499,8963,2,0,16384,16768,33266,273,0,0,0,0,0,0,0,0,0,0,0,0,18432,14536,16216,8752,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,1024,0,0,0,208,4100,0,4,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,53248,1024,16,1024,0,0,0,0,0,128,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,1,0,16640,512,0,224,0,32768,32,1,28672,0,0,4160,4224,0,62,0,8192,16392,8,7936,0,0,1040,1056,32768,15,0,2048,4098,2,1984,0,0,260,264,57344,3,0,33280,33792,0,496,0,0,65,2,57344,0,0,0,0,0,64,0,0,0,0,8192,0,0,0,0,0,16,0,4096,8196,4,4094,32,0,520,528,65280,7,0,0,0,0,0,0,0,0,0,0,512,0,9216,7268,8108,4376,0,32768,32,33,32752,256,0,0,0,0,16384,0,32768,35972,62851,8963,2,0,0,0,0,0,0,2048,4098,2,2047,0,0,0,0,0,128,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,33536,996,547,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,12288,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,1,32768,8198,128,8192,0,0,0,0,0,0,0,40960,2049,32,2048,0,0,208,4100,0,4,0,36864,29072,32432,17504,0,0,130,132,65472,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parse","Program","Body","Locals","Local","Variables","IdsAndType","Ids","Header","Args","Formals","Formal","Optvar","Type","ArrSize","Block","Stmts","Stmt","New","Dispose","Expr","LValue","RValue","Call","ArgExprs","Exprs","and","array","begin","boolean","char","dispose","div","do","else","end","false","forward","function","goto","if","integer","label","mod","new","nil","not","of","or","procedure","program","real","result","return","then","true","var","while","id","intconst","realconst","charconst","stringconst","'='","'>'","'<'","diff","greq","smeq","'+'","'-'","'*'","'/'","'^'","'@'","equal","';'","'.'","'('","')'","':'","','","'['","']'","%eof"]
        bit_start = st * 87
        bit_end = (st + 1) * 87
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..86]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (53) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (53) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (61) = happyShift action_4
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (87) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (79) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (5) = happyGoto action_6
action_5 (6) = happyGoto action_7
action_5 _ = happyReduce_3

action_6 (80) = happyShift action_17
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (31) = happyShift action_11
action_7 (40) = happyShift action_12
action_7 (41) = happyShift action_13
action_7 (45) = happyShift action_14
action_7 (52) = happyShift action_15
action_7 (59) = happyShift action_16
action_7 (7) = happyGoto action_8
action_7 (11) = happyGoto action_9
action_7 (18) = happyGoto action_10
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_4

action_9 (79) = happyShift action_53
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_2

action_11 (31) = happyShift action_11
action_11 (34) = happyShift action_33
action_11 (39) = happyShift action_34
action_11 (42) = happyShift action_35
action_11 (43) = happyShift action_36
action_11 (47) = happyShift action_37
action_11 (48) = happyShift action_38
action_11 (49) = happyShift action_39
action_11 (55) = happyShift action_40
action_11 (56) = happyShift action_41
action_11 (58) = happyShift action_42
action_11 (60) = happyShift action_43
action_11 (61) = happyShift action_44
action_11 (62) = happyShift action_45
action_11 (63) = happyShift action_46
action_11 (64) = happyShift action_47
action_11 (65) = happyShift action_48
action_11 (72) = happyShift action_49
action_11 (73) = happyShift action_50
action_11 (77) = happyShift action_51
action_11 (81) = happyShift action_52
action_11 (18) = happyGoto action_26
action_11 (19) = happyGoto action_27
action_11 (20) = happyGoto action_28
action_11 (23) = happyGoto action_29
action_11 (24) = happyGoto action_30
action_11 (25) = happyGoto action_31
action_11 (26) = happyGoto action_32
action_11 _ = happyReduce_34

action_12 (41) = happyShift action_13
action_12 (52) = happyShift action_15
action_12 (11) = happyGoto action_25
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (61) = happyShift action_24
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (61) = happyShift action_21
action_14 (10) = happyGoto action_23
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (61) = happyShift action_22
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (61) = happyShift action_21
action_16 (8) = happyGoto action_18
action_16 (9) = happyGoto action_19
action_16 (10) = happyGoto action_20
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_1

action_18 (61) = happyShift action_21
action_18 (9) = happyGoto action_98
action_18 (10) = happyGoto action_20
action_18 _ = happyReduce_5

action_19 _ = happyReduce_9

action_20 (83) = happyShift action_97
action_20 (84) = happyShift action_95
action_20 _ = happyFail (happyExpListPerState 20)

action_21 _ = happyReduce_12

action_22 (81) = happyShift action_96
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (79) = happyShift action_94
action_23 (84) = happyShift action_95
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (81) = happyShift action_93
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (79) = happyShift action_92
action_25 _ = happyFail (happyExpListPerState 25)

action_26 _ = happyReduce_36

action_27 (38) = happyShift action_90
action_27 (79) = happyShift action_91
action_27 _ = happyFail (happyExpListPerState 27)

action_28 _ = happyReduce_32

action_29 (29) = happyShift action_75
action_29 (35) = happyShift action_76
action_29 (46) = happyShift action_77
action_29 (51) = happyShift action_78
action_29 (66) = happyShift action_79
action_29 (67) = happyShift action_80
action_29 (68) = happyShift action_81
action_29 (69) = happyShift action_82
action_29 (70) = happyShift action_83
action_29 (71) = happyShift action_84
action_29 (72) = happyShift action_85
action_29 (73) = happyShift action_86
action_29 (74) = happyShift action_87
action_29 (75) = happyShift action_88
action_29 (76) = happyShift action_89
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (78) = happyShift action_73
action_30 (85) = happyShift action_74
action_30 _ = happyReduce_50

action_31 _ = happyReduce_51

action_32 (37) = happyReduce_37
action_32 (38) = happyReduce_37
action_32 (79) = happyReduce_37
action_32 _ = happyReduce_65

action_33 (85) = happyShift action_72
action_33 (22) = happyGoto action_71
action_33 _ = happyReduce_48

action_34 _ = happyReduce_60

action_35 (61) = happyShift action_70
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (39) = happyShift action_34
action_36 (48) = happyShift action_38
action_36 (49) = happyShift action_39
action_36 (55) = happyShift action_40
action_36 (58) = happyShift action_42
action_36 (61) = happyShift action_58
action_36 (62) = happyShift action_45
action_36 (63) = happyShift action_46
action_36 (64) = happyShift action_47
action_36 (65) = happyShift action_48
action_36 (72) = happyShift action_49
action_36 (73) = happyShift action_50
action_36 (77) = happyShift action_51
action_36 (81) = happyShift action_52
action_36 (23) = happyGoto action_69
action_36 (24) = happyGoto action_61
action_36 (25) = happyGoto action_31
action_36 (26) = happyGoto action_57
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (85) = happyShift action_68
action_37 (21) = happyGoto action_67
action_37 _ = happyReduce_46

action_38 _ = happyReduce_64

action_39 (39) = happyShift action_34
action_39 (48) = happyShift action_38
action_39 (49) = happyShift action_39
action_39 (55) = happyShift action_40
action_39 (58) = happyShift action_42
action_39 (61) = happyShift action_58
action_39 (62) = happyShift action_45
action_39 (63) = happyShift action_46
action_39 (64) = happyShift action_47
action_39 (65) = happyShift action_48
action_39 (72) = happyShift action_49
action_39 (73) = happyShift action_50
action_39 (77) = happyShift action_51
action_39 (81) = happyShift action_52
action_39 (23) = happyGoto action_66
action_39 (24) = happyGoto action_61
action_39 (25) = happyGoto action_31
action_39 (26) = happyGoto action_57
action_39 _ = happyFail (happyExpListPerState 39)

action_40 _ = happyReduce_53

action_41 _ = happyReduce_43

action_42 _ = happyReduce_59

action_43 (39) = happyShift action_34
action_43 (48) = happyShift action_38
action_43 (49) = happyShift action_39
action_43 (55) = happyShift action_40
action_43 (58) = happyShift action_42
action_43 (61) = happyShift action_58
action_43 (62) = happyShift action_45
action_43 (63) = happyShift action_46
action_43 (64) = happyShift action_47
action_43 (65) = happyShift action_48
action_43 (72) = happyShift action_49
action_43 (73) = happyShift action_50
action_43 (77) = happyShift action_51
action_43 (81) = happyShift action_52
action_43 (23) = happyGoto action_65
action_43 (24) = happyGoto action_61
action_43 (25) = happyGoto action_31
action_43 (26) = happyGoto action_57
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (81) = happyShift action_63
action_44 (83) = happyShift action_64
action_44 _ = happyReduce_52

action_45 _ = happyReduce_58

action_46 _ = happyReduce_61

action_47 _ = happyReduce_62

action_48 _ = happyReduce_54

action_49 (39) = happyShift action_34
action_49 (48) = happyShift action_38
action_49 (49) = happyShift action_39
action_49 (55) = happyShift action_40
action_49 (58) = happyShift action_42
action_49 (61) = happyShift action_58
action_49 (62) = happyShift action_45
action_49 (63) = happyShift action_46
action_49 (64) = happyShift action_47
action_49 (65) = happyShift action_48
action_49 (72) = happyShift action_49
action_49 (73) = happyShift action_50
action_49 (77) = happyShift action_51
action_49 (81) = happyShift action_52
action_49 (23) = happyGoto action_62
action_49 (24) = happyGoto action_61
action_49 (25) = happyGoto action_31
action_49 (26) = happyGoto action_57
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (39) = happyShift action_34
action_50 (48) = happyShift action_38
action_50 (49) = happyShift action_39
action_50 (55) = happyShift action_40
action_50 (58) = happyShift action_42
action_50 (61) = happyShift action_58
action_50 (62) = happyShift action_45
action_50 (63) = happyShift action_46
action_50 (64) = happyShift action_47
action_50 (65) = happyShift action_48
action_50 (72) = happyShift action_49
action_50 (73) = happyShift action_50
action_50 (77) = happyShift action_51
action_50 (81) = happyShift action_52
action_50 (23) = happyGoto action_60
action_50 (24) = happyGoto action_61
action_50 (25) = happyGoto action_31
action_50 (26) = happyGoto action_57
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (39) = happyShift action_34
action_51 (48) = happyShift action_38
action_51 (49) = happyShift action_39
action_51 (55) = happyShift action_40
action_51 (58) = happyShift action_42
action_51 (61) = happyShift action_58
action_51 (62) = happyShift action_45
action_51 (63) = happyShift action_46
action_51 (64) = happyShift action_47
action_51 (65) = happyShift action_48
action_51 (72) = happyShift action_49
action_51 (73) = happyShift action_50
action_51 (77) = happyShift action_51
action_51 (81) = happyShift action_52
action_51 (23) = happyGoto action_29
action_51 (24) = happyGoto action_59
action_51 (25) = happyGoto action_31
action_51 (26) = happyGoto action_57
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (39) = happyShift action_34
action_52 (48) = happyShift action_38
action_52 (49) = happyShift action_39
action_52 (55) = happyShift action_40
action_52 (58) = happyShift action_42
action_52 (61) = happyShift action_58
action_52 (62) = happyShift action_45
action_52 (63) = happyShift action_46
action_52 (64) = happyShift action_47
action_52 (65) = happyShift action_48
action_52 (72) = happyShift action_49
action_52 (73) = happyShift action_50
action_52 (77) = happyShift action_51
action_52 (81) = happyShift action_52
action_52 (23) = happyGoto action_29
action_52 (24) = happyGoto action_55
action_52 (25) = happyGoto action_56
action_52 (26) = happyGoto action_57
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (5) = happyGoto action_54
action_53 (6) = happyGoto action_7
action_53 _ = happyReduce_3

action_54 (79) = happyShift action_142
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (82) = happyShift action_141
action_55 (85) = happyShift action_74
action_55 _ = happyReduce_50

action_56 (82) = happyShift action_140
action_56 _ = happyReduce_51

action_57 _ = happyReduce_65

action_58 (81) = happyShift action_63
action_58 _ = happyReduce_52

action_59 (85) = happyShift action_74
action_59 _ = happyReduce_66

action_60 (76) = happyShift action_89
action_60 _ = happyReduce_69

action_61 (85) = happyShift action_74
action_61 _ = happyReduce_50

action_62 (76) = happyShift action_89
action_62 _ = happyReduce_68

action_63 (39) = happyShift action_34
action_63 (48) = happyShift action_38
action_63 (49) = happyShift action_39
action_63 (55) = happyShift action_40
action_63 (58) = happyShift action_42
action_63 (61) = happyShift action_58
action_63 (62) = happyShift action_45
action_63 (63) = happyShift action_46
action_63 (64) = happyShift action_47
action_63 (65) = happyShift action_48
action_63 (72) = happyShift action_49
action_63 (73) = happyShift action_50
action_63 (77) = happyShift action_51
action_63 (81) = happyShift action_52
action_63 (23) = happyGoto action_137
action_63 (24) = happyGoto action_61
action_63 (25) = happyGoto action_31
action_63 (26) = happyGoto action_57
action_63 (27) = happyGoto action_138
action_63 (28) = happyGoto action_139
action_63 _ = happyReduce_85

action_64 (31) = happyShift action_11
action_64 (34) = happyShift action_33
action_64 (39) = happyShift action_34
action_64 (42) = happyShift action_35
action_64 (43) = happyShift action_36
action_64 (47) = happyShift action_37
action_64 (48) = happyShift action_38
action_64 (49) = happyShift action_39
action_64 (55) = happyShift action_40
action_64 (56) = happyShift action_41
action_64 (58) = happyShift action_42
action_64 (60) = happyShift action_43
action_64 (61) = happyShift action_44
action_64 (62) = happyShift action_45
action_64 (63) = happyShift action_46
action_64 (64) = happyShift action_47
action_64 (65) = happyShift action_48
action_64 (72) = happyShift action_49
action_64 (73) = happyShift action_50
action_64 (77) = happyShift action_51
action_64 (81) = happyShift action_52
action_64 (18) = happyGoto action_26
action_64 (20) = happyGoto action_136
action_64 (23) = happyGoto action_29
action_64 (24) = happyGoto action_30
action_64 (25) = happyGoto action_31
action_64 (26) = happyGoto action_32
action_64 _ = happyReduce_34

action_65 (29) = happyShift action_75
action_65 (35) = happyShift action_76
action_65 (36) = happyShift action_135
action_65 (46) = happyShift action_77
action_65 (51) = happyShift action_78
action_65 (66) = happyShift action_79
action_65 (67) = happyShift action_80
action_65 (68) = happyShift action_81
action_65 (69) = happyShift action_82
action_65 (70) = happyShift action_83
action_65 (71) = happyShift action_84
action_65 (72) = happyShift action_85
action_65 (73) = happyShift action_86
action_65 (74) = happyShift action_87
action_65 (75) = happyShift action_88
action_65 (76) = happyShift action_89
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (76) = happyShift action_89
action_66 _ = happyReduce_67

action_67 (39) = happyShift action_34
action_67 (48) = happyShift action_38
action_67 (49) = happyShift action_39
action_67 (55) = happyShift action_40
action_67 (58) = happyShift action_42
action_67 (61) = happyShift action_58
action_67 (62) = happyShift action_45
action_67 (63) = happyShift action_46
action_67 (64) = happyShift action_47
action_67 (65) = happyShift action_48
action_67 (72) = happyShift action_49
action_67 (73) = happyShift action_50
action_67 (77) = happyShift action_51
action_67 (81) = happyShift action_52
action_67 (23) = happyGoto action_29
action_67 (24) = happyGoto action_134
action_67 (25) = happyGoto action_31
action_67 (26) = happyGoto action_57
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (39) = happyShift action_34
action_68 (48) = happyShift action_38
action_68 (49) = happyShift action_39
action_68 (55) = happyShift action_40
action_68 (58) = happyShift action_42
action_68 (61) = happyShift action_58
action_68 (62) = happyShift action_45
action_68 (63) = happyShift action_46
action_68 (64) = happyShift action_47
action_68 (65) = happyShift action_48
action_68 (72) = happyShift action_49
action_68 (73) = happyShift action_50
action_68 (77) = happyShift action_51
action_68 (81) = happyShift action_52
action_68 (23) = happyGoto action_133
action_68 (24) = happyGoto action_61
action_68 (25) = happyGoto action_31
action_68 (26) = happyGoto action_57
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (29) = happyShift action_75
action_69 (35) = happyShift action_76
action_69 (46) = happyShift action_77
action_69 (51) = happyShift action_78
action_69 (57) = happyShift action_132
action_69 (66) = happyShift action_79
action_69 (67) = happyShift action_80
action_69 (68) = happyShift action_81
action_69 (69) = happyShift action_82
action_69 (70) = happyShift action_83
action_69 (71) = happyShift action_84
action_69 (72) = happyShift action_85
action_69 (73) = happyShift action_86
action_69 (74) = happyShift action_87
action_69 (75) = happyShift action_88
action_69 (76) = happyShift action_89
action_69 _ = happyFail (happyExpListPerState 69)

action_70 _ = happyReduce_42

action_71 (39) = happyShift action_34
action_71 (48) = happyShift action_38
action_71 (49) = happyShift action_39
action_71 (55) = happyShift action_40
action_71 (58) = happyShift action_42
action_71 (61) = happyShift action_58
action_71 (62) = happyShift action_45
action_71 (63) = happyShift action_46
action_71 (64) = happyShift action_47
action_71 (65) = happyShift action_48
action_71 (72) = happyShift action_49
action_71 (73) = happyShift action_50
action_71 (77) = happyShift action_51
action_71 (81) = happyShift action_52
action_71 (23) = happyGoto action_29
action_71 (24) = happyGoto action_131
action_71 (25) = happyGoto action_31
action_71 (26) = happyGoto action_57
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (86) = happyShift action_130
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (39) = happyShift action_34
action_73 (48) = happyShift action_38
action_73 (49) = happyShift action_39
action_73 (55) = happyShift action_40
action_73 (58) = happyShift action_42
action_73 (61) = happyShift action_58
action_73 (62) = happyShift action_45
action_73 (63) = happyShift action_46
action_73 (64) = happyShift action_47
action_73 (65) = happyShift action_48
action_73 (72) = happyShift action_49
action_73 (73) = happyShift action_50
action_73 (77) = happyShift action_51
action_73 (81) = happyShift action_52
action_73 (23) = happyGoto action_129
action_73 (24) = happyGoto action_61
action_73 (25) = happyGoto action_31
action_73 (26) = happyGoto action_57
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (39) = happyShift action_34
action_74 (48) = happyShift action_38
action_74 (49) = happyShift action_39
action_74 (55) = happyShift action_40
action_74 (58) = happyShift action_42
action_74 (61) = happyShift action_58
action_74 (62) = happyShift action_45
action_74 (63) = happyShift action_46
action_74 (64) = happyShift action_47
action_74 (65) = happyShift action_48
action_74 (72) = happyShift action_49
action_74 (73) = happyShift action_50
action_74 (77) = happyShift action_51
action_74 (81) = happyShift action_52
action_74 (23) = happyGoto action_128
action_74 (24) = happyGoto action_61
action_74 (25) = happyGoto action_31
action_74 (26) = happyGoto action_57
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (39) = happyShift action_34
action_75 (48) = happyShift action_38
action_75 (49) = happyShift action_39
action_75 (55) = happyShift action_40
action_75 (58) = happyShift action_42
action_75 (61) = happyShift action_58
action_75 (62) = happyShift action_45
action_75 (63) = happyShift action_46
action_75 (64) = happyShift action_47
action_75 (65) = happyShift action_48
action_75 (72) = happyShift action_49
action_75 (73) = happyShift action_50
action_75 (77) = happyShift action_51
action_75 (81) = happyShift action_52
action_75 (23) = happyGoto action_127
action_75 (24) = happyGoto action_61
action_75 (25) = happyGoto action_31
action_75 (26) = happyGoto action_57
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (39) = happyShift action_34
action_76 (48) = happyShift action_38
action_76 (49) = happyShift action_39
action_76 (55) = happyShift action_40
action_76 (58) = happyShift action_42
action_76 (61) = happyShift action_58
action_76 (62) = happyShift action_45
action_76 (63) = happyShift action_46
action_76 (64) = happyShift action_47
action_76 (65) = happyShift action_48
action_76 (72) = happyShift action_49
action_76 (73) = happyShift action_50
action_76 (77) = happyShift action_51
action_76 (81) = happyShift action_52
action_76 (23) = happyGoto action_126
action_76 (24) = happyGoto action_61
action_76 (25) = happyGoto action_31
action_76 (26) = happyGoto action_57
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (39) = happyShift action_34
action_77 (48) = happyShift action_38
action_77 (49) = happyShift action_39
action_77 (55) = happyShift action_40
action_77 (58) = happyShift action_42
action_77 (61) = happyShift action_58
action_77 (62) = happyShift action_45
action_77 (63) = happyShift action_46
action_77 (64) = happyShift action_47
action_77 (65) = happyShift action_48
action_77 (72) = happyShift action_49
action_77 (73) = happyShift action_50
action_77 (77) = happyShift action_51
action_77 (81) = happyShift action_52
action_77 (23) = happyGoto action_125
action_77 (24) = happyGoto action_61
action_77 (25) = happyGoto action_31
action_77 (26) = happyGoto action_57
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (39) = happyShift action_34
action_78 (48) = happyShift action_38
action_78 (49) = happyShift action_39
action_78 (55) = happyShift action_40
action_78 (58) = happyShift action_42
action_78 (61) = happyShift action_58
action_78 (62) = happyShift action_45
action_78 (63) = happyShift action_46
action_78 (64) = happyShift action_47
action_78 (65) = happyShift action_48
action_78 (72) = happyShift action_49
action_78 (73) = happyShift action_50
action_78 (77) = happyShift action_51
action_78 (81) = happyShift action_52
action_78 (23) = happyGoto action_124
action_78 (24) = happyGoto action_61
action_78 (25) = happyGoto action_31
action_78 (26) = happyGoto action_57
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (39) = happyShift action_34
action_79 (48) = happyShift action_38
action_79 (49) = happyShift action_39
action_79 (55) = happyShift action_40
action_79 (58) = happyShift action_42
action_79 (61) = happyShift action_58
action_79 (62) = happyShift action_45
action_79 (63) = happyShift action_46
action_79 (64) = happyShift action_47
action_79 (65) = happyShift action_48
action_79 (72) = happyShift action_49
action_79 (73) = happyShift action_50
action_79 (77) = happyShift action_51
action_79 (81) = happyShift action_52
action_79 (23) = happyGoto action_123
action_79 (24) = happyGoto action_61
action_79 (25) = happyGoto action_31
action_79 (26) = happyGoto action_57
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (39) = happyShift action_34
action_80 (48) = happyShift action_38
action_80 (49) = happyShift action_39
action_80 (55) = happyShift action_40
action_80 (58) = happyShift action_42
action_80 (61) = happyShift action_58
action_80 (62) = happyShift action_45
action_80 (63) = happyShift action_46
action_80 (64) = happyShift action_47
action_80 (65) = happyShift action_48
action_80 (72) = happyShift action_49
action_80 (73) = happyShift action_50
action_80 (77) = happyShift action_51
action_80 (81) = happyShift action_52
action_80 (23) = happyGoto action_122
action_80 (24) = happyGoto action_61
action_80 (25) = happyGoto action_31
action_80 (26) = happyGoto action_57
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (39) = happyShift action_34
action_81 (48) = happyShift action_38
action_81 (49) = happyShift action_39
action_81 (55) = happyShift action_40
action_81 (58) = happyShift action_42
action_81 (61) = happyShift action_58
action_81 (62) = happyShift action_45
action_81 (63) = happyShift action_46
action_81 (64) = happyShift action_47
action_81 (65) = happyShift action_48
action_81 (72) = happyShift action_49
action_81 (73) = happyShift action_50
action_81 (77) = happyShift action_51
action_81 (81) = happyShift action_52
action_81 (23) = happyGoto action_121
action_81 (24) = happyGoto action_61
action_81 (25) = happyGoto action_31
action_81 (26) = happyGoto action_57
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (39) = happyShift action_34
action_82 (48) = happyShift action_38
action_82 (49) = happyShift action_39
action_82 (55) = happyShift action_40
action_82 (58) = happyShift action_42
action_82 (61) = happyShift action_58
action_82 (62) = happyShift action_45
action_82 (63) = happyShift action_46
action_82 (64) = happyShift action_47
action_82 (65) = happyShift action_48
action_82 (72) = happyShift action_49
action_82 (73) = happyShift action_50
action_82 (77) = happyShift action_51
action_82 (81) = happyShift action_52
action_82 (23) = happyGoto action_120
action_82 (24) = happyGoto action_61
action_82 (25) = happyGoto action_31
action_82 (26) = happyGoto action_57
action_82 _ = happyFail (happyExpListPerState 82)

action_83 (39) = happyShift action_34
action_83 (48) = happyShift action_38
action_83 (49) = happyShift action_39
action_83 (55) = happyShift action_40
action_83 (58) = happyShift action_42
action_83 (61) = happyShift action_58
action_83 (62) = happyShift action_45
action_83 (63) = happyShift action_46
action_83 (64) = happyShift action_47
action_83 (65) = happyShift action_48
action_83 (72) = happyShift action_49
action_83 (73) = happyShift action_50
action_83 (77) = happyShift action_51
action_83 (81) = happyShift action_52
action_83 (23) = happyGoto action_119
action_83 (24) = happyGoto action_61
action_83 (25) = happyGoto action_31
action_83 (26) = happyGoto action_57
action_83 _ = happyFail (happyExpListPerState 83)

action_84 (39) = happyShift action_34
action_84 (48) = happyShift action_38
action_84 (49) = happyShift action_39
action_84 (55) = happyShift action_40
action_84 (58) = happyShift action_42
action_84 (61) = happyShift action_58
action_84 (62) = happyShift action_45
action_84 (63) = happyShift action_46
action_84 (64) = happyShift action_47
action_84 (65) = happyShift action_48
action_84 (72) = happyShift action_49
action_84 (73) = happyShift action_50
action_84 (77) = happyShift action_51
action_84 (81) = happyShift action_52
action_84 (23) = happyGoto action_118
action_84 (24) = happyGoto action_61
action_84 (25) = happyGoto action_31
action_84 (26) = happyGoto action_57
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (39) = happyShift action_34
action_85 (48) = happyShift action_38
action_85 (49) = happyShift action_39
action_85 (55) = happyShift action_40
action_85 (58) = happyShift action_42
action_85 (61) = happyShift action_58
action_85 (62) = happyShift action_45
action_85 (63) = happyShift action_46
action_85 (64) = happyShift action_47
action_85 (65) = happyShift action_48
action_85 (72) = happyShift action_49
action_85 (73) = happyShift action_50
action_85 (77) = happyShift action_51
action_85 (81) = happyShift action_52
action_85 (23) = happyGoto action_117
action_85 (24) = happyGoto action_61
action_85 (25) = happyGoto action_31
action_85 (26) = happyGoto action_57
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (39) = happyShift action_34
action_86 (48) = happyShift action_38
action_86 (49) = happyShift action_39
action_86 (55) = happyShift action_40
action_86 (58) = happyShift action_42
action_86 (61) = happyShift action_58
action_86 (62) = happyShift action_45
action_86 (63) = happyShift action_46
action_86 (64) = happyShift action_47
action_86 (65) = happyShift action_48
action_86 (72) = happyShift action_49
action_86 (73) = happyShift action_50
action_86 (77) = happyShift action_51
action_86 (81) = happyShift action_52
action_86 (23) = happyGoto action_116
action_86 (24) = happyGoto action_61
action_86 (25) = happyGoto action_31
action_86 (26) = happyGoto action_57
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (39) = happyShift action_34
action_87 (48) = happyShift action_38
action_87 (49) = happyShift action_39
action_87 (55) = happyShift action_40
action_87 (58) = happyShift action_42
action_87 (61) = happyShift action_58
action_87 (62) = happyShift action_45
action_87 (63) = happyShift action_46
action_87 (64) = happyShift action_47
action_87 (65) = happyShift action_48
action_87 (72) = happyShift action_49
action_87 (73) = happyShift action_50
action_87 (77) = happyShift action_51
action_87 (81) = happyShift action_52
action_87 (23) = happyGoto action_115
action_87 (24) = happyGoto action_61
action_87 (25) = happyGoto action_31
action_87 (26) = happyGoto action_57
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (39) = happyShift action_34
action_88 (48) = happyShift action_38
action_88 (49) = happyShift action_39
action_88 (55) = happyShift action_40
action_88 (58) = happyShift action_42
action_88 (61) = happyShift action_58
action_88 (62) = happyShift action_45
action_88 (63) = happyShift action_46
action_88 (64) = happyShift action_47
action_88 (65) = happyShift action_48
action_88 (72) = happyShift action_49
action_88 (73) = happyShift action_50
action_88 (77) = happyShift action_51
action_88 (81) = happyShift action_52
action_88 (23) = happyGoto action_114
action_88 (24) = happyGoto action_61
action_88 (25) = happyGoto action_31
action_88 (26) = happyGoto action_57
action_88 _ = happyFail (happyExpListPerState 88)

action_89 _ = happyReduce_56

action_90 _ = happyReduce_31

action_91 (31) = happyShift action_11
action_91 (34) = happyShift action_33
action_91 (39) = happyShift action_34
action_91 (42) = happyShift action_35
action_91 (43) = happyShift action_36
action_91 (47) = happyShift action_37
action_91 (48) = happyShift action_38
action_91 (49) = happyShift action_39
action_91 (55) = happyShift action_40
action_91 (56) = happyShift action_41
action_91 (58) = happyShift action_42
action_91 (60) = happyShift action_43
action_91 (61) = happyShift action_44
action_91 (62) = happyShift action_45
action_91 (63) = happyShift action_46
action_91 (64) = happyShift action_47
action_91 (65) = happyShift action_48
action_91 (72) = happyShift action_49
action_91 (73) = happyShift action_50
action_91 (77) = happyShift action_51
action_91 (81) = happyShift action_52
action_91 (18) = happyGoto action_26
action_91 (20) = happyGoto action_113
action_91 (23) = happyGoto action_29
action_91 (24) = happyGoto action_30
action_91 (25) = happyGoto action_31
action_91 (26) = happyGoto action_32
action_91 _ = happyReduce_34

action_92 _ = happyReduce_8

action_93 (59) = happyShift action_110
action_93 (82) = happyReduce_16
action_93 (12) = happyGoto action_112
action_93 (13) = happyGoto action_107
action_93 (14) = happyGoto action_108
action_93 (15) = happyGoto action_109
action_93 _ = happyReduce_21

action_94 _ = happyReduce_6

action_95 (61) = happyShift action_111
action_95 _ = happyFail (happyExpListPerState 95)

action_96 (59) = happyShift action_110
action_96 (82) = happyReduce_16
action_96 (12) = happyGoto action_106
action_96 (13) = happyGoto action_107
action_96 (14) = happyGoto action_108
action_96 (15) = happyGoto action_109
action_96 _ = happyReduce_21

action_97 (30) = happyShift action_100
action_97 (32) = happyShift action_101
action_97 (33) = happyShift action_102
action_97 (44) = happyShift action_103
action_97 (54) = happyShift action_104
action_97 (76) = happyShift action_105
action_97 (16) = happyGoto action_99
action_97 _ = happyFail (happyExpListPerState 97)

action_98 _ = happyReduce_10

action_99 (79) = happyShift action_156
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (85) = happyShift action_155
action_100 (17) = happyGoto action_154
action_100 _ = happyReduce_29

action_101 _ = happyReduce_25

action_102 _ = happyReduce_26

action_103 _ = happyReduce_23

action_104 _ = happyReduce_24

action_105 (30) = happyShift action_100
action_105 (32) = happyShift action_101
action_105 (33) = happyShift action_102
action_105 (44) = happyShift action_103
action_105 (54) = happyShift action_104
action_105 (76) = happyShift action_105
action_105 (16) = happyGoto action_153
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (82) = happyShift action_152
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (79) = happyShift action_151
action_107 _ = happyReduce_17

action_108 _ = happyReduce_18

action_109 (61) = happyShift action_21
action_109 (10) = happyGoto action_150
action_109 _ = happyFail (happyExpListPerState 109)

action_110 _ = happyReduce_22

action_111 _ = happyReduce_13

action_112 (82) = happyShift action_149
action_112 _ = happyFail (happyExpListPerState 112)

action_113 _ = happyReduce_33

action_114 (76) = happyShift action_89
action_114 _ = happyReduce_73

action_115 (76) = happyShift action_89
action_115 _ = happyReduce_71

action_116 (29) = happyShift action_75
action_116 (35) = happyShift action_76
action_116 (46) = happyShift action_77
action_116 (74) = happyShift action_87
action_116 (75) = happyShift action_88
action_116 (76) = happyShift action_89
action_116 _ = happyReduce_72

action_117 (29) = happyShift action_75
action_117 (35) = happyShift action_76
action_117 (46) = happyShift action_77
action_117 (74) = happyShift action_87
action_117 (75) = happyShift action_88
action_117 (76) = happyShift action_89
action_117 _ = happyReduce_70

action_118 (29) = happyShift action_75
action_118 (35) = happyShift action_76
action_118 (46) = happyShift action_77
action_118 (51) = happyShift action_78
action_118 (66) = happyFail []
action_118 (67) = happyFail []
action_118 (68) = happyFail []
action_118 (69) = happyFail []
action_118 (70) = happyFail []
action_118 (71) = happyFail []
action_118 (72) = happyShift action_85
action_118 (73) = happyShift action_86
action_118 (74) = happyShift action_87
action_118 (75) = happyShift action_88
action_118 (76) = happyShift action_89
action_118 _ = happyReduce_83

action_119 (29) = happyShift action_75
action_119 (35) = happyShift action_76
action_119 (46) = happyShift action_77
action_119 (51) = happyShift action_78
action_119 (66) = happyFail []
action_119 (67) = happyFail []
action_119 (68) = happyFail []
action_119 (69) = happyFail []
action_119 (70) = happyFail []
action_119 (71) = happyFail []
action_119 (72) = happyShift action_85
action_119 (73) = happyShift action_86
action_119 (74) = happyShift action_87
action_119 (75) = happyShift action_88
action_119 (76) = happyShift action_89
action_119 _ = happyReduce_82

action_120 (29) = happyShift action_75
action_120 (35) = happyShift action_76
action_120 (46) = happyShift action_77
action_120 (51) = happyShift action_78
action_120 (66) = happyFail []
action_120 (67) = happyFail []
action_120 (68) = happyFail []
action_120 (69) = happyFail []
action_120 (70) = happyFail []
action_120 (71) = happyFail []
action_120 (72) = happyShift action_85
action_120 (73) = happyShift action_86
action_120 (74) = happyShift action_87
action_120 (75) = happyShift action_88
action_120 (76) = happyShift action_89
action_120 _ = happyReduce_79

action_121 (29) = happyShift action_75
action_121 (35) = happyShift action_76
action_121 (46) = happyShift action_77
action_121 (51) = happyShift action_78
action_121 (66) = happyFail []
action_121 (67) = happyFail []
action_121 (68) = happyFail []
action_121 (69) = happyFail []
action_121 (70) = happyFail []
action_121 (71) = happyFail []
action_121 (72) = happyShift action_85
action_121 (73) = happyShift action_86
action_121 (74) = happyShift action_87
action_121 (75) = happyShift action_88
action_121 (76) = happyShift action_89
action_121 _ = happyReduce_80

action_122 (29) = happyShift action_75
action_122 (35) = happyShift action_76
action_122 (46) = happyShift action_77
action_122 (51) = happyShift action_78
action_122 (66) = happyFail []
action_122 (67) = happyFail []
action_122 (68) = happyFail []
action_122 (69) = happyFail []
action_122 (70) = happyFail []
action_122 (71) = happyFail []
action_122 (72) = happyShift action_85
action_122 (73) = happyShift action_86
action_122 (74) = happyShift action_87
action_122 (75) = happyShift action_88
action_122 (76) = happyShift action_89
action_122 _ = happyReduce_81

action_123 (29) = happyShift action_75
action_123 (35) = happyShift action_76
action_123 (46) = happyShift action_77
action_123 (51) = happyShift action_78
action_123 (66) = happyFail []
action_123 (67) = happyFail []
action_123 (68) = happyFail []
action_123 (69) = happyFail []
action_123 (70) = happyFail []
action_123 (71) = happyFail []
action_123 (72) = happyShift action_85
action_123 (73) = happyShift action_86
action_123 (74) = happyShift action_87
action_123 (75) = happyShift action_88
action_123 (76) = happyShift action_89
action_123 _ = happyReduce_78

action_124 (29) = happyShift action_75
action_124 (35) = happyShift action_76
action_124 (46) = happyShift action_77
action_124 (74) = happyShift action_87
action_124 (75) = happyShift action_88
action_124 (76) = happyShift action_89
action_124 _ = happyReduce_76

action_125 (76) = happyShift action_89
action_125 _ = happyReduce_75

action_126 (76) = happyShift action_89
action_126 _ = happyReduce_74

action_127 (76) = happyShift action_89
action_127 _ = happyReduce_77

action_128 (29) = happyShift action_75
action_128 (35) = happyShift action_76
action_128 (46) = happyShift action_77
action_128 (51) = happyShift action_78
action_128 (66) = happyShift action_79
action_128 (67) = happyShift action_80
action_128 (68) = happyShift action_81
action_128 (69) = happyShift action_82
action_128 (70) = happyShift action_83
action_128 (71) = happyShift action_84
action_128 (72) = happyShift action_85
action_128 (73) = happyShift action_86
action_128 (74) = happyShift action_87
action_128 (75) = happyShift action_88
action_128 (76) = happyShift action_89
action_128 (86) = happyShift action_148
action_128 _ = happyFail (happyExpListPerState 128)

action_129 (29) = happyShift action_75
action_129 (35) = happyShift action_76
action_129 (46) = happyShift action_77
action_129 (51) = happyShift action_78
action_129 (66) = happyShift action_79
action_129 (67) = happyShift action_80
action_129 (68) = happyShift action_81
action_129 (69) = happyShift action_82
action_129 (70) = happyShift action_83
action_129 (71) = happyShift action_84
action_129 (72) = happyShift action_85
action_129 (73) = happyShift action_86
action_129 (74) = happyShift action_87
action_129 (75) = happyShift action_88
action_129 (76) = happyShift action_89
action_129 _ = happyReduce_35

action_130 _ = happyReduce_49

action_131 (37) = happyReduce_45
action_131 (38) = happyReduce_45
action_131 (79) = happyReduce_45
action_131 (85) = happyShift action_74
action_131 _ = happyReduce_50

action_132 (31) = happyShift action_11
action_132 (34) = happyShift action_33
action_132 (39) = happyShift action_34
action_132 (42) = happyShift action_35
action_132 (43) = happyShift action_36
action_132 (47) = happyShift action_37
action_132 (48) = happyShift action_38
action_132 (49) = happyShift action_39
action_132 (55) = happyShift action_40
action_132 (56) = happyShift action_41
action_132 (58) = happyShift action_42
action_132 (60) = happyShift action_43
action_132 (61) = happyShift action_44
action_132 (62) = happyShift action_45
action_132 (63) = happyShift action_46
action_132 (64) = happyShift action_47
action_132 (65) = happyShift action_48
action_132 (72) = happyShift action_49
action_132 (73) = happyShift action_50
action_132 (77) = happyShift action_51
action_132 (81) = happyShift action_52
action_132 (18) = happyGoto action_26
action_132 (20) = happyGoto action_147
action_132 (23) = happyGoto action_29
action_132 (24) = happyGoto action_30
action_132 (25) = happyGoto action_31
action_132 (26) = happyGoto action_32
action_132 _ = happyReduce_34

action_133 (29) = happyShift action_75
action_133 (35) = happyShift action_76
action_133 (46) = happyShift action_77
action_133 (51) = happyShift action_78
action_133 (66) = happyShift action_79
action_133 (67) = happyShift action_80
action_133 (68) = happyShift action_81
action_133 (69) = happyShift action_82
action_133 (70) = happyShift action_83
action_133 (71) = happyShift action_84
action_133 (72) = happyShift action_85
action_133 (73) = happyShift action_86
action_133 (74) = happyShift action_87
action_133 (75) = happyShift action_88
action_133 (76) = happyShift action_89
action_133 (86) = happyShift action_146
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (37) = happyReduce_44
action_134 (38) = happyReduce_44
action_134 (79) = happyReduce_44
action_134 (85) = happyShift action_74
action_134 _ = happyReduce_50

action_135 (31) = happyShift action_11
action_135 (34) = happyShift action_33
action_135 (39) = happyShift action_34
action_135 (42) = happyShift action_35
action_135 (43) = happyShift action_36
action_135 (47) = happyShift action_37
action_135 (48) = happyShift action_38
action_135 (49) = happyShift action_39
action_135 (55) = happyShift action_40
action_135 (56) = happyShift action_41
action_135 (58) = happyShift action_42
action_135 (60) = happyShift action_43
action_135 (61) = happyShift action_44
action_135 (62) = happyShift action_45
action_135 (63) = happyShift action_46
action_135 (64) = happyShift action_47
action_135 (65) = happyShift action_48
action_135 (72) = happyShift action_49
action_135 (73) = happyShift action_50
action_135 (77) = happyShift action_51
action_135 (81) = happyShift action_52
action_135 (18) = happyGoto action_26
action_135 (20) = happyGoto action_145
action_135 (23) = happyGoto action_29
action_135 (24) = happyGoto action_30
action_135 (25) = happyGoto action_31
action_135 (26) = happyGoto action_32
action_135 _ = happyReduce_34

action_136 _ = happyReduce_41

action_137 (29) = happyShift action_75
action_137 (35) = happyShift action_76
action_137 (46) = happyShift action_77
action_137 (51) = happyShift action_78
action_137 (66) = happyShift action_79
action_137 (67) = happyShift action_80
action_137 (68) = happyShift action_81
action_137 (69) = happyShift action_82
action_137 (70) = happyShift action_83
action_137 (71) = happyShift action_84
action_137 (72) = happyShift action_85
action_137 (73) = happyShift action_86
action_137 (74) = happyShift action_87
action_137 (75) = happyShift action_88
action_137 (76) = happyShift action_89
action_137 _ = happyReduce_87

action_138 (82) = happyShift action_144
action_138 _ = happyFail (happyExpListPerState 138)

action_139 (84) = happyShift action_143
action_139 _ = happyReduce_86

action_140 _ = happyReduce_63

action_141 _ = happyReduce_57

action_142 _ = happyReduce_7

action_143 (39) = happyShift action_34
action_143 (48) = happyShift action_38
action_143 (49) = happyShift action_39
action_143 (55) = happyShift action_40
action_143 (58) = happyShift action_42
action_143 (61) = happyShift action_58
action_143 (62) = happyShift action_45
action_143 (63) = happyShift action_46
action_143 (64) = happyShift action_47
action_143 (65) = happyShift action_48
action_143 (72) = happyShift action_49
action_143 (73) = happyShift action_50
action_143 (77) = happyShift action_51
action_143 (81) = happyShift action_52
action_143 (23) = happyGoto action_163
action_143 (24) = happyGoto action_61
action_143 (25) = happyGoto action_31
action_143 (26) = happyGoto action_57
action_143 _ = happyFail (happyExpListPerState 143)

action_144 _ = happyReduce_84

action_145 _ = happyReduce_40

action_146 _ = happyReduce_47

action_147 (37) = happyShift action_162
action_147 _ = happyReduce_38

action_148 _ = happyReduce_55

action_149 (83) = happyShift action_161
action_149 _ = happyFail (happyExpListPerState 149)

action_150 (83) = happyShift action_160
action_150 (84) = happyShift action_95
action_150 _ = happyFail (happyExpListPerState 150)

action_151 (59) = happyShift action_110
action_151 (14) = happyGoto action_159
action_151 (15) = happyGoto action_109
action_151 _ = happyReduce_21

action_152 _ = happyReduce_14

action_153 _ = happyReduce_28

action_154 (50) = happyShift action_158
action_154 _ = happyFail (happyExpListPerState 154)

action_155 (62) = happyShift action_157
action_155 _ = happyFail (happyExpListPerState 155)

action_156 _ = happyReduce_11

action_157 (86) = happyShift action_168
action_157 _ = happyFail (happyExpListPerState 157)

action_158 (30) = happyShift action_100
action_158 (32) = happyShift action_101
action_158 (33) = happyShift action_102
action_158 (44) = happyShift action_103
action_158 (54) = happyShift action_104
action_158 (76) = happyShift action_105
action_158 (16) = happyGoto action_167
action_158 _ = happyFail (happyExpListPerState 158)

action_159 _ = happyReduce_19

action_160 (30) = happyShift action_100
action_160 (32) = happyShift action_101
action_160 (33) = happyShift action_102
action_160 (44) = happyShift action_103
action_160 (54) = happyShift action_104
action_160 (76) = happyShift action_105
action_160 (16) = happyGoto action_166
action_160 _ = happyFail (happyExpListPerState 160)

action_161 (30) = happyShift action_100
action_161 (32) = happyShift action_101
action_161 (33) = happyShift action_102
action_161 (44) = happyShift action_103
action_161 (54) = happyShift action_104
action_161 (76) = happyShift action_105
action_161 (16) = happyGoto action_165
action_161 _ = happyFail (happyExpListPerState 161)

action_162 (31) = happyShift action_11
action_162 (34) = happyShift action_33
action_162 (39) = happyShift action_34
action_162 (42) = happyShift action_35
action_162 (43) = happyShift action_36
action_162 (47) = happyShift action_37
action_162 (48) = happyShift action_38
action_162 (49) = happyShift action_39
action_162 (55) = happyShift action_40
action_162 (56) = happyShift action_41
action_162 (58) = happyShift action_42
action_162 (60) = happyShift action_43
action_162 (61) = happyShift action_44
action_162 (62) = happyShift action_45
action_162 (63) = happyShift action_46
action_162 (64) = happyShift action_47
action_162 (65) = happyShift action_48
action_162 (72) = happyShift action_49
action_162 (73) = happyShift action_50
action_162 (77) = happyShift action_51
action_162 (81) = happyShift action_52
action_162 (18) = happyGoto action_26
action_162 (20) = happyGoto action_164
action_162 (23) = happyGoto action_29
action_162 (24) = happyGoto action_30
action_162 (25) = happyGoto action_31
action_162 (26) = happyGoto action_32
action_162 _ = happyReduce_34

action_163 (29) = happyShift action_75
action_163 (35) = happyShift action_76
action_163 (46) = happyShift action_77
action_163 (51) = happyShift action_78
action_163 (66) = happyShift action_79
action_163 (67) = happyShift action_80
action_163 (68) = happyShift action_81
action_163 (69) = happyShift action_82
action_163 (70) = happyShift action_83
action_163 (71) = happyShift action_84
action_163 (72) = happyShift action_85
action_163 (73) = happyShift action_86
action_163 (74) = happyShift action_87
action_163 (75) = happyShift action_88
action_163 (76) = happyShift action_89
action_163 _ = happyReduce_88

action_164 _ = happyReduce_39

action_165 _ = happyReduce_15

action_166 _ = happyReduce_20

action_167 _ = happyReduce_27

action_168 _ = happyReduce_30

happyReduce_1 = happyReduce 5 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId          happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (P happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_2  5 happyReduction_2
happyReduction_2 (HappyAbsSyn18  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (B happy_var_1 happy_var_2
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_0  6 happyReduction_3
happyReduction_3  =  HappyAbsSyn6
		 ([]
	)

happyReduce_4 = happySpecReduce_2  6 happyReduction_4
happyReduction_4 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_2:happy_var_1
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  7 happyReduction_5
happyReduction_5 (HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (LoVar     happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  7 happyReduction_6
happyReduction_6 _
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (LoLabel   happy_var_2
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 4 7 happyReduction_7
happyReduction_7 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (LoHeadBod happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_3  7 happyReduction_8
happyReduction_8 _
	(HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (LoForward happy_var_2
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  8 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_2  8 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_2:happy_var_1
	)
happyReduction_10 _ _  = notHappyAtAll 

happyReduce_11 = happyReduce 4 9 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ((happy_var_1,happy_var_3)
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_1  10 happyReduction_12
happyReduction_12 (HappyTerminal (TId          happy_var_1))
	 =  HappyAbsSyn10
		 ([happy_var_1]
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  10 happyReduction_13
happyReduction_13 (HappyTerminal (TId          happy_var_3))
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_3:happy_var_1
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 5 11 happyReduction_14
happyReduction_14 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId          happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Procedure happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 7 11 happyReduction_15
happyReduction_15 ((HappyAbsSyn16  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId          happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Function  happy_var_2 happy_var_4 happy_var_7
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_0  12 happyReduction_16
happyReduction_16  =  HappyAbsSyn12
		 ([]
	)

happyReduce_17 = happySpecReduce_1  12 happyReduction_17
happyReduction_17 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  13 happyReduction_18
happyReduction_18 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  13 happyReduction_19
happyReduction_19 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_3:happy_var_1
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happyReduce 4 14 happyReduction_20
happyReduction_20 ((HappyAbsSyn16  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 ((happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_0  15 happyReduction_21
happyReduction_21  =  HappyAbsSyn15
		 ([]
	)

happyReduce_22 = happySpecReduce_1  15 happyReduction_22
happyReduction_22 _
	 =  HappyAbsSyn15
		 ([]
	)

happyReduce_23 = happySpecReduce_1  16 happyReduction_23
happyReduction_23 _
	 =  HappyAbsSyn16
		 (Tint
	)

happyReduce_24 = happySpecReduce_1  16 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn16
		 (Treal
	)

happyReduce_25 = happySpecReduce_1  16 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn16
		 (Tbool
	)

happyReduce_26 = happySpecReduce_1  16 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn16
		 (Tchar
	)

happyReduce_27 = happyReduce 4 16 happyReduction_27
happyReduction_27 ((HappyAbsSyn16  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (ArrayT   happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_2  16 happyReduction_28
happyReduction_28 (HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (PointerT happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_0  17 happyReduction_29
happyReduction_29  =  HappyAbsSyn17
		 (NoSize
	)

happyReduce_30 = happySpecReduce_3  17 happyReduction_30
happyReduction_30 _
	(HappyTerminal (TIntconst    happy_var_2))
	_
	 =  HappyAbsSyn17
		 (Size happy_var_2
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  18 happyReduction_31
happyReduction_31 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn18
		 (Bl happy_var_2
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  19 happyReduction_32
happyReduction_32 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  19 happyReduction_33
happyReduction_33 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_3 : happy_var_1
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_0  20 happyReduction_34
happyReduction_34  =  HappyAbsSyn20
		 (SEmpty
	)

happyReduce_35 = happySpecReduce_3  20 happyReduction_35
happyReduction_35 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn20
		 (SEqual   happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  20 happyReduction_36
happyReduction_36 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn20
		 (SBlock   happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn20
		 (SCall    happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happyReduce 4 20 happyReduction_38
happyReduction_38 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SIT      happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 6 20 happyReduction_39
happyReduction_39 ((HappyAbsSyn20  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SITE     happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_40 = happyReduce 4 20 happyReduction_40
happyReduction_40 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SWhile   happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_3  20 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_3)
	_
	(HappyTerminal (TId          happy_var_1))
	 =  HappyAbsSyn20
		 (SId      happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_2  20 happyReduction_42
happyReduction_42 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (SGoto    (tokenizer happy_var_1)
	)
happyReduction_42 _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  20 happyReduction_43
happyReduction_43 _
	 =  HappyAbsSyn20
		 (SReturn
	)

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn24  happy_var_3)
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (SNew     happy_var_2 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 (HappyAbsSyn24  happy_var_3)
	_
	_
	 =  HappyAbsSyn20
		 (SDispose happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  21 happyReduction_46
happyReduction_46  =  HappyAbsSyn21
		 (EEmpty
	)

happyReduce_47 = happySpecReduce_3  21 happyReduction_47
happyReduction_47 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (happy_var_2
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_0  22 happyReduction_48
happyReduction_48  =  HappyAbsSyn22
		 ([]
	)

happyReduce_49 = happySpecReduce_2  22 happyReduction_49
happyReduction_49 _
	_
	 =  HappyAbsSyn22
		 ([]
	)

happyReduce_50 = happySpecReduce_1  23 happyReduction_50
happyReduction_50 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn21
		 (L happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  23 happyReduction_51
happyReduction_51 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn21
		 (R happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  24 happyReduction_52
happyReduction_52 (HappyTerminal (TId          happy_var_1))
	 =  HappyAbsSyn24
		 (LId        happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  24 happyReduction_53
happyReduction_53 _
	 =  HappyAbsSyn24
		 (LResult
	)

happyReduce_54 = happySpecReduce_1  24 happyReduction_54
happyReduction_54 (HappyTerminal (TStringconst happy_var_1))
	 =  HappyAbsSyn24
		 (LString    happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happyReduce 4 24 happyReduction_55
happyReduction_55 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (LValueExpr happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_2  24 happyReduction_56
happyReduction_56 _
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn24
		 (LExpr      happy_var_1
	)
happyReduction_56 _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  24 happyReduction_57
happyReduction_57 _
	(HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn24
		 (LParen     happy_var_2
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  25 happyReduction_58
happyReduction_58 (HappyTerminal (TIntconst    happy_var_1))
	 =  HappyAbsSyn25
		 (RInt     happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  25 happyReduction_59
happyReduction_59 _
	 =  HappyAbsSyn25
		 (RTrue
	)

happyReduce_60 = happySpecReduce_1  25 happyReduction_60
happyReduction_60 _
	 =  HappyAbsSyn25
		 (RFalse
	)

happyReduce_61 = happySpecReduce_1  25 happyReduction_61
happyReduction_61 (HappyTerminal (TRealconst   happy_var_1))
	 =  HappyAbsSyn25
		 (RReal    happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  25 happyReduction_62
happyReduction_62 (HappyTerminal (TCharconst   happy_var_1))
	 =  HappyAbsSyn25
		 (RChar    happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  25 happyReduction_63
happyReduction_63 _
	(HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (RParen   happy_var_2
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  25 happyReduction_64
happyReduction_64 _
	 =  HappyAbsSyn25
		 (RNil
	)

happyReduce_65 = happySpecReduce_1  25 happyReduction_65
happyReduction_65 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn25
		 (RCall    happy_var_1
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_2  25 happyReduction_66
happyReduction_66 (HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (RPapaki  happy_var_2
	)
happyReduction_66 _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  25 happyReduction_67
happyReduction_67 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (RNot     happy_var_2
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_2  25 happyReduction_68
happyReduction_68 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (RPos     happy_var_2
	)
happyReduction_68 _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_2  25 happyReduction_69
happyReduction_69 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (RNeg     happy_var_2
	)
happyReduction_69 _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  25 happyReduction_70
happyReduction_70 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RPlus    happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  25 happyReduction_71
happyReduction_71 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RMul     happy_var_1 happy_var_3
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  25 happyReduction_72
happyReduction_72 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RMinus   happy_var_1 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  25 happyReduction_73
happyReduction_73 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RRealDiv happy_var_1 happy_var_3
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_3  25 happyReduction_74
happyReduction_74 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RDiv     happy_var_1 happy_var_3
	)
happyReduction_74 _ _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_3  25 happyReduction_75
happyReduction_75 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RMod     happy_var_1 happy_var_3
	)
happyReduction_75 _ _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  25 happyReduction_76
happyReduction_76 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (ROr      happy_var_1 happy_var_3
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_3  25 happyReduction_77
happyReduction_77 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RAnd     happy_var_1 happy_var_3
	)
happyReduction_77 _ _ _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  25 happyReduction_78
happyReduction_78 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (REq      happy_var_1 happy_var_3
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  25 happyReduction_79
happyReduction_79 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RDiff    happy_var_1 happy_var_3
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_3  25 happyReduction_80
happyReduction_80 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RLess    happy_var_1 happy_var_3
	)
happyReduction_80 _ _ _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  25 happyReduction_81
happyReduction_81 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RGreater happy_var_1 happy_var_3
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_3  25 happyReduction_82
happyReduction_82 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RGreq    happy_var_1 happy_var_3
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_3  25 happyReduction_83
happyReduction_83 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (RSmeq    happy_var_1 happy_var_3
	)
happyReduction_83 _ _ _  = notHappyAtAll 

happyReduce_84 = happyReduce 4 26 happyReduction_84
happyReduction_84 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId          happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (CId happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_85 = happySpecReduce_0  27 happyReduction_85
happyReduction_85  =  HappyAbsSyn27
		 ([]
	)

happyReduce_86 = happySpecReduce_1  27 happyReduction_86
happyReduction_86 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_1  28 happyReduction_87
happyReduction_87 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn27
		 ([happy_var_1]
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_3  28 happyReduction_88
happyReduction_88 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_3:happy_var_1
	)
happyReduction_88 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 87 87 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TAnd -> cont 29;
	TArray -> cont 30;
	TBegin -> cont 31;
	TBoolean -> cont 32;
	TChar -> cont 33;
	TDispose -> cont 34;
	TDivInt -> cont 35;
	TDo -> cont 36;
	TElse -> cont 37;
	TEnd -> cont 38;
	TFalse -> cont 39;
	TForward -> cont 40;
	TFunction -> cont 41;
	TGoto -> cont 42;
	TIf -> cont 43;
	TInteger -> cont 44;
	TLabel -> cont 45;
	TMod -> cont 46;
	TNew -> cont 47;
	TNil -> cont 48;
	TNot -> cont 49;
	TOf -> cont 50;
	TOr -> cont 51;
	TProcedure -> cont 52;
	TProgram -> cont 53;
	TReal -> cont 54;
	TResult -> cont 55;
	TReturn -> cont 56;
	TThen -> cont 57;
	TTrue -> cont 58;
	TVar -> cont 59;
	TWhile -> cont 60;
	TId          happy_dollar_dollar -> cont 61;
	TIntconst    happy_dollar_dollar -> cont 62;
	TRealconst   happy_dollar_dollar -> cont 63;
	TCharconst   happy_dollar_dollar -> cont 64;
	TStringconst happy_dollar_dollar -> cont 65;
	TLogiceq -> cont 66;
	TGreater -> cont 67;
	TSmaller -> cont 68;
	TDifferent -> cont 69;
	TGreaterequal -> cont 70;
	TSmallerequal -> cont 71;
	TAdd -> cont 72;
	TMinus -> cont 73;
	TMul -> cont 74;
	TDivReal -> cont 75;
	TPointer -> cont 76;
	TAdress -> cont 77;
	TEq -> cont 78;
	TSeperator -> cont 79;
	TDot -> cont 80;
	TLeftparen -> cont 81;
	TRightparen -> cont 82;
	TUpdown -> cont 83;
	TComma -> cont 84;
	TLeftbracket -> cont 85;
	TRightbracket -> cont 86;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 87 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> parseError tokens)
parse tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError _ = error "Parse error\n"

tokenizer :: Token -> String
tokenizer token = show token

data Program =
  P Id Body
  deriving(Show)

data Body =
  B [Local] Block
  deriving(Show)

type Id        = String
type Ids       = [Id]
type Variables = [(Ids,Type)]

data Local =
  LoVar Variables       |
  LoLabel Ids           |
  LoHeadBod Header Body |
  LoForward Header
  deriving(Show)

data Header =
  Procedure Id Args |
  Function  Id Args Type
  deriving(Show)

type Formal = (Ids,Type)
type Args   = [Formal]

data Type =
  Tint                | 
  Treal               |
  Tbool               |
  Tchar               |
  Tlabel              |
  Tproc Args          |
  Tfunc Args Type     |
  TFproc Args         |
  TFfunc Args Type    |
  ArrayT ArrSize Type |
  PointerT Type 
  deriving(Show,Eq)

data ArrSize =
  Size Int |
  NoSize
  deriving(Show,Eq)

data Block =
  Bl Stmts
  deriving(Show)
  
type Stmts = [Stmt]

data Stmt = 
  SEmpty              | 
  SEqual LValue Expr  |
  SBlock Block        |
  SCall Call          |
  SIT  Expr Stmt      |
  SITE Expr Stmt Stmt |
  SWhile Expr Stmt    |
  SId Id Stmt         |
  SGoto Id            |
  SReturn             |
  SNew Expr LValue    |
  SDispose LValue     |
  SElse Stmt
  deriving(Show)

type Exprs = [Expr]

data Expr =
 L LValue |
 R RValue |
 EEmpty
 deriving(Show)

data LValue =
  LId Id                 |
  LResult                |
  LString String         |
  LValueExpr LValue Expr |
  LExpr Expr             |
  LParen LValue
  deriving(Show)

data RValue =
  RInt Int           |
  RTrue              |
  RFalse             |
  RReal Double       |
  RChar Char         |
  RParen RValue      |
  RNil               |
  RCall    Call      |
  RPapaki  LValue    |
  RNot     Expr      |
  RPos     Expr      |
  RNeg     Expr      |
  RPlus    Expr Expr |
  RMul     Expr Expr |
  RMinus   Expr Expr |
  RRealDiv Expr Expr |
  RDiv     Expr Expr |
  RMod     Expr Expr |
  ROr      Expr Expr |
  RAnd     Expr Expr |
  REq      Expr Expr |
  RDiff    Expr Expr |
  RLess    Expr Expr |
  RGreater Expr Expr |
  RGreq    Expr Expr |
  RSmeq    Expr Expr
  deriving(Show)

data Call =
  CId Id [Expr]
  deriving(Show)

parser = getContents >>= return . parse . alexScanTokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc8814_0/ghc_2.h" #-}




























































































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 









{-# LINE 43 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Int Happy_IntList







{-# LINE 65 "templates/GenericTemplate.hs" #-}

{-# LINE 75 "templates/GenericTemplate.hs" #-}

{-# LINE 84 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 137 "templates/GenericTemplate.hs" #-}

{-# LINE 147 "templates/GenericTemplate.hs" #-}
indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 267 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 333 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
