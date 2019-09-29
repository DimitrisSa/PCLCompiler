{-# OPTIONS_GHC -w #-}
module Main where
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.11

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21
	| HappyAbsSyn22 t22
	| HappyAbsSyn23 t23
	| HappyAbsSyn24 t24
	| HappyAbsSyn25 t25
	| HappyAbsSyn26 t26
	| HappyAbsSyn27 t27
	| HappyAbsSyn28 t28
	| HappyAbsSyn29 t29
	| HappyAbsSyn30 t30
	| HappyAbsSyn31 t31

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,453) ([0,0,0,128,0,0,0,0,0,2,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,16384,0,0,128,4131,8,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,32768,35972,62851,8963,2,0,0,16392,0,0,0,0,0,0,2,0,0,0,0,2048,0,0,0,0,0,32,0,0,0,0,32768,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,520,528,65280,7,0,0,0,0,16384,32,0,0,0,0,0,0,0,0,0,0,0,0,0,49184,63776,35008,0,0,0,0,0,8192,0,0,0,0,0,0,0,0,0,512,0,0,0,8192,8384,49401,136,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12296,15944,8752,0,0,0,0,0,640,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12296,15944,8752,0,0,8192,8384,49401,136,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,576,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,2,0,8192,8384,49401,136,0,32768,35972,62851,8963,2,0,24704,8448,61440,127,0,0,0,0,0,512,0,0,49184,63776,35008,0,0,32768,33536,996,547,0,32768,32,2081,32752,0,0,0,0,0,0,0,0,8192,8384,49401,136,0,0,0,0,0,64,0,0,0,0,0,0,0,2048,18480,12350,34,0,0,49184,63776,35008,0,0,32768,33536,996,547,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,8384,49401,136,0,0,0,0,0,0,0,0,3074,3986,2188,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,128,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,0,1056,0,0,0,2048,0,0,0,0,0,0,24576,0,0,0,0,0,0,0,0,0,0,0,6,0,832,16400,0,16,0,0,0,32768,0,0,0,0,0,0,16384,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,16,0,0,0,0,0,0,0,8480,24803,49405,136,0,0,0,0,4096,0,0,8320,256,0,112,0,0,0,0,0,0,0,2048,4098,2,2047,16,0,2080,2112,64512,31,0,0,0,0,0,0,0,0,0,0,0,2,0,8480,24803,49405,136,0,8192,16392,8,8188,64,0,0,0,0,32768,0,0,51272,22584,12351,34,0,0,0,0,0,0,0,2080,2112,64512,31,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2048,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,832,16400,0,16,0,0,16397,256,16384,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6144,0,0,16397,256,16384,0,0,0,0,0,0,0,0,8480,24803,49405,136,0,0,128,58499,8963,2,0,8320,8448,61440,127,0,0,0,0,0,0,0,0,0,0,0,0,0,832,16400,0,16,0,0,0,0,0,256,0,13312,256,4,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_calc","Program","Body","Bodyrec","Local","Variables","Morevariables","Labels","Header","Arguments1","Arguments2","Formal","Vars","Type","Array","Block","Stmts","Stmt","Else","New","Dispose","Expr","LValue","RValue","Call","Call2","Call3","Unop","Binop","and","array","begin","boolean","char","dispose","div","do","else","end","false","forward","function","goto","if","integer","label","mod","new","nil","not","of","or","procedure","program","real","result","return","then","true","var","while","id","intconst","realconst","charconst","stringconst","'='","'>'","'<'","diff","greq","smeq","'+'","'-'","'*'","'/'","'^'","'@'","equal","';'","'.'","'('","')'","':'","','","'['","']'","%eof"]
        bit_start = st * 90
        bit_end = (st + 1) * 90
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..89]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (56) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (56) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (64) = happyShift action_4
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (90) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (82) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (5) = happyGoto action_6
action_5 (6) = happyGoto action_7
action_5 _ = happyReduce_4

action_6 (83) = happyShift action_17
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (34) = happyShift action_11
action_7 (43) = happyShift action_12
action_7 (44) = happyShift action_13
action_7 (48) = happyShift action_14
action_7 (55) = happyShift action_15
action_7 (62) = happyShift action_16
action_7 (7) = happyGoto action_8
action_7 (11) = happyGoto action_9
action_7 (18) = happyGoto action_10
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_3

action_9 (82) = happyShift action_51
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_2

action_11 (34) = happyShift action_11
action_11 (37) = happyShift action_31
action_11 (42) = happyShift action_32
action_11 (45) = happyShift action_33
action_11 (46) = happyShift action_34
action_11 (50) = happyShift action_35
action_11 (51) = happyShift action_36
action_11 (52) = happyShift action_37
action_11 (58) = happyShift action_38
action_11 (59) = happyShift action_39
action_11 (61) = happyShift action_40
action_11 (63) = happyShift action_41
action_11 (64) = happyShift action_42
action_11 (65) = happyShift action_43
action_11 (66) = happyShift action_44
action_11 (67) = happyShift action_45
action_11 (68) = happyShift action_46
action_11 (75) = happyShift action_47
action_11 (76) = happyShift action_48
action_11 (80) = happyShift action_49
action_11 (84) = happyShift action_50
action_11 (18) = happyGoto action_24
action_11 (20) = happyGoto action_25
action_11 (24) = happyGoto action_26
action_11 (25) = happyGoto action_27
action_11 (26) = happyGoto action_28
action_11 (27) = happyGoto action_29
action_11 (30) = happyGoto action_30
action_11 _ = happyReduce_35

action_12 (44) = happyShift action_13
action_12 (55) = happyShift action_15
action_12 (11) = happyGoto action_23
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (64) = happyShift action_22
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (64) = happyShift action_21
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (64) = happyShift action_20
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (64) = happyShift action_19
action_16 (8) = happyGoto action_18
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_1

action_18 (64) = happyShift action_93
action_18 _ = happyReduce_5

action_19 (9) = happyGoto action_92
action_19 _ = happyReduce_12

action_20 (84) = happyShift action_91
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (10) = happyGoto action_90
action_21 _ = happyReduce_14

action_22 (84) = happyShift action_89
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (82) = happyShift action_88
action_23 _ = happyFail (happyExpListPerState 23)

action_24 _ = happyReduce_37

action_25 (19) = happyGoto action_87
action_25 _ = happyReduce_34

action_26 (32) = happyShift action_72
action_26 (38) = happyShift action_73
action_26 (49) = happyShift action_74
action_26 (54) = happyShift action_75
action_26 (69) = happyShift action_76
action_26 (70) = happyShift action_77
action_26 (71) = happyShift action_78
action_26 (72) = happyShift action_79
action_26 (73) = happyShift action_80
action_26 (74) = happyShift action_81
action_26 (75) = happyShift action_82
action_26 (76) = happyShift action_83
action_26 (77) = happyShift action_84
action_26 (78) = happyShift action_85
action_26 (79) = happyShift action_86
action_26 (31) = happyGoto action_71
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (81) = happyShift action_69
action_27 (88) = happyShift action_70
action_27 _ = happyReduce_52

action_28 _ = happyReduce_53

action_29 (40) = happyReduce_38
action_29 (41) = happyReduce_38
action_29 (82) = happyReduce_38
action_29 _ = happyReduce_67

action_30 (42) = happyShift action_32
action_30 (51) = happyShift action_36
action_30 (52) = happyShift action_37
action_30 (58) = happyShift action_38
action_30 (61) = happyShift action_40
action_30 (64) = happyShift action_56
action_30 (65) = happyShift action_43
action_30 (66) = happyShift action_44
action_30 (67) = happyShift action_45
action_30 (68) = happyShift action_46
action_30 (75) = happyShift action_47
action_30 (76) = happyShift action_48
action_30 (80) = happyShift action_49
action_30 (84) = happyShift action_50
action_30 (24) = happyGoto action_68
action_30 (25) = happyGoto action_61
action_30 (26) = happyGoto action_28
action_30 (27) = happyGoto action_55
action_30 (30) = happyGoto action_30
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (88) = happyShift action_67
action_31 (23) = happyGoto action_66
action_31 _ = happyReduce_51

action_32 _ = happyReduce_62

action_33 (64) = happyShift action_65
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (42) = happyShift action_32
action_34 (51) = happyShift action_36
action_34 (52) = happyShift action_37
action_34 (58) = happyShift action_38
action_34 (61) = happyShift action_40
action_34 (64) = happyShift action_56
action_34 (65) = happyShift action_43
action_34 (66) = happyShift action_44
action_34 (67) = happyShift action_45
action_34 (68) = happyShift action_46
action_34 (75) = happyShift action_47
action_34 (76) = happyShift action_48
action_34 (80) = happyShift action_49
action_34 (84) = happyShift action_50
action_34 (24) = happyGoto action_64
action_34 (25) = happyGoto action_61
action_34 (26) = happyGoto action_28
action_34 (27) = happyGoto action_55
action_34 (30) = happyGoto action_30
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (88) = happyShift action_63
action_35 (22) = happyGoto action_62
action_35 _ = happyReduce_49

action_36 _ = happyReduce_66

action_37 _ = happyReduce_78

action_38 _ = happyReduce_55

action_39 _ = happyReduce_43

action_40 _ = happyReduce_61

action_41 (42) = happyShift action_32
action_41 (51) = happyShift action_36
action_41 (52) = happyShift action_37
action_41 (58) = happyShift action_38
action_41 (61) = happyShift action_40
action_41 (64) = happyShift action_56
action_41 (65) = happyShift action_43
action_41 (66) = happyShift action_44
action_41 (67) = happyShift action_45
action_41 (68) = happyShift action_46
action_41 (75) = happyShift action_47
action_41 (76) = happyShift action_48
action_41 (80) = happyShift action_49
action_41 (84) = happyShift action_50
action_41 (24) = happyGoto action_60
action_41 (25) = happyGoto action_61
action_41 (26) = happyGoto action_28
action_41 (27) = happyGoto action_55
action_41 (30) = happyGoto action_30
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (84) = happyShift action_58
action_42 (86) = happyShift action_59
action_42 _ = happyReduce_54

action_43 _ = happyReduce_60

action_44 _ = happyReduce_63

action_45 _ = happyReduce_64

action_46 _ = happyReduce_56

action_47 _ = happyReduce_79

action_48 _ = happyReduce_80

action_49 (42) = happyShift action_32
action_49 (51) = happyShift action_36
action_49 (52) = happyShift action_37
action_49 (58) = happyShift action_38
action_49 (61) = happyShift action_40
action_49 (64) = happyShift action_56
action_49 (65) = happyShift action_43
action_49 (66) = happyShift action_44
action_49 (67) = happyShift action_45
action_49 (68) = happyShift action_46
action_49 (75) = happyShift action_47
action_49 (76) = happyShift action_48
action_49 (80) = happyShift action_49
action_49 (84) = happyShift action_50
action_49 (24) = happyGoto action_26
action_49 (25) = happyGoto action_57
action_49 (26) = happyGoto action_28
action_49 (27) = happyGoto action_55
action_49 (30) = happyGoto action_30
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (42) = happyShift action_32
action_50 (51) = happyShift action_36
action_50 (52) = happyShift action_37
action_50 (58) = happyShift action_38
action_50 (61) = happyShift action_40
action_50 (64) = happyShift action_56
action_50 (65) = happyShift action_43
action_50 (66) = happyShift action_44
action_50 (67) = happyShift action_45
action_50 (68) = happyShift action_46
action_50 (75) = happyShift action_47
action_50 (76) = happyShift action_48
action_50 (80) = happyShift action_49
action_50 (84) = happyShift action_50
action_50 (24) = happyGoto action_26
action_50 (25) = happyGoto action_53
action_50 (26) = happyGoto action_54
action_50 (27) = happyGoto action_55
action_50 (30) = happyGoto action_30
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (5) = happyGoto action_52
action_51 (6) = happyGoto action_7
action_51 _ = happyReduce_4

action_52 (82) = happyShift action_123
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (85) = happyShift action_122
action_53 (88) = happyShift action_70
action_53 _ = happyReduce_52

action_54 (85) = happyShift action_121
action_54 _ = happyReduce_53

action_55 _ = happyReduce_67

action_56 (84) = happyShift action_58
action_56 _ = happyReduce_54

action_57 (32) = happyReduce_68
action_57 (38) = happyReduce_68
action_57 (49) = happyReduce_68
action_57 (54) = happyReduce_68
action_57 (69) = happyReduce_68
action_57 (70) = happyReduce_68
action_57 (71) = happyReduce_68
action_57 (72) = happyReduce_68
action_57 (73) = happyReduce_68
action_57 (74) = happyReduce_68
action_57 (75) = happyReduce_68
action_57 (76) = happyReduce_68
action_57 (77) = happyReduce_68
action_57 (78) = happyReduce_68
action_57 (79) = happyReduce_68
action_57 (88) = happyShift action_70
action_57 _ = happyReduce_68

action_58 (42) = happyShift action_32
action_58 (51) = happyShift action_36
action_58 (52) = happyShift action_37
action_58 (58) = happyShift action_38
action_58 (61) = happyShift action_40
action_58 (64) = happyShift action_56
action_58 (65) = happyShift action_43
action_58 (66) = happyShift action_44
action_58 (67) = happyShift action_45
action_58 (68) = happyShift action_46
action_58 (75) = happyShift action_47
action_58 (76) = happyShift action_48
action_58 (80) = happyShift action_49
action_58 (84) = happyShift action_50
action_58 (24) = happyGoto action_119
action_58 (25) = happyGoto action_61
action_58 (26) = happyGoto action_28
action_58 (27) = happyGoto action_55
action_58 (28) = happyGoto action_120
action_58 (30) = happyGoto action_30
action_58 _ = happyReduce_74

action_59 (34) = happyShift action_11
action_59 (37) = happyShift action_31
action_59 (42) = happyShift action_32
action_59 (45) = happyShift action_33
action_59 (46) = happyShift action_34
action_59 (50) = happyShift action_35
action_59 (51) = happyShift action_36
action_59 (52) = happyShift action_37
action_59 (58) = happyShift action_38
action_59 (59) = happyShift action_39
action_59 (61) = happyShift action_40
action_59 (63) = happyShift action_41
action_59 (64) = happyShift action_42
action_59 (65) = happyShift action_43
action_59 (66) = happyShift action_44
action_59 (67) = happyShift action_45
action_59 (68) = happyShift action_46
action_59 (75) = happyShift action_47
action_59 (76) = happyShift action_48
action_59 (80) = happyShift action_49
action_59 (84) = happyShift action_50
action_59 (18) = happyGoto action_24
action_59 (20) = happyGoto action_118
action_59 (24) = happyGoto action_26
action_59 (25) = happyGoto action_27
action_59 (26) = happyGoto action_28
action_59 (27) = happyGoto action_29
action_59 (30) = happyGoto action_30
action_59 _ = happyReduce_35

action_60 (32) = happyShift action_72
action_60 (38) = happyShift action_73
action_60 (39) = happyShift action_117
action_60 (49) = happyShift action_74
action_60 (54) = happyShift action_75
action_60 (69) = happyShift action_76
action_60 (70) = happyShift action_77
action_60 (71) = happyShift action_78
action_60 (72) = happyShift action_79
action_60 (73) = happyShift action_80
action_60 (74) = happyShift action_81
action_60 (75) = happyShift action_82
action_60 (76) = happyShift action_83
action_60 (77) = happyShift action_84
action_60 (78) = happyShift action_85
action_60 (79) = happyShift action_86
action_60 (31) = happyGoto action_71
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (88) = happyShift action_70
action_61 _ = happyReduce_52

action_62 (42) = happyShift action_32
action_62 (51) = happyShift action_36
action_62 (52) = happyShift action_37
action_62 (58) = happyShift action_38
action_62 (61) = happyShift action_40
action_62 (64) = happyShift action_56
action_62 (65) = happyShift action_43
action_62 (66) = happyShift action_44
action_62 (67) = happyShift action_45
action_62 (68) = happyShift action_46
action_62 (75) = happyShift action_47
action_62 (76) = happyShift action_48
action_62 (80) = happyShift action_49
action_62 (84) = happyShift action_50
action_62 (24) = happyGoto action_26
action_62 (25) = happyGoto action_116
action_62 (26) = happyGoto action_28
action_62 (27) = happyGoto action_55
action_62 (30) = happyGoto action_30
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (42) = happyShift action_32
action_63 (51) = happyShift action_36
action_63 (52) = happyShift action_37
action_63 (58) = happyShift action_38
action_63 (61) = happyShift action_40
action_63 (64) = happyShift action_56
action_63 (65) = happyShift action_43
action_63 (66) = happyShift action_44
action_63 (67) = happyShift action_45
action_63 (68) = happyShift action_46
action_63 (75) = happyShift action_47
action_63 (76) = happyShift action_48
action_63 (80) = happyShift action_49
action_63 (84) = happyShift action_50
action_63 (24) = happyGoto action_115
action_63 (25) = happyGoto action_61
action_63 (26) = happyGoto action_28
action_63 (27) = happyGoto action_55
action_63 (30) = happyGoto action_30
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (32) = happyShift action_72
action_64 (38) = happyShift action_73
action_64 (49) = happyShift action_74
action_64 (54) = happyShift action_75
action_64 (60) = happyShift action_114
action_64 (69) = happyShift action_76
action_64 (70) = happyShift action_77
action_64 (71) = happyShift action_78
action_64 (72) = happyShift action_79
action_64 (73) = happyShift action_80
action_64 (74) = happyShift action_81
action_64 (75) = happyShift action_82
action_64 (76) = happyShift action_83
action_64 (77) = happyShift action_84
action_64 (78) = happyShift action_85
action_64 (79) = happyShift action_86
action_64 (31) = happyGoto action_71
action_64 _ = happyFail (happyExpListPerState 64)

action_65 _ = happyReduce_42

action_66 (42) = happyShift action_32
action_66 (51) = happyShift action_36
action_66 (52) = happyShift action_37
action_66 (58) = happyShift action_38
action_66 (61) = happyShift action_40
action_66 (64) = happyShift action_56
action_66 (65) = happyShift action_43
action_66 (66) = happyShift action_44
action_66 (67) = happyShift action_45
action_66 (68) = happyShift action_46
action_66 (75) = happyShift action_47
action_66 (76) = happyShift action_48
action_66 (80) = happyShift action_49
action_66 (84) = happyShift action_50
action_66 (24) = happyGoto action_26
action_66 (25) = happyGoto action_113
action_66 (26) = happyGoto action_28
action_66 (27) = happyGoto action_55
action_66 (30) = happyGoto action_30
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (89) = happyShift action_112
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (32) = happyShift action_72
action_68 (38) = happyShift action_73
action_68 (49) = happyShift action_74
action_68 (54) = happyShift action_75
action_68 (69) = happyShift action_76
action_68 (70) = happyShift action_77
action_68 (71) = happyShift action_78
action_68 (72) = happyShift action_79
action_68 (73) = happyShift action_80
action_68 (74) = happyShift action_81
action_68 (75) = happyShift action_82
action_68 (76) = happyShift action_83
action_68 (77) = happyShift action_84
action_68 (78) = happyShift action_85
action_68 (79) = happyShift action_86
action_68 (31) = happyGoto action_71
action_68 _ = happyReduce_69

action_69 (42) = happyShift action_32
action_69 (51) = happyShift action_36
action_69 (52) = happyShift action_37
action_69 (58) = happyShift action_38
action_69 (61) = happyShift action_40
action_69 (64) = happyShift action_56
action_69 (65) = happyShift action_43
action_69 (66) = happyShift action_44
action_69 (67) = happyShift action_45
action_69 (68) = happyShift action_46
action_69 (75) = happyShift action_47
action_69 (76) = happyShift action_48
action_69 (80) = happyShift action_49
action_69 (84) = happyShift action_50
action_69 (24) = happyGoto action_111
action_69 (25) = happyGoto action_61
action_69 (26) = happyGoto action_28
action_69 (27) = happyGoto action_55
action_69 (30) = happyGoto action_30
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (42) = happyShift action_32
action_70 (51) = happyShift action_36
action_70 (52) = happyShift action_37
action_70 (58) = happyShift action_38
action_70 (61) = happyShift action_40
action_70 (64) = happyShift action_56
action_70 (65) = happyShift action_43
action_70 (66) = happyShift action_44
action_70 (67) = happyShift action_45
action_70 (68) = happyShift action_46
action_70 (75) = happyShift action_47
action_70 (76) = happyShift action_48
action_70 (80) = happyShift action_49
action_70 (84) = happyShift action_50
action_70 (24) = happyGoto action_110
action_70 (25) = happyGoto action_61
action_70 (26) = happyGoto action_28
action_70 (27) = happyGoto action_55
action_70 (30) = happyGoto action_30
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (42) = happyShift action_32
action_71 (51) = happyShift action_36
action_71 (52) = happyShift action_37
action_71 (58) = happyShift action_38
action_71 (61) = happyShift action_40
action_71 (64) = happyShift action_56
action_71 (65) = happyShift action_43
action_71 (66) = happyShift action_44
action_71 (67) = happyShift action_45
action_71 (68) = happyShift action_46
action_71 (75) = happyShift action_47
action_71 (76) = happyShift action_48
action_71 (80) = happyShift action_49
action_71 (84) = happyShift action_50
action_71 (24) = happyGoto action_109
action_71 (25) = happyGoto action_61
action_71 (26) = happyGoto action_28
action_71 (27) = happyGoto action_55
action_71 (30) = happyGoto action_30
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_86

action_73 _ = happyReduce_83

action_74 _ = happyReduce_84

action_75 _ = happyReduce_85

action_76 _ = happyReduce_87

action_77 _ = happyReduce_90

action_78 _ = happyReduce_89

action_79 _ = happyReduce_88

action_80 _ = happyReduce_91

action_81 _ = happyReduce_92

action_82 (42) = happyShift action_32
action_82 (51) = happyShift action_36
action_82 (52) = happyShift action_37
action_82 (58) = happyShift action_38
action_82 (61) = happyShift action_40
action_82 (64) = happyShift action_56
action_82 (65) = happyShift action_43
action_82 (66) = happyShift action_44
action_82 (67) = happyShift action_45
action_82 (68) = happyShift action_46
action_82 (75) = happyShift action_47
action_82 (76) = happyShift action_48
action_82 (80) = happyShift action_49
action_82 (84) = happyShift action_50
action_82 (24) = happyGoto action_108
action_82 (25) = happyGoto action_61
action_82 (26) = happyGoto action_28
action_82 (27) = happyGoto action_55
action_82 (30) = happyGoto action_30
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_81

action_84 (42) = happyShift action_32
action_84 (51) = happyShift action_36
action_84 (52) = happyShift action_37
action_84 (58) = happyShift action_38
action_84 (61) = happyShift action_40
action_84 (64) = happyShift action_56
action_84 (65) = happyShift action_43
action_84 (66) = happyShift action_44
action_84 (67) = happyShift action_45
action_84 (68) = happyShift action_46
action_84 (75) = happyShift action_47
action_84 (76) = happyShift action_48
action_84 (80) = happyShift action_49
action_84 (84) = happyShift action_50
action_84 (24) = happyGoto action_107
action_84 (25) = happyGoto action_61
action_84 (26) = happyGoto action_28
action_84 (27) = happyGoto action_55
action_84 (30) = happyGoto action_30
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_82

action_86 _ = happyReduce_58

action_87 (41) = happyShift action_105
action_87 (82) = happyShift action_106
action_87 _ = happyFail (happyExpListPerState 87)

action_88 _ = happyReduce_8

action_89 (62) = happyShift action_101
action_89 (85) = happyReduce_17
action_89 (12) = happyGoto action_104
action_89 (13) = happyGoto action_98
action_89 (14) = happyGoto action_99
action_89 (15) = happyGoto action_100
action_89 _ = happyReduce_22

action_90 (82) = happyShift action_102
action_90 (87) = happyShift action_103
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (62) = happyShift action_101
action_91 (85) = happyReduce_17
action_91 (12) = happyGoto action_97
action_91 (13) = happyGoto action_98
action_91 (14) = happyGoto action_99
action_91 (15) = happyGoto action_100
action_91 _ = happyReduce_22

action_92 (86) = happyShift action_95
action_92 (87) = happyShift action_96
action_92 _ = happyFail (happyExpListPerState 92)

action_93 (9) = happyGoto action_94
action_93 _ = happyReduce_12

action_94 (86) = happyShift action_144
action_94 (87) = happyShift action_96
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (33) = happyShift action_138
action_95 (35) = happyShift action_139
action_95 (36) = happyShift action_140
action_95 (47) = happyShift action_141
action_95 (57) = happyShift action_142
action_95 (79) = happyShift action_143
action_95 (16) = happyGoto action_137
action_95 _ = happyFail (happyExpListPerState 95)

action_96 (64) = happyShift action_136
action_96 _ = happyFail (happyExpListPerState 96)

action_97 (85) = happyShift action_135
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (82) = happyShift action_134
action_98 _ = happyReduce_18

action_99 _ = happyReduce_20

action_100 (64) = happyShift action_133
action_100 _ = happyFail (happyExpListPerState 100)

action_101 _ = happyReduce_23

action_102 _ = happyReduce_6

action_103 (64) = happyShift action_132
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (85) = happyShift action_131
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_32

action_106 (34) = happyShift action_11
action_106 (37) = happyShift action_31
action_106 (42) = happyShift action_32
action_106 (45) = happyShift action_33
action_106 (46) = happyShift action_34
action_106 (50) = happyShift action_35
action_106 (51) = happyShift action_36
action_106 (52) = happyShift action_37
action_106 (58) = happyShift action_38
action_106 (59) = happyShift action_39
action_106 (61) = happyShift action_40
action_106 (63) = happyShift action_41
action_106 (64) = happyShift action_42
action_106 (65) = happyShift action_43
action_106 (66) = happyShift action_44
action_106 (67) = happyShift action_45
action_106 (68) = happyShift action_46
action_106 (75) = happyShift action_47
action_106 (76) = happyShift action_48
action_106 (80) = happyShift action_49
action_106 (84) = happyShift action_50
action_106 (18) = happyGoto action_24
action_106 (20) = happyGoto action_130
action_106 (24) = happyGoto action_26
action_106 (25) = happyGoto action_27
action_106 (26) = happyGoto action_28
action_106 (27) = happyGoto action_29
action_106 (30) = happyGoto action_30
action_106 _ = happyReduce_35

action_107 (79) = happyShift action_86
action_107 (31) = happyGoto action_71
action_107 _ = happyReduce_71

action_108 (32) = happyShift action_72
action_108 (38) = happyShift action_73
action_108 (49) = happyShift action_74
action_108 (77) = happyShift action_84
action_108 (78) = happyShift action_85
action_108 (79) = happyShift action_86
action_108 (31) = happyGoto action_71
action_108 _ = happyReduce_70

action_109 (32) = happyShift action_72
action_109 (38) = happyShift action_73
action_109 (49) = happyShift action_74
action_109 (54) = happyShift action_75
action_109 (69) = happyShift action_76
action_109 (70) = happyShift action_77
action_109 (71) = happyShift action_78
action_109 (72) = happyShift action_79
action_109 (73) = happyShift action_80
action_109 (74) = happyShift action_81
action_109 (75) = happyShift action_82
action_109 (76) = happyShift action_83
action_109 (77) = happyShift action_84
action_109 (78) = happyShift action_85
action_109 (79) = happyShift action_86
action_109 (31) = happyGoto action_71
action_109 _ = happyReduce_72

action_110 (32) = happyShift action_72
action_110 (38) = happyShift action_73
action_110 (49) = happyShift action_74
action_110 (54) = happyShift action_75
action_110 (69) = happyShift action_76
action_110 (70) = happyShift action_77
action_110 (71) = happyShift action_78
action_110 (72) = happyShift action_79
action_110 (73) = happyShift action_80
action_110 (74) = happyShift action_81
action_110 (75) = happyShift action_82
action_110 (76) = happyShift action_83
action_110 (77) = happyShift action_84
action_110 (78) = happyShift action_85
action_110 (79) = happyShift action_86
action_110 (89) = happyShift action_129
action_110 (31) = happyGoto action_71
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (32) = happyShift action_72
action_111 (38) = happyShift action_73
action_111 (49) = happyShift action_74
action_111 (54) = happyShift action_75
action_111 (69) = happyShift action_76
action_111 (70) = happyShift action_77
action_111 (71) = happyShift action_78
action_111 (72) = happyShift action_79
action_111 (73) = happyShift action_80
action_111 (74) = happyShift action_81
action_111 (75) = happyShift action_82
action_111 (76) = happyShift action_83
action_111 (77) = happyShift action_84
action_111 (78) = happyShift action_85
action_111 (79) = happyShift action_86
action_111 (31) = happyGoto action_71
action_111 _ = happyReduce_36

action_112 _ = happyReduce_50

action_113 (40) = happyReduce_45
action_113 (41) = happyReduce_45
action_113 (82) = happyReduce_45
action_113 (88) = happyShift action_70
action_113 _ = happyReduce_52

action_114 (34) = happyShift action_11
action_114 (37) = happyShift action_31
action_114 (42) = happyShift action_32
action_114 (45) = happyShift action_33
action_114 (46) = happyShift action_34
action_114 (50) = happyShift action_35
action_114 (51) = happyShift action_36
action_114 (52) = happyShift action_37
action_114 (58) = happyShift action_38
action_114 (59) = happyShift action_39
action_114 (61) = happyShift action_40
action_114 (63) = happyShift action_41
action_114 (64) = happyShift action_42
action_114 (65) = happyShift action_43
action_114 (66) = happyShift action_44
action_114 (67) = happyShift action_45
action_114 (68) = happyShift action_46
action_114 (75) = happyShift action_47
action_114 (76) = happyShift action_48
action_114 (80) = happyShift action_49
action_114 (84) = happyShift action_50
action_114 (18) = happyGoto action_24
action_114 (20) = happyGoto action_128
action_114 (24) = happyGoto action_26
action_114 (25) = happyGoto action_27
action_114 (26) = happyGoto action_28
action_114 (27) = happyGoto action_29
action_114 (30) = happyGoto action_30
action_114 _ = happyReduce_35

action_115 (32) = happyShift action_72
action_115 (38) = happyShift action_73
action_115 (49) = happyShift action_74
action_115 (54) = happyShift action_75
action_115 (69) = happyShift action_76
action_115 (70) = happyShift action_77
action_115 (71) = happyShift action_78
action_115 (72) = happyShift action_79
action_115 (73) = happyShift action_80
action_115 (74) = happyShift action_81
action_115 (75) = happyShift action_82
action_115 (76) = happyShift action_83
action_115 (77) = happyShift action_84
action_115 (78) = happyShift action_85
action_115 (79) = happyShift action_86
action_115 (89) = happyShift action_127
action_115 (31) = happyGoto action_71
action_115 _ = happyFail (happyExpListPerState 115)

action_116 (40) = happyReduce_44
action_116 (41) = happyReduce_44
action_116 (82) = happyReduce_44
action_116 (88) = happyShift action_70
action_116 _ = happyReduce_52

action_117 (34) = happyShift action_11
action_117 (37) = happyShift action_31
action_117 (42) = happyShift action_32
action_117 (45) = happyShift action_33
action_117 (46) = happyShift action_34
action_117 (50) = happyShift action_35
action_117 (51) = happyShift action_36
action_117 (52) = happyShift action_37
action_117 (58) = happyShift action_38
action_117 (59) = happyShift action_39
action_117 (61) = happyShift action_40
action_117 (63) = happyShift action_41
action_117 (64) = happyShift action_42
action_117 (65) = happyShift action_43
action_117 (66) = happyShift action_44
action_117 (67) = happyShift action_45
action_117 (68) = happyShift action_46
action_117 (75) = happyShift action_47
action_117 (76) = happyShift action_48
action_117 (80) = happyShift action_49
action_117 (84) = happyShift action_50
action_117 (18) = happyGoto action_24
action_117 (20) = happyGoto action_126
action_117 (24) = happyGoto action_26
action_117 (25) = happyGoto action_27
action_117 (26) = happyGoto action_28
action_117 (27) = happyGoto action_29
action_117 (30) = happyGoto action_30
action_117 _ = happyReduce_35

action_118 _ = happyReduce_41

action_119 (32) = happyShift action_72
action_119 (38) = happyShift action_73
action_119 (49) = happyShift action_74
action_119 (54) = happyShift action_75
action_119 (69) = happyShift action_76
action_119 (70) = happyShift action_77
action_119 (71) = happyShift action_78
action_119 (72) = happyShift action_79
action_119 (73) = happyShift action_80
action_119 (74) = happyShift action_81
action_119 (75) = happyShift action_82
action_119 (76) = happyShift action_83
action_119 (77) = happyShift action_84
action_119 (78) = happyShift action_85
action_119 (79) = happyShift action_86
action_119 (29) = happyGoto action_125
action_119 (31) = happyGoto action_71
action_119 _ = happyReduce_77

action_120 (85) = happyShift action_124
action_120 _ = happyFail (happyExpListPerState 120)

action_121 _ = happyReduce_65

action_122 _ = happyReduce_59

action_123 _ = happyReduce_7

action_124 _ = happyReduce_73

action_125 (87) = happyShift action_155
action_125 _ = happyReduce_75

action_126 _ = happyReduce_40

action_127 _ = happyReduce_48

action_128 (40) = happyShift action_154
action_128 (21) = happyGoto action_153
action_128 _ = happyReduce_47

action_129 _ = happyReduce_57

action_130 _ = happyReduce_33

action_131 (86) = happyShift action_152
action_131 _ = happyFail (happyExpListPerState 131)

action_132 _ = happyReduce_13

action_133 (10) = happyGoto action_151
action_133 _ = happyReduce_14

action_134 (62) = happyShift action_101
action_134 (14) = happyGoto action_150
action_134 (15) = happyGoto action_100
action_134 _ = happyReduce_22

action_135 _ = happyReduce_15

action_136 _ = happyReduce_11

action_137 (82) = happyShift action_149
action_137 _ = happyFail (happyExpListPerState 137)

action_138 (88) = happyShift action_148
action_138 (17) = happyGoto action_147
action_138 _ = happyReduce_31

action_139 _ = happyReduce_26

action_140 _ = happyReduce_27

action_141 _ = happyReduce_24

action_142 _ = happyReduce_25

action_143 (33) = happyShift action_138
action_143 (35) = happyShift action_139
action_143 (36) = happyShift action_140
action_143 (47) = happyShift action_141
action_143 (57) = happyShift action_142
action_143 (79) = happyShift action_143
action_143 (16) = happyGoto action_146
action_143 _ = happyFail (happyExpListPerState 143)

action_144 (33) = happyShift action_138
action_144 (35) = happyShift action_139
action_144 (36) = happyShift action_140
action_144 (47) = happyShift action_141
action_144 (57) = happyShift action_142
action_144 (79) = happyShift action_143
action_144 (16) = happyGoto action_145
action_144 _ = happyFail (happyExpListPerState 144)

action_145 (82) = happyShift action_162
action_145 _ = happyFail (happyExpListPerState 145)

action_146 _ = happyReduce_29

action_147 (53) = happyShift action_161
action_147 _ = happyFail (happyExpListPerState 147)

action_148 (65) = happyShift action_160
action_148 _ = happyFail (happyExpListPerState 148)

action_149 _ = happyReduce_10

action_150 _ = happyReduce_19

action_151 (86) = happyShift action_159
action_151 (87) = happyShift action_103
action_151 _ = happyFail (happyExpListPerState 151)

action_152 (33) = happyShift action_138
action_152 (35) = happyShift action_139
action_152 (36) = happyShift action_140
action_152 (47) = happyShift action_141
action_152 (57) = happyShift action_142
action_152 (79) = happyShift action_143
action_152 (16) = happyGoto action_158
action_152 _ = happyFail (happyExpListPerState 152)

action_153 _ = happyReduce_39

action_154 (34) = happyShift action_11
action_154 (37) = happyShift action_31
action_154 (42) = happyShift action_32
action_154 (45) = happyShift action_33
action_154 (46) = happyShift action_34
action_154 (50) = happyShift action_35
action_154 (51) = happyShift action_36
action_154 (52) = happyShift action_37
action_154 (58) = happyShift action_38
action_154 (59) = happyShift action_39
action_154 (61) = happyShift action_40
action_154 (63) = happyShift action_41
action_154 (64) = happyShift action_42
action_154 (65) = happyShift action_43
action_154 (66) = happyShift action_44
action_154 (67) = happyShift action_45
action_154 (68) = happyShift action_46
action_154 (75) = happyShift action_47
action_154 (76) = happyShift action_48
action_154 (80) = happyShift action_49
action_154 (84) = happyShift action_50
action_154 (18) = happyGoto action_24
action_154 (20) = happyGoto action_157
action_154 (24) = happyGoto action_26
action_154 (25) = happyGoto action_27
action_154 (26) = happyGoto action_28
action_154 (27) = happyGoto action_29
action_154 (30) = happyGoto action_30
action_154 _ = happyReduce_35

action_155 (42) = happyShift action_32
action_155 (51) = happyShift action_36
action_155 (52) = happyShift action_37
action_155 (58) = happyShift action_38
action_155 (61) = happyShift action_40
action_155 (64) = happyShift action_56
action_155 (65) = happyShift action_43
action_155 (66) = happyShift action_44
action_155 (67) = happyShift action_45
action_155 (68) = happyShift action_46
action_155 (75) = happyShift action_47
action_155 (76) = happyShift action_48
action_155 (80) = happyShift action_49
action_155 (84) = happyShift action_50
action_155 (24) = happyGoto action_156
action_155 (25) = happyGoto action_61
action_155 (26) = happyGoto action_28
action_155 (27) = happyGoto action_55
action_155 (30) = happyGoto action_30
action_155 _ = happyFail (happyExpListPerState 155)

action_156 (32) = happyShift action_72
action_156 (38) = happyShift action_73
action_156 (49) = happyShift action_74
action_156 (54) = happyShift action_75
action_156 (69) = happyShift action_76
action_156 (70) = happyShift action_77
action_156 (71) = happyShift action_78
action_156 (72) = happyShift action_79
action_156 (73) = happyShift action_80
action_156 (74) = happyShift action_81
action_156 (75) = happyShift action_82
action_156 (76) = happyShift action_83
action_156 (77) = happyShift action_84
action_156 (78) = happyShift action_85
action_156 (79) = happyShift action_86
action_156 (31) = happyGoto action_71
action_156 _ = happyReduce_76

action_157 _ = happyReduce_46

action_158 _ = happyReduce_16

action_159 (33) = happyShift action_138
action_159 (35) = happyShift action_139
action_159 (36) = happyShift action_140
action_159 (47) = happyShift action_141
action_159 (57) = happyShift action_142
action_159 (79) = happyShift action_143
action_159 (16) = happyGoto action_165
action_159 _ = happyFail (happyExpListPerState 159)

action_160 (89) = happyShift action_164
action_160 _ = happyFail (happyExpListPerState 160)

action_161 (33) = happyShift action_138
action_161 (35) = happyShift action_139
action_161 (36) = happyShift action_140
action_161 (47) = happyShift action_141
action_161 (57) = happyShift action_142
action_161 (79) = happyShift action_143
action_161 (16) = happyGoto action_163
action_161 _ = happyFail (happyExpListPerState 161)

action_162 _ = happyReduce_9

action_163 _ = happyReduce_28

action_164 _ = happyReduce_30

action_165 _ = happyReduce_21

happyReduce_1 = happyReduce 5 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
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

happyReduce_3 = happySpecReduce_2  6 happyReduction_3
happyReduction_3 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_2 : happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_0  6 happyReduction_4
happyReduction_4  =  HappyAbsSyn6
		 ([]
	)

happyReduce_5 = happySpecReduce_2  7 happyReduction_5
happyReduction_5 (HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (LoVar happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 4 7 happyReduction_6
happyReduction_6 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (LoLabel (happy_var_2 : happy_var_3)
	) `HappyStk` happyRest

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

happyReduce_9 = happyReduce 6 8 happyReduction_9
happyReduction_9 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((happy_var_5,happy_var_2 : happy_var_3) : happy_var_1
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 5 8 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_2) `HappyStk`
	(HappyTerminal (TId happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ([(happy_var_4,happy_var_1 : happy_var_2)]
	) `HappyStk` happyRest

happyReduce_11 = happySpecReduce_3  9 happyReduction_11
happyReduction_11 (HappyTerminal (TId happy_var_3))
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_3 : happy_var_1
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_0  9 happyReduction_12
happyReduction_12  =  HappyAbsSyn9
		 ([]
	)

happyReduce_13 = happySpecReduce_3  10 happyReduction_13
happyReduction_13 (HappyTerminal (TId happy_var_3))
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_3 : happy_var_1
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_0  10 happyReduction_14
happyReduction_14  =  HappyAbsSyn10
		 ([]
	)

happyReduce_15 = happyReduce 5 11 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Procedure happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 7 11 happyReduction_16
happyReduction_16 ((HappyAbsSyn16  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Function happy_var_2 happy_var_4 happy_var_7
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_0  12 happyReduction_17
happyReduction_17  =  HappyAbsSyn12
		 ([]
	)

happyReduce_18 = happySpecReduce_1  12 happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  13 happyReduction_19
happyReduction_19 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_3 : happy_var_1
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  13 happyReduction_20
happyReduction_20 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 ([ happy_var_1 ]
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happyReduce 5 14 happyReduction_21
happyReduction_21 ((HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyTerminal (TId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 ((happy_var_5,happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_0  15 happyReduction_22
happyReduction_22  =  HappyAbsSyn15
		 ([]
	)

happyReduce_23 = happySpecReduce_1  15 happyReduction_23
happyReduction_23 _
	 =  HappyAbsSyn15
		 ([]
	)

happyReduce_24 = happySpecReduce_1  16 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn16
		 (Tint
	)

happyReduce_25 = happySpecReduce_1  16 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn16
		 (Treal
	)

happyReduce_26 = happySpecReduce_1  16 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn16
		 (Tbool
	)

happyReduce_27 = happySpecReduce_1  16 happyReduction_27
happyReduction_27 _
	 =  HappyAbsSyn16
		 (Tchar
	)

happyReduce_28 = happyReduce 4 16 happyReduction_28
happyReduction_28 ((HappyAbsSyn16  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (ArrayT happy_var_4
	) `HappyStk` happyRest

happyReduce_29 = happySpecReduce_2  16 happyReduction_29
happyReduction_29 (HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (PointerT happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  17 happyReduction_30
happyReduction_30 _
	_
	_
	 =  HappyAbsSyn17
		 ([]
	)

happyReduce_31 = happySpecReduce_0  17 happyReduction_31
happyReduction_31  =  HappyAbsSyn17
		 ([]
	)

happyReduce_32 = happyReduce 4 18 happyReduction_32
happyReduction_32 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (Bl (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_33 = happySpecReduce_3  19 happyReduction_33
happyReduction_33 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_3 : happy_var_1
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_0  19 happyReduction_34
happyReduction_34  =  HappyAbsSyn19
		 ([]
	)

happyReduce_35 = happySpecReduce_0  20 happyReduction_35
happyReduction_35  =  HappyAbsSyn20
		 (SEmpty
	)

happyReduce_36 = happySpecReduce_3  20 happyReduction_36
happyReduction_36 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn20
		 (SEqual happy_var_1 happy_var_3
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn20
		 (SBlock happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn20
		 (SCall happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happyReduce 5 20 happyReduction_39
happyReduction_39 ((HappyAbsSyn21  happy_var_5) `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SIf happy_var_2 happy_var_4 happy_var_5
	) `HappyStk` happyRest

happyReduce_40 = happyReduce 4 20 happyReduction_40
happyReduction_40 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SWhile happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_3  20 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_3)
	_
	(HappyTerminal (TId happy_var_1))
	 =  HappyAbsSyn20
		 (SId happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_2  20 happyReduction_42
happyReduction_42 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (SGoto (tokenizer happy_var_1)
	)
happyReduction_42 _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  20 happyReduction_43
happyReduction_43 _
	 =  HappyAbsSyn20
		 (SReturn
	)

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn25  happy_var_3)
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (SNew happy_var_2 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 (HappyAbsSyn25  happy_var_3)
	_
	_
	 =  HappyAbsSyn20
		 (SDispose happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_2  21 happyReduction_46
happyReduction_46 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (SElse happy_var_2
	)
happyReduction_46 _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_0  21 happyReduction_47
happyReduction_47  =  HappyAbsSyn21
		 (SEmpty
	)

happyReduce_48 = happySpecReduce_3  22 happyReduction_48
happyReduction_48 _
	(HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn22
		 (happy_var_2
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_0  22 happyReduction_49
happyReduction_49  =  HappyAbsSyn22
		 (EEmpty
	)

happyReduce_50 = happySpecReduce_2  23 happyReduction_50
happyReduction_50 _
	_
	 =  HappyAbsSyn23
		 ([]
	)

happyReduce_51 = happySpecReduce_0  23 happyReduction_51
happyReduction_51  =  HappyAbsSyn23
		 ([]
	)

happyReduce_52 = happySpecReduce_1  24 happyReduction_52
happyReduction_52 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 (L happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  24 happyReduction_53
happyReduction_53 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn24
		 (R happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  25 happyReduction_54
happyReduction_54 (HappyTerminal (TId happy_var_1))
	 =  HappyAbsSyn25
		 (LId happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_1  25 happyReduction_55
happyReduction_55 _
	 =  HappyAbsSyn25
		 (LResult
	)

happyReduce_56 = happySpecReduce_1  25 happyReduction_56
happyReduction_56 (HappyTerminal (TStringconst happy_var_1))
	 =  HappyAbsSyn25
		 (LString happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happyReduce 4 25 happyReduction_57
happyReduction_57 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (LValueExpr happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_58 = happySpecReduce_2  25 happyReduction_58
happyReduction_58 _
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (LExpr happy_var_1
	)
happyReduction_58 _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  25 happyReduction_59
happyReduction_59 _
	(HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (LParen happy_var_2
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  26 happyReduction_60
happyReduction_60 (HappyTerminal (TIntconst happy_var_1))
	 =  HappyAbsSyn26
		 (RInt happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  26 happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn26
		 (RTrue
	)

happyReduce_62 = happySpecReduce_1  26 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn26
		 (RFalse
	)

happyReduce_63 = happySpecReduce_1  26 happyReduction_63
happyReduction_63 (HappyTerminal (TRealconst happy_var_1))
	 =  HappyAbsSyn26
		 (RReal happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  26 happyReduction_64
happyReduction_64 (HappyTerminal (TCharconst happy_var_1))
	 =  HappyAbsSyn26
		 (RChar happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  26 happyReduction_65
happyReduction_65 _
	(HappyAbsSyn26  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RParen happy_var_2
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  26 happyReduction_66
happyReduction_66 _
	 =  HappyAbsSyn26
		 (RNil
	)

happyReduce_67 = happySpecReduce_1  26 happyReduction_67
happyReduction_67 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (RCall happy_var_1
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_2  26 happyReduction_68
happyReduction_68 (HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RPapaki happy_var_2
	)
happyReduction_68 _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_2  26 happyReduction_69
happyReduction_69 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn26
		 (RUnop happy_var_1 happy_var_2
	)
happyReduction_69 _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  26 happyReduction_70
happyReduction_70 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RPlus happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  26 happyReduction_71
happyReduction_71 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RMul happy_var_1 happy_var_3
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  26 happyReduction_72
happyReduction_72 (HappyAbsSyn24  happy_var_3)
	(HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RBinop happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happyReduce 4 27 happyReduction_73
happyReduction_73 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (CId happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_74 = happySpecReduce_0  28 happyReduction_74
happyReduction_74  =  HappyAbsSyn28
		 ([]
	)

happyReduce_75 = happySpecReduce_2  28 happyReduction_75
happyReduction_75 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 : happy_var_2
	)
happyReduction_75 _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  29 happyReduction_76
happyReduction_76 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_3 : happy_var_1
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_0  29 happyReduction_77
happyReduction_77  =  HappyAbsSyn29
		 ([]
	)

happyReduce_78 = happySpecReduce_1  30 happyReduction_78
happyReduction_78 _
	 =  HappyAbsSyn30
		 (UNot
	)

happyReduce_79 = happySpecReduce_1  30 happyReduction_79
happyReduction_79 _
	 =  HappyAbsSyn30
		 (UPos
	)

happyReduce_80 = happySpecReduce_1  30 happyReduction_80
happyReduction_80 _
	 =  HappyAbsSyn30
		 (UNeg
	)

happyReduce_81 = happySpecReduce_1  31 happyReduction_81
happyReduction_81 _
	 =  HappyAbsSyn31
		 (BMinus
	)

happyReduce_82 = happySpecReduce_1  31 happyReduction_82
happyReduction_82 _
	 =  HappyAbsSyn31
		 (BRealDiv
	)

happyReduce_83 = happySpecReduce_1  31 happyReduction_83
happyReduction_83 _
	 =  HappyAbsSyn31
		 (BDiv
	)

happyReduce_84 = happySpecReduce_1  31 happyReduction_84
happyReduction_84 _
	 =  HappyAbsSyn31
		 (BMod
	)

happyReduce_85 = happySpecReduce_1  31 happyReduction_85
happyReduction_85 _
	 =  HappyAbsSyn31
		 (BOr
	)

happyReduce_86 = happySpecReduce_1  31 happyReduction_86
happyReduction_86 _
	 =  HappyAbsSyn31
		 (BAnd
	)

happyReduce_87 = happySpecReduce_1  31 happyReduction_87
happyReduction_87 _
	 =  HappyAbsSyn31
		 (BEq
	)

happyReduce_88 = happySpecReduce_1  31 happyReduction_88
happyReduction_88 _
	 =  HappyAbsSyn31
		 (BDiff
	)

happyReduce_89 = happySpecReduce_1  31 happyReduction_89
happyReduction_89 _
	 =  HappyAbsSyn31
		 (BLess
	)

happyReduce_90 = happySpecReduce_1  31 happyReduction_90
happyReduction_90 _
	 =  HappyAbsSyn31
		 (BGreater
	)

happyReduce_91 = happySpecReduce_1  31 happyReduction_91
happyReduction_91 _
	 =  HappyAbsSyn31
		 (BGreq
	)

happyReduce_92 = happySpecReduce_1  31 happyReduction_92
happyReduction_92 _
	 =  HappyAbsSyn31
		 (BSmeq
	)

happyNewToken action sts stk [] =
	action 90 90 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TAnd -> cont 32;
	TArray -> cont 33;
	TBegin -> cont 34;
	TBoolean -> cont 35;
	TChar -> cont 36;
	TDispose -> cont 37;
	TDivInt -> cont 38;
	TDo -> cont 39;
	TElse -> cont 40;
	TEnd -> cont 41;
	TFalse -> cont 42;
	TForward -> cont 43;
	TFunction -> cont 44;
	TGoto -> cont 45;
	TIf -> cont 46;
	TInteger -> cont 47;
	TLabel -> cont 48;
	TMod -> cont 49;
	TNew -> cont 50;
	TNil -> cont 51;
	TNot -> cont 52;
	TOf -> cont 53;
	TOr -> cont 54;
	TProcedure -> cont 55;
	TProgram -> cont 56;
	TReal -> cont 57;
	TResult -> cont 58;
	TReturn -> cont 59;
	TThen -> cont 60;
	TTrue -> cont 61;
	TVar -> cont 62;
	TWhile -> cont 63;
	TId happy_dollar_dollar -> cont 64;
	TIntconst happy_dollar_dollar -> cont 65;
	TRealconst happy_dollar_dollar -> cont 66;
	TCharconst happy_dollar_dollar -> cont 67;
	TStringconst happy_dollar_dollar -> cont 68;
	TLogiceq -> cont 69;
	TGreater -> cont 70;
	TSmaller -> cont 71;
	TDifferent -> cont 72;
	TGreaterequal -> cont 73;
	TSmallerequal -> cont 74;
	TAdd -> cont 75;
	TMinus -> cont 76;
	TMul -> cont 77;
	TDivReal -> cont 78;
	TPointer -> cont 79;
	TAdress -> cont 80;
	TEq -> cont 81;
	TSeperator -> cont 82;
	TDot -> cont 83;
	TLeftparen -> cont 84;
	TRightparen -> cont 85;
	TUpdown -> cont 86;
	TComma -> cont 87;
	TLeftbracket -> cont 88;
	TRightbracket -> cont 89;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 90 tk tks = happyError' (tks, explist)
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
calc tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError _ = error ("Parse error\n")

tokenizer :: Token -> String
tokenizer token = show token

data Program =
  P String Body
  deriving(Show)

data Body =
  B [Local] Block
  deriving(Show)

data Local =
  LoVar Variables         |
  LoLabel [String]        |
  LoHeadBod Header Body   |
  LoForward Header
  deriving(Show)

type Id = String
type MoreVariables = [Id]
type Variables = [ (Type, MoreVariables) ]
type Labels = MoreVariables

data Header =
  Procedure String Arguments1 |
  Function String Arguments1 Type
  deriving(Show)

type Arguments1 = [Formal]
type Arguments2 = Arguments1

type Formal = (Type,[String])

data Type =
  Tint          | 
  Treal         |
  Tbool         |
  Tchar         |
  ArrayT Type   |
  PointerT Type 
  deriving(Show)


type Stmts = [Stmt]

data Block =
  Bl Stmts
  deriving(Show)
  
data Stmt = 
  SEmpty             | 
  SEqual LValue Expr |
  SBlock Block       |
  SCall Call         |
  SIf Expr Stmt Stmt |
  SWhile Expr Stmt   |
  SId Id Stmt        |
  SGoto Id           |
  SReturn            |
  SNew Expr LValue   |
  SDispose LValue    |
  SElse Stmt
  deriving(Show)

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
  RInt Int         |
  RTrue            |
  RFalse           |
  RReal Double     |
  RChar Char       |
  RParen RValue    |
  RNil             |
  RCall Call       |
  RPapaki LValue   |
  RUnop Unop Expr  |
  RPlus Expr Expr  |
  RMul  Expr Expr  |
  RBinop Expr Binop Expr
  deriving(Show)

data Call =
  CId Id [Expr]
  deriving(Show)

data Unop =
  UNot |
  UPos |
  UNeg 
  deriving(Show)

data Binop =
  BPlus    |
  BMinus   |
  BMul     |
  BRealDiv |
  BDiv     |
  BMod     |
  BOr      |
  BAnd     |
  BEq      |
  BDiff    |
  BLess    |
  BGreater |
  BGreq    |
  BSmeq 
  deriving(Show)

main = getContents >>= print . calc . alexScanTokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4











































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/opt/ghc/7.10.3/lib/ghc-7.10.3/include/ghcversion.h" #-}

















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
