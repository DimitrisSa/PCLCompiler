{-# OPTIONS_GHC -w #-}
module Main where
import Lexer
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t15 t23
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
	| HappyAbsSyn22 (Expr)
	| HappyAbsSyn23 t23
	| HappyAbsSyn25 (LValue)
	| HappyAbsSyn26 (RValue)
	| HappyAbsSyn27 (Call)
	| HappyAbsSyn28 (Exprs)

action_0 (54) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail

action_1 (54) = happyShift action_2
action_1 _ = happyFail

action_2 (62) = happyShift action_4
action_2 _ = happyFail

action_3 (88) = happyAccept
action_3 _ = happyFail

action_4 (80) = happyShift action_5
action_4 _ = happyFail

action_5 (5) = happyGoto action_6
action_5 (6) = happyGoto action_7
action_5 _ = happyReduce_4

action_6 (81) = happyShift action_17
action_6 _ = happyFail

action_7 (32) = happyShift action_11
action_7 (41) = happyShift action_12
action_7 (42) = happyShift action_13
action_7 (46) = happyShift action_14
action_7 (53) = happyShift action_15
action_7 (60) = happyShift action_16
action_7 (7) = happyGoto action_8
action_7 (11) = happyGoto action_9
action_7 (18) = happyGoto action_10
action_7 _ = happyFail

action_8 _ = happyReduce_3

action_9 (80) = happyShift action_51
action_9 _ = happyFail

action_10 _ = happyReduce_2

action_11 (32) = happyShift action_11
action_11 (35) = happyShift action_31
action_11 (40) = happyShift action_32
action_11 (43) = happyShift action_33
action_11 (44) = happyShift action_34
action_11 (48) = happyShift action_35
action_11 (49) = happyShift action_36
action_11 (50) = happyShift action_37
action_11 (56) = happyShift action_38
action_11 (57) = happyShift action_39
action_11 (59) = happyShift action_40
action_11 (61) = happyShift action_41
action_11 (62) = happyShift action_42
action_11 (63) = happyShift action_43
action_11 (64) = happyShift action_44
action_11 (65) = happyShift action_45
action_11 (66) = happyShift action_46
action_11 (73) = happyShift action_47
action_11 (74) = happyShift action_48
action_11 (78) = happyShift action_49
action_11 (82) = happyShift action_50
action_11 (18) = happyGoto action_25
action_11 (20) = happyGoto action_26
action_11 (24) = happyGoto action_27
action_11 (25) = happyGoto action_28
action_11 (26) = happyGoto action_29
action_11 (27) = happyGoto action_30
action_11 _ = happyReduce_34

action_12 (42) = happyShift action_13
action_12 (53) = happyShift action_15
action_12 (11) = happyGoto action_24
action_12 _ = happyFail

action_13 (62) = happyShift action_23
action_13 _ = happyFail

action_14 (62) = happyShift action_22
action_14 _ = happyFail

action_15 (62) = happyShift action_21
action_15 _ = happyFail

action_16 (62) = happyShift action_20
action_16 (8) = happyGoto action_18
action_16 (9) = happyGoto action_19
action_16 _ = happyFail

action_17 _ = happyReduce_1

action_18 (62) = happyShift action_20
action_18 (9) = happyGoto action_94
action_18 _ = happyReduce_5

action_19 _ = happyReduce_10

action_20 (10) = happyGoto action_93
action_20 _ = happyReduce_13

action_21 (82) = happyShift action_92
action_21 _ = happyFail

action_22 (10) = happyGoto action_91
action_22 _ = happyReduce_13

action_23 (82) = happyShift action_90
action_23 _ = happyFail

action_24 (80) = happyShift action_89
action_24 _ = happyFail

action_25 _ = happyReduce_36

action_26 (19) = happyGoto action_88
action_26 _ = happyReduce_33

action_27 (30) = happyShift action_73
action_27 (36) = happyShift action_74
action_27 (47) = happyShift action_75
action_27 (52) = happyShift action_76
action_27 (67) = happyShift action_77
action_27 (68) = happyShift action_78
action_27 (69) = happyShift action_79
action_27 (70) = happyShift action_80
action_27 (71) = happyShift action_81
action_27 (72) = happyShift action_82
action_27 (73) = happyShift action_83
action_27 (74) = happyShift action_84
action_27 (75) = happyShift action_85
action_27 (76) = happyShift action_86
action_27 (77) = happyShift action_87
action_27 _ = happyFail

action_28 (79) = happyShift action_71
action_28 (86) = happyShift action_72
action_28 _ = happyReduce_51

action_29 _ = happyReduce_52

action_30 (38) = happyReduce_37
action_30 (39) = happyReduce_37
action_30 (80) = happyReduce_37
action_30 _ = happyReduce_66

action_31 (86) = happyShift action_70
action_31 (23) = happyGoto action_69
action_31 _ = happyReduce_50

action_32 _ = happyReduce_61

action_33 (62) = happyShift action_68
action_33 _ = happyFail

action_34 (40) = happyShift action_32
action_34 (49) = happyShift action_36
action_34 (50) = happyShift action_37
action_34 (56) = happyShift action_38
action_34 (59) = happyShift action_40
action_34 (62) = happyShift action_56
action_34 (63) = happyShift action_43
action_34 (64) = happyShift action_44
action_34 (65) = happyShift action_45
action_34 (66) = happyShift action_46
action_34 (73) = happyShift action_47
action_34 (74) = happyShift action_48
action_34 (78) = happyShift action_49
action_34 (82) = happyShift action_50
action_34 (24) = happyGoto action_67
action_34 (25) = happyGoto action_59
action_34 (26) = happyGoto action_29
action_34 (27) = happyGoto action_55
action_34 _ = happyFail

action_35 (86) = happyShift action_66
action_35 (22) = happyGoto action_65
action_35 _ = happyReduce_48

action_36 _ = happyReduce_65

action_37 (40) = happyShift action_32
action_37 (49) = happyShift action_36
action_37 (50) = happyShift action_37
action_37 (56) = happyShift action_38
action_37 (59) = happyShift action_40
action_37 (62) = happyShift action_56
action_37 (63) = happyShift action_43
action_37 (64) = happyShift action_44
action_37 (65) = happyShift action_45
action_37 (66) = happyShift action_46
action_37 (73) = happyShift action_47
action_37 (74) = happyShift action_48
action_37 (78) = happyShift action_49
action_37 (82) = happyShift action_50
action_37 (24) = happyGoto action_64
action_37 (25) = happyGoto action_59
action_37 (26) = happyGoto action_29
action_37 (27) = happyGoto action_55
action_37 _ = happyFail

action_38 _ = happyReduce_54

action_39 _ = happyReduce_42

action_40 _ = happyReduce_60

action_41 (40) = happyShift action_32
action_41 (49) = happyShift action_36
action_41 (50) = happyShift action_37
action_41 (56) = happyShift action_38
action_41 (59) = happyShift action_40
action_41 (62) = happyShift action_56
action_41 (63) = happyShift action_43
action_41 (64) = happyShift action_44
action_41 (65) = happyShift action_45
action_41 (66) = happyShift action_46
action_41 (73) = happyShift action_47
action_41 (74) = happyShift action_48
action_41 (78) = happyShift action_49
action_41 (82) = happyShift action_50
action_41 (24) = happyGoto action_63
action_41 (25) = happyGoto action_59
action_41 (26) = happyGoto action_29
action_41 (27) = happyGoto action_55
action_41 _ = happyFail

action_42 (82) = happyShift action_61
action_42 (84) = happyShift action_62
action_42 _ = happyReduce_53

action_43 _ = happyReduce_59

action_44 _ = happyReduce_62

action_45 _ = happyReduce_63

action_46 _ = happyReduce_55

action_47 (40) = happyShift action_32
action_47 (49) = happyShift action_36
action_47 (50) = happyShift action_37
action_47 (56) = happyShift action_38
action_47 (59) = happyShift action_40
action_47 (62) = happyShift action_56
action_47 (63) = happyShift action_43
action_47 (64) = happyShift action_44
action_47 (65) = happyShift action_45
action_47 (66) = happyShift action_46
action_47 (73) = happyShift action_47
action_47 (74) = happyShift action_48
action_47 (78) = happyShift action_49
action_47 (82) = happyShift action_50
action_47 (24) = happyGoto action_60
action_47 (25) = happyGoto action_59
action_47 (26) = happyGoto action_29
action_47 (27) = happyGoto action_55
action_47 _ = happyFail

action_48 (40) = happyShift action_32
action_48 (49) = happyShift action_36
action_48 (50) = happyShift action_37
action_48 (56) = happyShift action_38
action_48 (59) = happyShift action_40
action_48 (62) = happyShift action_56
action_48 (63) = happyShift action_43
action_48 (64) = happyShift action_44
action_48 (65) = happyShift action_45
action_48 (66) = happyShift action_46
action_48 (73) = happyShift action_47
action_48 (74) = happyShift action_48
action_48 (78) = happyShift action_49
action_48 (82) = happyShift action_50
action_48 (24) = happyGoto action_58
action_48 (25) = happyGoto action_59
action_48 (26) = happyGoto action_29
action_48 (27) = happyGoto action_55
action_48 _ = happyFail

action_49 (40) = happyShift action_32
action_49 (49) = happyShift action_36
action_49 (50) = happyShift action_37
action_49 (56) = happyShift action_38
action_49 (59) = happyShift action_40
action_49 (62) = happyShift action_56
action_49 (63) = happyShift action_43
action_49 (64) = happyShift action_44
action_49 (65) = happyShift action_45
action_49 (66) = happyShift action_46
action_49 (73) = happyShift action_47
action_49 (74) = happyShift action_48
action_49 (78) = happyShift action_49
action_49 (82) = happyShift action_50
action_49 (24) = happyGoto action_27
action_49 (25) = happyGoto action_57
action_49 (26) = happyGoto action_29
action_49 (27) = happyGoto action_55
action_49 _ = happyFail

action_50 (40) = happyShift action_32
action_50 (49) = happyShift action_36
action_50 (50) = happyShift action_37
action_50 (56) = happyShift action_38
action_50 (59) = happyShift action_40
action_50 (62) = happyShift action_56
action_50 (63) = happyShift action_43
action_50 (64) = happyShift action_44
action_50 (65) = happyShift action_45
action_50 (66) = happyShift action_46
action_50 (73) = happyShift action_47
action_50 (74) = happyShift action_48
action_50 (78) = happyShift action_49
action_50 (82) = happyShift action_50
action_50 (24) = happyGoto action_27
action_50 (25) = happyGoto action_53
action_50 (26) = happyGoto action_54
action_50 (27) = happyGoto action_55
action_50 _ = happyFail

action_51 (5) = happyGoto action_52
action_51 (6) = happyGoto action_7
action_51 _ = happyReduce_4

action_52 (80) = happyShift action_133
action_52 _ = happyFail

action_53 (83) = happyShift action_132
action_53 (86) = happyShift action_72
action_53 _ = happyReduce_51

action_54 (83) = happyShift action_131
action_54 _ = happyReduce_52

action_55 _ = happyReduce_66

action_56 (82) = happyShift action_61
action_56 _ = happyReduce_53

action_57 (30) = happyReduce_67
action_57 (36) = happyReduce_67
action_57 (47) = happyReduce_67
action_57 (52) = happyReduce_67
action_57 (67) = happyReduce_67
action_57 (68) = happyReduce_67
action_57 (69) = happyReduce_67
action_57 (70) = happyReduce_67
action_57 (71) = happyReduce_67
action_57 (72) = happyReduce_67
action_57 (73) = happyReduce_67
action_57 (74) = happyReduce_67
action_57 (75) = happyReduce_67
action_57 (76) = happyReduce_67
action_57 (77) = happyReduce_67
action_57 (86) = happyShift action_72
action_57 _ = happyReduce_67

action_58 (77) = happyShift action_87
action_58 _ = happyReduce_70

action_59 (86) = happyShift action_72
action_59 _ = happyReduce_51

action_60 (77) = happyShift action_87
action_60 _ = happyReduce_69

action_61 (40) = happyShift action_32
action_61 (49) = happyShift action_36
action_61 (50) = happyShift action_37
action_61 (56) = happyShift action_38
action_61 (59) = happyShift action_40
action_61 (62) = happyShift action_56
action_61 (63) = happyShift action_43
action_61 (64) = happyShift action_44
action_61 (65) = happyShift action_45
action_61 (66) = happyShift action_46
action_61 (73) = happyShift action_47
action_61 (74) = happyShift action_48
action_61 (78) = happyShift action_49
action_61 (82) = happyShift action_50
action_61 (24) = happyGoto action_129
action_61 (25) = happyGoto action_59
action_61 (26) = happyGoto action_29
action_61 (27) = happyGoto action_55
action_61 (28) = happyGoto action_130
action_61 _ = happyReduce_87

action_62 (32) = happyShift action_11
action_62 (35) = happyShift action_31
action_62 (40) = happyShift action_32
action_62 (43) = happyShift action_33
action_62 (44) = happyShift action_34
action_62 (48) = happyShift action_35
action_62 (49) = happyShift action_36
action_62 (50) = happyShift action_37
action_62 (56) = happyShift action_38
action_62 (57) = happyShift action_39
action_62 (59) = happyShift action_40
action_62 (61) = happyShift action_41
action_62 (62) = happyShift action_42
action_62 (63) = happyShift action_43
action_62 (64) = happyShift action_44
action_62 (65) = happyShift action_45
action_62 (66) = happyShift action_46
action_62 (73) = happyShift action_47
action_62 (74) = happyShift action_48
action_62 (78) = happyShift action_49
action_62 (82) = happyShift action_50
action_62 (18) = happyGoto action_25
action_62 (20) = happyGoto action_128
action_62 (24) = happyGoto action_27
action_62 (25) = happyGoto action_28
action_62 (26) = happyGoto action_29
action_62 (27) = happyGoto action_30
action_62 _ = happyReduce_34

action_63 (30) = happyShift action_73
action_63 (36) = happyShift action_74
action_63 (37) = happyShift action_127
action_63 (47) = happyShift action_75
action_63 (52) = happyShift action_76
action_63 (67) = happyShift action_77
action_63 (68) = happyShift action_78
action_63 (69) = happyShift action_79
action_63 (70) = happyShift action_80
action_63 (71) = happyShift action_81
action_63 (72) = happyShift action_82
action_63 (73) = happyShift action_83
action_63 (74) = happyShift action_84
action_63 (75) = happyShift action_85
action_63 (76) = happyShift action_86
action_63 (77) = happyShift action_87
action_63 _ = happyFail

action_64 (77) = happyShift action_87
action_64 _ = happyReduce_68

action_65 (40) = happyShift action_32
action_65 (49) = happyShift action_36
action_65 (50) = happyShift action_37
action_65 (56) = happyShift action_38
action_65 (59) = happyShift action_40
action_65 (62) = happyShift action_56
action_65 (63) = happyShift action_43
action_65 (64) = happyShift action_44
action_65 (65) = happyShift action_45
action_65 (66) = happyShift action_46
action_65 (73) = happyShift action_47
action_65 (74) = happyShift action_48
action_65 (78) = happyShift action_49
action_65 (82) = happyShift action_50
action_65 (24) = happyGoto action_27
action_65 (25) = happyGoto action_126
action_65 (26) = happyGoto action_29
action_65 (27) = happyGoto action_55
action_65 _ = happyFail

action_66 (40) = happyShift action_32
action_66 (49) = happyShift action_36
action_66 (50) = happyShift action_37
action_66 (56) = happyShift action_38
action_66 (59) = happyShift action_40
action_66 (62) = happyShift action_56
action_66 (63) = happyShift action_43
action_66 (64) = happyShift action_44
action_66 (65) = happyShift action_45
action_66 (66) = happyShift action_46
action_66 (73) = happyShift action_47
action_66 (74) = happyShift action_48
action_66 (78) = happyShift action_49
action_66 (82) = happyShift action_50
action_66 (24) = happyGoto action_125
action_66 (25) = happyGoto action_59
action_66 (26) = happyGoto action_29
action_66 (27) = happyGoto action_55
action_66 _ = happyFail

action_67 (30) = happyShift action_73
action_67 (36) = happyShift action_74
action_67 (47) = happyShift action_75
action_67 (52) = happyShift action_76
action_67 (58) = happyShift action_124
action_67 (67) = happyShift action_77
action_67 (68) = happyShift action_78
action_67 (69) = happyShift action_79
action_67 (70) = happyShift action_80
action_67 (71) = happyShift action_81
action_67 (72) = happyShift action_82
action_67 (73) = happyShift action_83
action_67 (74) = happyShift action_84
action_67 (75) = happyShift action_85
action_67 (76) = happyShift action_86
action_67 (77) = happyShift action_87
action_67 _ = happyFail

action_68 _ = happyReduce_41

action_69 (40) = happyShift action_32
action_69 (49) = happyShift action_36
action_69 (50) = happyShift action_37
action_69 (56) = happyShift action_38
action_69 (59) = happyShift action_40
action_69 (62) = happyShift action_56
action_69 (63) = happyShift action_43
action_69 (64) = happyShift action_44
action_69 (65) = happyShift action_45
action_69 (66) = happyShift action_46
action_69 (73) = happyShift action_47
action_69 (74) = happyShift action_48
action_69 (78) = happyShift action_49
action_69 (82) = happyShift action_50
action_69 (24) = happyGoto action_27
action_69 (25) = happyGoto action_123
action_69 (26) = happyGoto action_29
action_69 (27) = happyGoto action_55
action_69 _ = happyFail

action_70 (87) = happyShift action_122
action_70 _ = happyFail

action_71 (40) = happyShift action_32
action_71 (49) = happyShift action_36
action_71 (50) = happyShift action_37
action_71 (56) = happyShift action_38
action_71 (59) = happyShift action_40
action_71 (62) = happyShift action_56
action_71 (63) = happyShift action_43
action_71 (64) = happyShift action_44
action_71 (65) = happyShift action_45
action_71 (66) = happyShift action_46
action_71 (73) = happyShift action_47
action_71 (74) = happyShift action_48
action_71 (78) = happyShift action_49
action_71 (82) = happyShift action_50
action_71 (24) = happyGoto action_121
action_71 (25) = happyGoto action_59
action_71 (26) = happyGoto action_29
action_71 (27) = happyGoto action_55
action_71 _ = happyFail

action_72 (40) = happyShift action_32
action_72 (49) = happyShift action_36
action_72 (50) = happyShift action_37
action_72 (56) = happyShift action_38
action_72 (59) = happyShift action_40
action_72 (62) = happyShift action_56
action_72 (63) = happyShift action_43
action_72 (64) = happyShift action_44
action_72 (65) = happyShift action_45
action_72 (66) = happyShift action_46
action_72 (73) = happyShift action_47
action_72 (74) = happyShift action_48
action_72 (78) = happyShift action_49
action_72 (82) = happyShift action_50
action_72 (24) = happyGoto action_120
action_72 (25) = happyGoto action_59
action_72 (26) = happyGoto action_29
action_72 (27) = happyGoto action_55
action_72 _ = happyFail

action_73 (40) = happyShift action_32
action_73 (49) = happyShift action_36
action_73 (50) = happyShift action_37
action_73 (56) = happyShift action_38
action_73 (59) = happyShift action_40
action_73 (62) = happyShift action_56
action_73 (63) = happyShift action_43
action_73 (64) = happyShift action_44
action_73 (65) = happyShift action_45
action_73 (66) = happyShift action_46
action_73 (73) = happyShift action_47
action_73 (74) = happyShift action_48
action_73 (78) = happyShift action_49
action_73 (82) = happyShift action_50
action_73 (24) = happyGoto action_119
action_73 (25) = happyGoto action_59
action_73 (26) = happyGoto action_29
action_73 (27) = happyGoto action_55
action_73 _ = happyFail

action_74 (40) = happyShift action_32
action_74 (49) = happyShift action_36
action_74 (50) = happyShift action_37
action_74 (56) = happyShift action_38
action_74 (59) = happyShift action_40
action_74 (62) = happyShift action_56
action_74 (63) = happyShift action_43
action_74 (64) = happyShift action_44
action_74 (65) = happyShift action_45
action_74 (66) = happyShift action_46
action_74 (73) = happyShift action_47
action_74 (74) = happyShift action_48
action_74 (78) = happyShift action_49
action_74 (82) = happyShift action_50
action_74 (24) = happyGoto action_118
action_74 (25) = happyGoto action_59
action_74 (26) = happyGoto action_29
action_74 (27) = happyGoto action_55
action_74 _ = happyFail

action_75 (40) = happyShift action_32
action_75 (49) = happyShift action_36
action_75 (50) = happyShift action_37
action_75 (56) = happyShift action_38
action_75 (59) = happyShift action_40
action_75 (62) = happyShift action_56
action_75 (63) = happyShift action_43
action_75 (64) = happyShift action_44
action_75 (65) = happyShift action_45
action_75 (66) = happyShift action_46
action_75 (73) = happyShift action_47
action_75 (74) = happyShift action_48
action_75 (78) = happyShift action_49
action_75 (82) = happyShift action_50
action_75 (24) = happyGoto action_117
action_75 (25) = happyGoto action_59
action_75 (26) = happyGoto action_29
action_75 (27) = happyGoto action_55
action_75 _ = happyFail

action_76 (40) = happyShift action_32
action_76 (49) = happyShift action_36
action_76 (50) = happyShift action_37
action_76 (56) = happyShift action_38
action_76 (59) = happyShift action_40
action_76 (62) = happyShift action_56
action_76 (63) = happyShift action_43
action_76 (64) = happyShift action_44
action_76 (65) = happyShift action_45
action_76 (66) = happyShift action_46
action_76 (73) = happyShift action_47
action_76 (74) = happyShift action_48
action_76 (78) = happyShift action_49
action_76 (82) = happyShift action_50
action_76 (24) = happyGoto action_116
action_76 (25) = happyGoto action_59
action_76 (26) = happyGoto action_29
action_76 (27) = happyGoto action_55
action_76 _ = happyFail

action_77 (40) = happyShift action_32
action_77 (49) = happyShift action_36
action_77 (50) = happyShift action_37
action_77 (56) = happyShift action_38
action_77 (59) = happyShift action_40
action_77 (62) = happyShift action_56
action_77 (63) = happyShift action_43
action_77 (64) = happyShift action_44
action_77 (65) = happyShift action_45
action_77 (66) = happyShift action_46
action_77 (73) = happyShift action_47
action_77 (74) = happyShift action_48
action_77 (78) = happyShift action_49
action_77 (82) = happyShift action_50
action_77 (24) = happyGoto action_115
action_77 (25) = happyGoto action_59
action_77 (26) = happyGoto action_29
action_77 (27) = happyGoto action_55
action_77 _ = happyFail

action_78 (40) = happyShift action_32
action_78 (49) = happyShift action_36
action_78 (50) = happyShift action_37
action_78 (56) = happyShift action_38
action_78 (59) = happyShift action_40
action_78 (62) = happyShift action_56
action_78 (63) = happyShift action_43
action_78 (64) = happyShift action_44
action_78 (65) = happyShift action_45
action_78 (66) = happyShift action_46
action_78 (73) = happyShift action_47
action_78 (74) = happyShift action_48
action_78 (78) = happyShift action_49
action_78 (82) = happyShift action_50
action_78 (24) = happyGoto action_114
action_78 (25) = happyGoto action_59
action_78 (26) = happyGoto action_29
action_78 (27) = happyGoto action_55
action_78 _ = happyFail

action_79 (40) = happyShift action_32
action_79 (49) = happyShift action_36
action_79 (50) = happyShift action_37
action_79 (56) = happyShift action_38
action_79 (59) = happyShift action_40
action_79 (62) = happyShift action_56
action_79 (63) = happyShift action_43
action_79 (64) = happyShift action_44
action_79 (65) = happyShift action_45
action_79 (66) = happyShift action_46
action_79 (73) = happyShift action_47
action_79 (74) = happyShift action_48
action_79 (78) = happyShift action_49
action_79 (82) = happyShift action_50
action_79 (24) = happyGoto action_113
action_79 (25) = happyGoto action_59
action_79 (26) = happyGoto action_29
action_79 (27) = happyGoto action_55
action_79 _ = happyFail

action_80 (40) = happyShift action_32
action_80 (49) = happyShift action_36
action_80 (50) = happyShift action_37
action_80 (56) = happyShift action_38
action_80 (59) = happyShift action_40
action_80 (62) = happyShift action_56
action_80 (63) = happyShift action_43
action_80 (64) = happyShift action_44
action_80 (65) = happyShift action_45
action_80 (66) = happyShift action_46
action_80 (73) = happyShift action_47
action_80 (74) = happyShift action_48
action_80 (78) = happyShift action_49
action_80 (82) = happyShift action_50
action_80 (24) = happyGoto action_112
action_80 (25) = happyGoto action_59
action_80 (26) = happyGoto action_29
action_80 (27) = happyGoto action_55
action_80 _ = happyFail

action_81 (40) = happyShift action_32
action_81 (49) = happyShift action_36
action_81 (50) = happyShift action_37
action_81 (56) = happyShift action_38
action_81 (59) = happyShift action_40
action_81 (62) = happyShift action_56
action_81 (63) = happyShift action_43
action_81 (64) = happyShift action_44
action_81 (65) = happyShift action_45
action_81 (66) = happyShift action_46
action_81 (73) = happyShift action_47
action_81 (74) = happyShift action_48
action_81 (78) = happyShift action_49
action_81 (82) = happyShift action_50
action_81 (24) = happyGoto action_111
action_81 (25) = happyGoto action_59
action_81 (26) = happyGoto action_29
action_81 (27) = happyGoto action_55
action_81 _ = happyFail

action_82 (40) = happyShift action_32
action_82 (49) = happyShift action_36
action_82 (50) = happyShift action_37
action_82 (56) = happyShift action_38
action_82 (59) = happyShift action_40
action_82 (62) = happyShift action_56
action_82 (63) = happyShift action_43
action_82 (64) = happyShift action_44
action_82 (65) = happyShift action_45
action_82 (66) = happyShift action_46
action_82 (73) = happyShift action_47
action_82 (74) = happyShift action_48
action_82 (78) = happyShift action_49
action_82 (82) = happyShift action_50
action_82 (24) = happyGoto action_110
action_82 (25) = happyGoto action_59
action_82 (26) = happyGoto action_29
action_82 (27) = happyGoto action_55
action_82 _ = happyFail

action_83 (40) = happyShift action_32
action_83 (49) = happyShift action_36
action_83 (50) = happyShift action_37
action_83 (56) = happyShift action_38
action_83 (59) = happyShift action_40
action_83 (62) = happyShift action_56
action_83 (63) = happyShift action_43
action_83 (64) = happyShift action_44
action_83 (65) = happyShift action_45
action_83 (66) = happyShift action_46
action_83 (73) = happyShift action_47
action_83 (74) = happyShift action_48
action_83 (78) = happyShift action_49
action_83 (82) = happyShift action_50
action_83 (24) = happyGoto action_109
action_83 (25) = happyGoto action_59
action_83 (26) = happyGoto action_29
action_83 (27) = happyGoto action_55
action_83 _ = happyFail

action_84 (40) = happyShift action_32
action_84 (49) = happyShift action_36
action_84 (50) = happyShift action_37
action_84 (56) = happyShift action_38
action_84 (59) = happyShift action_40
action_84 (62) = happyShift action_56
action_84 (63) = happyShift action_43
action_84 (64) = happyShift action_44
action_84 (65) = happyShift action_45
action_84 (66) = happyShift action_46
action_84 (73) = happyShift action_47
action_84 (74) = happyShift action_48
action_84 (78) = happyShift action_49
action_84 (82) = happyShift action_50
action_84 (24) = happyGoto action_108
action_84 (25) = happyGoto action_59
action_84 (26) = happyGoto action_29
action_84 (27) = happyGoto action_55
action_84 _ = happyFail

action_85 (40) = happyShift action_32
action_85 (49) = happyShift action_36
action_85 (50) = happyShift action_37
action_85 (56) = happyShift action_38
action_85 (59) = happyShift action_40
action_85 (62) = happyShift action_56
action_85 (63) = happyShift action_43
action_85 (64) = happyShift action_44
action_85 (65) = happyShift action_45
action_85 (66) = happyShift action_46
action_85 (73) = happyShift action_47
action_85 (74) = happyShift action_48
action_85 (78) = happyShift action_49
action_85 (82) = happyShift action_50
action_85 (24) = happyGoto action_107
action_85 (25) = happyGoto action_59
action_85 (26) = happyGoto action_29
action_85 (27) = happyGoto action_55
action_85 _ = happyFail

action_86 (40) = happyShift action_32
action_86 (49) = happyShift action_36
action_86 (50) = happyShift action_37
action_86 (56) = happyShift action_38
action_86 (59) = happyShift action_40
action_86 (62) = happyShift action_56
action_86 (63) = happyShift action_43
action_86 (64) = happyShift action_44
action_86 (65) = happyShift action_45
action_86 (66) = happyShift action_46
action_86 (73) = happyShift action_47
action_86 (74) = happyShift action_48
action_86 (78) = happyShift action_49
action_86 (82) = happyShift action_50
action_86 (24) = happyGoto action_106
action_86 (25) = happyGoto action_59
action_86 (26) = happyGoto action_29
action_86 (27) = happyGoto action_55
action_86 _ = happyFail

action_87 _ = happyReduce_57

action_88 (39) = happyShift action_104
action_88 (80) = happyShift action_105
action_88 _ = happyFail

action_89 _ = happyReduce_8

action_90 (60) = happyShift action_101
action_90 (83) = happyReduce_16
action_90 (12) = happyGoto action_103
action_90 (13) = happyGoto action_98
action_90 (14) = happyGoto action_99
action_90 (15) = happyGoto action_100
action_90 _ = happyReduce_21

action_91 (80) = happyShift action_102
action_91 (85) = happyShift action_96
action_91 _ = happyFail

action_92 (60) = happyShift action_101
action_92 (83) = happyReduce_16
action_92 (12) = happyGoto action_97
action_92 (13) = happyGoto action_98
action_92 (14) = happyGoto action_99
action_92 (15) = happyGoto action_100
action_92 _ = happyReduce_21

action_93 (84) = happyShift action_95
action_93 (85) = happyShift action_96
action_93 _ = happyFail

action_94 _ = happyReduce_9

action_95 (31) = happyShift action_147
action_95 (33) = happyShift action_148
action_95 (34) = happyShift action_149
action_95 (45) = happyShift action_150
action_95 (55) = happyShift action_151
action_95 (77) = happyShift action_152
action_95 (16) = happyGoto action_146
action_95 _ = happyFail

action_96 (62) = happyShift action_145
action_96 _ = happyFail

action_97 (83) = happyShift action_144
action_97 _ = happyFail

action_98 (80) = happyShift action_143
action_98 _ = happyReduce_17

action_99 _ = happyReduce_19

action_100 (62) = happyShift action_142
action_100 _ = happyFail

action_101 _ = happyReduce_22

action_102 _ = happyReduce_6

action_103 (83) = happyShift action_141
action_103 _ = happyFail

action_104 _ = happyReduce_31

action_105 (32) = happyShift action_11
action_105 (35) = happyShift action_31
action_105 (40) = happyShift action_32
action_105 (43) = happyShift action_33
action_105 (44) = happyShift action_34
action_105 (48) = happyShift action_35
action_105 (49) = happyShift action_36
action_105 (50) = happyShift action_37
action_105 (56) = happyShift action_38
action_105 (57) = happyShift action_39
action_105 (59) = happyShift action_40
action_105 (61) = happyShift action_41
action_105 (62) = happyShift action_42
action_105 (63) = happyShift action_43
action_105 (64) = happyShift action_44
action_105 (65) = happyShift action_45
action_105 (66) = happyShift action_46
action_105 (73) = happyShift action_47
action_105 (74) = happyShift action_48
action_105 (78) = happyShift action_49
action_105 (82) = happyShift action_50
action_105 (18) = happyGoto action_25
action_105 (20) = happyGoto action_140
action_105 (24) = happyGoto action_27
action_105 (25) = happyGoto action_28
action_105 (26) = happyGoto action_29
action_105 (27) = happyGoto action_30
action_105 _ = happyReduce_34

action_106 (77) = happyShift action_87
action_106 _ = happyReduce_74

action_107 (77) = happyShift action_87
action_107 _ = happyReduce_72

action_108 (30) = happyShift action_73
action_108 (36) = happyShift action_74
action_108 (47) = happyShift action_75
action_108 (75) = happyShift action_85
action_108 (76) = happyShift action_86
action_108 (77) = happyShift action_87
action_108 _ = happyReduce_73

action_109 (30) = happyShift action_73
action_109 (36) = happyShift action_74
action_109 (47) = happyShift action_75
action_109 (75) = happyShift action_85
action_109 (76) = happyShift action_86
action_109 (77) = happyShift action_87
action_109 _ = happyReduce_71

action_110 (30) = happyShift action_73
action_110 (36) = happyShift action_74
action_110 (47) = happyShift action_75
action_110 (52) = happyShift action_76
action_110 (67) = happyFail
action_110 (68) = happyFail
action_110 (69) = happyFail
action_110 (70) = happyFail
action_110 (71) = happyFail
action_110 (72) = happyFail
action_110 (73) = happyShift action_83
action_110 (74) = happyShift action_84
action_110 (75) = happyShift action_85
action_110 (76) = happyShift action_86
action_110 (77) = happyShift action_87
action_110 _ = happyReduce_84

action_111 (30) = happyShift action_73
action_111 (36) = happyShift action_74
action_111 (47) = happyShift action_75
action_111 (52) = happyShift action_76
action_111 (67) = happyFail
action_111 (68) = happyFail
action_111 (69) = happyFail
action_111 (70) = happyFail
action_111 (71) = happyFail
action_111 (72) = happyFail
action_111 (73) = happyShift action_83
action_111 (74) = happyShift action_84
action_111 (75) = happyShift action_85
action_111 (76) = happyShift action_86
action_111 (77) = happyShift action_87
action_111 _ = happyReduce_83

action_112 (30) = happyShift action_73
action_112 (36) = happyShift action_74
action_112 (47) = happyShift action_75
action_112 (52) = happyShift action_76
action_112 (67) = happyFail
action_112 (68) = happyFail
action_112 (69) = happyFail
action_112 (70) = happyFail
action_112 (71) = happyFail
action_112 (72) = happyFail
action_112 (73) = happyShift action_83
action_112 (74) = happyShift action_84
action_112 (75) = happyShift action_85
action_112 (76) = happyShift action_86
action_112 (77) = happyShift action_87
action_112 _ = happyReduce_80

action_113 (30) = happyShift action_73
action_113 (36) = happyShift action_74
action_113 (47) = happyShift action_75
action_113 (52) = happyShift action_76
action_113 (67) = happyFail
action_113 (68) = happyFail
action_113 (69) = happyFail
action_113 (70) = happyFail
action_113 (71) = happyFail
action_113 (72) = happyFail
action_113 (73) = happyShift action_83
action_113 (74) = happyShift action_84
action_113 (75) = happyShift action_85
action_113 (76) = happyShift action_86
action_113 (77) = happyShift action_87
action_113 _ = happyReduce_81

action_114 (30) = happyShift action_73
action_114 (36) = happyShift action_74
action_114 (47) = happyShift action_75
action_114 (52) = happyShift action_76
action_114 (67) = happyFail
action_114 (68) = happyFail
action_114 (69) = happyFail
action_114 (70) = happyFail
action_114 (71) = happyFail
action_114 (72) = happyFail
action_114 (73) = happyShift action_83
action_114 (74) = happyShift action_84
action_114 (75) = happyShift action_85
action_114 (76) = happyShift action_86
action_114 (77) = happyShift action_87
action_114 _ = happyReduce_82

action_115 (30) = happyShift action_73
action_115 (36) = happyShift action_74
action_115 (47) = happyShift action_75
action_115 (52) = happyShift action_76
action_115 (67) = happyFail
action_115 (68) = happyFail
action_115 (69) = happyFail
action_115 (70) = happyFail
action_115 (71) = happyFail
action_115 (72) = happyFail
action_115 (73) = happyShift action_83
action_115 (74) = happyShift action_84
action_115 (75) = happyShift action_85
action_115 (76) = happyShift action_86
action_115 (77) = happyShift action_87
action_115 _ = happyReduce_79

action_116 (30) = happyShift action_73
action_116 (36) = happyShift action_74
action_116 (47) = happyShift action_75
action_116 (75) = happyShift action_85
action_116 (76) = happyShift action_86
action_116 (77) = happyShift action_87
action_116 _ = happyReduce_77

action_117 (77) = happyShift action_87
action_117 _ = happyReduce_76

action_118 (77) = happyShift action_87
action_118 _ = happyReduce_75

action_119 (77) = happyShift action_87
action_119 _ = happyReduce_78

action_120 (30) = happyShift action_73
action_120 (36) = happyShift action_74
action_120 (47) = happyShift action_75
action_120 (52) = happyShift action_76
action_120 (67) = happyShift action_77
action_120 (68) = happyShift action_78
action_120 (69) = happyShift action_79
action_120 (70) = happyShift action_80
action_120 (71) = happyShift action_81
action_120 (72) = happyShift action_82
action_120 (73) = happyShift action_83
action_120 (74) = happyShift action_84
action_120 (75) = happyShift action_85
action_120 (76) = happyShift action_86
action_120 (77) = happyShift action_87
action_120 (87) = happyShift action_139
action_120 _ = happyFail

action_121 (30) = happyShift action_73
action_121 (36) = happyShift action_74
action_121 (47) = happyShift action_75
action_121 (52) = happyShift action_76
action_121 (67) = happyShift action_77
action_121 (68) = happyShift action_78
action_121 (69) = happyShift action_79
action_121 (70) = happyShift action_80
action_121 (71) = happyShift action_81
action_121 (72) = happyShift action_82
action_121 (73) = happyShift action_83
action_121 (74) = happyShift action_84
action_121 (75) = happyShift action_85
action_121 (76) = happyShift action_86
action_121 (77) = happyShift action_87
action_121 _ = happyReduce_35

action_122 _ = happyReduce_49

action_123 (38) = happyReduce_44
action_123 (39) = happyReduce_44
action_123 (80) = happyReduce_44
action_123 (86) = happyShift action_72
action_123 _ = happyReduce_51

action_124 (32) = happyShift action_11
action_124 (35) = happyShift action_31
action_124 (40) = happyShift action_32
action_124 (43) = happyShift action_33
action_124 (44) = happyShift action_34
action_124 (48) = happyShift action_35
action_124 (49) = happyShift action_36
action_124 (50) = happyShift action_37
action_124 (56) = happyShift action_38
action_124 (57) = happyShift action_39
action_124 (59) = happyShift action_40
action_124 (61) = happyShift action_41
action_124 (62) = happyShift action_42
action_124 (63) = happyShift action_43
action_124 (64) = happyShift action_44
action_124 (65) = happyShift action_45
action_124 (66) = happyShift action_46
action_124 (73) = happyShift action_47
action_124 (74) = happyShift action_48
action_124 (78) = happyShift action_49
action_124 (82) = happyShift action_50
action_124 (18) = happyGoto action_25
action_124 (20) = happyGoto action_138
action_124 (24) = happyGoto action_27
action_124 (25) = happyGoto action_28
action_124 (26) = happyGoto action_29
action_124 (27) = happyGoto action_30
action_124 _ = happyReduce_34

action_125 (30) = happyShift action_73
action_125 (36) = happyShift action_74
action_125 (47) = happyShift action_75
action_125 (52) = happyShift action_76
action_125 (67) = happyShift action_77
action_125 (68) = happyShift action_78
action_125 (69) = happyShift action_79
action_125 (70) = happyShift action_80
action_125 (71) = happyShift action_81
action_125 (72) = happyShift action_82
action_125 (73) = happyShift action_83
action_125 (74) = happyShift action_84
action_125 (75) = happyShift action_85
action_125 (76) = happyShift action_86
action_125 (77) = happyShift action_87
action_125 (87) = happyShift action_137
action_125 _ = happyFail

action_126 (38) = happyReduce_43
action_126 (39) = happyReduce_43
action_126 (80) = happyReduce_43
action_126 (86) = happyShift action_72
action_126 _ = happyReduce_51

action_127 (32) = happyShift action_11
action_127 (35) = happyShift action_31
action_127 (40) = happyShift action_32
action_127 (43) = happyShift action_33
action_127 (44) = happyShift action_34
action_127 (48) = happyShift action_35
action_127 (49) = happyShift action_36
action_127 (50) = happyShift action_37
action_127 (56) = happyShift action_38
action_127 (57) = happyShift action_39
action_127 (59) = happyShift action_40
action_127 (61) = happyShift action_41
action_127 (62) = happyShift action_42
action_127 (63) = happyShift action_43
action_127 (64) = happyShift action_44
action_127 (65) = happyShift action_45
action_127 (66) = happyShift action_46
action_127 (73) = happyShift action_47
action_127 (74) = happyShift action_48
action_127 (78) = happyShift action_49
action_127 (82) = happyShift action_50
action_127 (18) = happyGoto action_25
action_127 (20) = happyGoto action_136
action_127 (24) = happyGoto action_27
action_127 (25) = happyGoto action_28
action_127 (26) = happyGoto action_29
action_127 (27) = happyGoto action_30
action_127 _ = happyReduce_34

action_128 _ = happyReduce_40

action_129 (30) = happyShift action_73
action_129 (36) = happyShift action_74
action_129 (47) = happyShift action_75
action_129 (52) = happyShift action_76
action_129 (67) = happyShift action_77
action_129 (68) = happyShift action_78
action_129 (69) = happyShift action_79
action_129 (70) = happyShift action_80
action_129 (71) = happyShift action_81
action_129 (72) = happyShift action_82
action_129 (73) = happyShift action_83
action_129 (74) = happyShift action_84
action_129 (75) = happyShift action_85
action_129 (76) = happyShift action_86
action_129 (77) = happyShift action_87
action_129 (29) = happyGoto action_135
action_129 _ = happyReduce_89

action_130 (83) = happyShift action_134
action_130 _ = happyFail

action_131 _ = happyReduce_64

action_132 _ = happyReduce_58

action_133 _ = happyReduce_7

action_134 _ = happyReduce_85

action_135 (85) = happyShift action_162
action_135 _ = happyReduce_86

action_136 _ = happyReduce_39

action_137 _ = happyReduce_47

action_138 (38) = happyShift action_161
action_138 (21) = happyGoto action_160
action_138 _ = happyReduce_46

action_139 _ = happyReduce_56

action_140 _ = happyReduce_32

action_141 (84) = happyShift action_159
action_141 _ = happyFail

action_142 (10) = happyGoto action_158
action_142 _ = happyReduce_13

action_143 (60) = happyShift action_101
action_143 (14) = happyGoto action_157
action_143 (15) = happyGoto action_100
action_143 _ = happyReduce_21

action_144 _ = happyReduce_14

action_145 _ = happyReduce_12

action_146 (80) = happyShift action_156
action_146 _ = happyFail

action_147 (86) = happyShift action_155
action_147 (17) = happyGoto action_154
action_147 _ = happyReduce_30

action_148 _ = happyReduce_25

action_149 _ = happyReduce_26

action_150 _ = happyReduce_23

action_151 _ = happyReduce_24

action_152 (31) = happyShift action_147
action_152 (33) = happyShift action_148
action_152 (34) = happyShift action_149
action_152 (45) = happyShift action_150
action_152 (55) = happyShift action_151
action_152 (77) = happyShift action_152
action_152 (16) = happyGoto action_153
action_152 _ = happyFail

action_153 _ = happyReduce_28

action_154 (51) = happyShift action_168
action_154 _ = happyFail

action_155 (63) = happyShift action_167
action_155 _ = happyFail

action_156 _ = happyReduce_11

action_157 _ = happyReduce_18

action_158 (84) = happyShift action_166
action_158 (85) = happyShift action_96
action_158 _ = happyFail

action_159 (31) = happyShift action_147
action_159 (33) = happyShift action_148
action_159 (34) = happyShift action_149
action_159 (45) = happyShift action_150
action_159 (55) = happyShift action_151
action_159 (77) = happyShift action_152
action_159 (16) = happyGoto action_165
action_159 _ = happyFail

action_160 _ = happyReduce_38

action_161 (32) = happyShift action_11
action_161 (35) = happyShift action_31
action_161 (40) = happyShift action_32
action_161 (43) = happyShift action_33
action_161 (44) = happyShift action_34
action_161 (48) = happyShift action_35
action_161 (49) = happyShift action_36
action_161 (50) = happyShift action_37
action_161 (56) = happyShift action_38
action_161 (57) = happyShift action_39
action_161 (59) = happyShift action_40
action_161 (61) = happyShift action_41
action_161 (62) = happyShift action_42
action_161 (63) = happyShift action_43
action_161 (64) = happyShift action_44
action_161 (65) = happyShift action_45
action_161 (66) = happyShift action_46
action_161 (73) = happyShift action_47
action_161 (74) = happyShift action_48
action_161 (78) = happyShift action_49
action_161 (82) = happyShift action_50
action_161 (18) = happyGoto action_25
action_161 (20) = happyGoto action_164
action_161 (24) = happyGoto action_27
action_161 (25) = happyGoto action_28
action_161 (26) = happyGoto action_29
action_161 (27) = happyGoto action_30
action_161 _ = happyReduce_34

action_162 (40) = happyShift action_32
action_162 (49) = happyShift action_36
action_162 (50) = happyShift action_37
action_162 (56) = happyShift action_38
action_162 (59) = happyShift action_40
action_162 (62) = happyShift action_56
action_162 (63) = happyShift action_43
action_162 (64) = happyShift action_44
action_162 (65) = happyShift action_45
action_162 (66) = happyShift action_46
action_162 (73) = happyShift action_47
action_162 (74) = happyShift action_48
action_162 (78) = happyShift action_49
action_162 (82) = happyShift action_50
action_162 (24) = happyGoto action_163
action_162 (25) = happyGoto action_59
action_162 (26) = happyGoto action_29
action_162 (27) = happyGoto action_55
action_162 _ = happyFail

action_163 (30) = happyShift action_73
action_163 (36) = happyShift action_74
action_163 (47) = happyShift action_75
action_163 (52) = happyShift action_76
action_163 (67) = happyShift action_77
action_163 (68) = happyShift action_78
action_163 (69) = happyShift action_79
action_163 (70) = happyShift action_80
action_163 (71) = happyShift action_81
action_163 (72) = happyShift action_82
action_163 (73) = happyShift action_83
action_163 (74) = happyShift action_84
action_163 (75) = happyShift action_85
action_163 (76) = happyShift action_86
action_163 (77) = happyShift action_87
action_163 _ = happyReduce_88

action_164 _ = happyReduce_45

action_165 _ = happyReduce_15

action_166 (31) = happyShift action_147
action_166 (33) = happyShift action_148
action_166 (34) = happyShift action_149
action_166 (45) = happyShift action_150
action_166 (55) = happyShift action_151
action_166 (77) = happyShift action_152
action_166 (16) = happyGoto action_171
action_166 _ = happyFail

action_167 (87) = happyShift action_170
action_167 _ = happyFail

action_168 (31) = happyShift action_147
action_168 (33) = happyShift action_148
action_168 (34) = happyShift action_149
action_168 (45) = happyShift action_150
action_168 (55) = happyShift action_151
action_168 (77) = happyShift action_152
action_168 (16) = happyGoto action_169
action_168 _ = happyFail

action_169 _ = happyReduce_27

action_170 _ = happyReduce_29

action_171 _ = happyReduce_20

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

happyReduce_3 = happySpecReduce_2  6 happyReduction_3
happyReduction_3 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_2:happy_var_1
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
	(HappyTerminal (TId          happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (LoLabel (happy_var_2:happy_var_3)
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

happyReduce_9 = happySpecReduce_2  8 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_2:happy_var_1
	)
happyReduction_9 _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happyReduce 5 9 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyTerminal (TId          happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 ((happy_var_1:happy_var_2,happy_var_4)
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_3  10 happyReduction_12
happyReduction_12 (HappyTerminal (TId          happy_var_3))
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_3:happy_var_1
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_0  10 happyReduction_13
happyReduction_13  =  HappyAbsSyn10
		 ([]
	)

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

happyReduce_18 = happySpecReduce_3  13 happyReduction_18
happyReduction_18 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_3 : happy_var_1
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  13 happyReduction_19
happyReduction_19 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happyReduce 5 14 happyReduction_20
happyReduction_20 ((HappyAbsSyn16  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyTerminal (TId          happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 ((happy_var_2:happy_var_3,happy_var_5)
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
		 (ArrayT happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_2  16 happyReduction_28
happyReduction_28 (HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (PointerT happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  17 happyReduction_29
happyReduction_29 _
	(HappyTerminal (TIntconst    happy_var_2))
	_
	 =  HappyAbsSyn17
		 (Size happy_var_2
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_0  17 happyReduction_30
happyReduction_30  =  HappyAbsSyn17
		 (NoSize
	)

happyReduce_31 = happyReduce 4 18 happyReduction_31
happyReduction_31 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (Bl (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_3  19 happyReduction_32
happyReduction_32 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_3 : happy_var_1
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_0  19 happyReduction_33
happyReduction_33  =  HappyAbsSyn19
		 ([]
	)

happyReduce_34 = happySpecReduce_0  20 happyReduction_34
happyReduction_34  =  HappyAbsSyn20
		 (SEmpty
	)

happyReduce_35 = happySpecReduce_3  20 happyReduction_35
happyReduction_35 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn20
		 (SEqual happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  20 happyReduction_36
happyReduction_36 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn20
		 (SBlock happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn20
		 (SCall  happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happyReduce 5 20 happyReduction_38
happyReduction_38 ((HappyAbsSyn20  happy_var_5) `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SIf happy_var_2 happy_var_4 happy_var_5
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 4 20 happyReduction_39
happyReduction_39 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (SWhile happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_40 = happySpecReduce_3  20 happyReduction_40
happyReduction_40 (HappyAbsSyn20  happy_var_3)
	_
	(HappyTerminal (TId          happy_var_1))
	 =  HappyAbsSyn20
		 (SId    happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_2  20 happyReduction_41
happyReduction_41 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (SGoto (tokenizer happy_var_1)
	)
happyReduction_41 _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  20 happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn20
		 (SReturn
	)

happyReduce_43 = happySpecReduce_3  20 happyReduction_43
happyReduction_43 (HappyAbsSyn25  happy_var_3)
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (SNew   happy_var_2 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn25  happy_var_3)
	_
	_
	 =  HappyAbsSyn20
		 (SDispose happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_2  21 happyReduction_45
happyReduction_45 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (SElse happy_var_2
	)
happyReduction_45 _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  21 happyReduction_46
happyReduction_46  =  HappyAbsSyn20
		 (SEmpty
	)

happyReduce_47 = happySpecReduce_3  22 happyReduction_47
happyReduction_47 _
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn22
		 (happy_var_2
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_0  22 happyReduction_48
happyReduction_48  =  HappyAbsSyn22
		 (EEmpty
	)

happyReduce_49 = happySpecReduce_2  23 happyReduction_49
happyReduction_49 _
	_
	 =  HappyAbsSyn23
		 ([]
	)

happyReduce_50 = happySpecReduce_0  23 happyReduction_50
happyReduction_50  =  HappyAbsSyn23
		 ([]
	)

happyReduce_51 = happySpecReduce_1  24 happyReduction_51
happyReduction_51 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn22
		 (L happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  24 happyReduction_52
happyReduction_52 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn22
		 (R happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  25 happyReduction_53
happyReduction_53 (HappyTerminal (TId          happy_var_1))
	 =  HappyAbsSyn25
		 (LId happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  25 happyReduction_54
happyReduction_54 _
	 =  HappyAbsSyn25
		 (LResult
	)

happyReduce_55 = happySpecReduce_1  25 happyReduction_55
happyReduction_55 (HappyTerminal (TStringconst happy_var_1))
	 =  HappyAbsSyn25
		 (LString happy_var_1
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happyReduce 4 25 happyReduction_56
happyReduction_56 (_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (LValueExpr happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_57 = happySpecReduce_2  25 happyReduction_57
happyReduction_57 _
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn25
		 (LExpr happy_var_1
	)
happyReduction_57 _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  25 happyReduction_58
happyReduction_58 _
	(HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (LParen happy_var_2
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  26 happyReduction_59
happyReduction_59 (HappyTerminal (TIntconst    happy_var_1))
	 =  HappyAbsSyn26
		 (RInt     happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  26 happyReduction_60
happyReduction_60 _
	 =  HappyAbsSyn26
		 (RTrue
	)

happyReduce_61 = happySpecReduce_1  26 happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn26
		 (RFalse
	)

happyReduce_62 = happySpecReduce_1  26 happyReduction_62
happyReduction_62 (HappyTerminal (TRealconst   happy_var_1))
	 =  HappyAbsSyn26
		 (RReal    happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  26 happyReduction_63
happyReduction_63 (HappyTerminal (TCharconst   happy_var_1))
	 =  HappyAbsSyn26
		 (RChar    happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  26 happyReduction_64
happyReduction_64 _
	(HappyAbsSyn26  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RParen   happy_var_2
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  26 happyReduction_65
happyReduction_65 _
	 =  HappyAbsSyn26
		 (RNil
	)

happyReduce_66 = happySpecReduce_1  26 happyReduction_66
happyReduction_66 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (RCall    happy_var_1
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  26 happyReduction_67
happyReduction_67 (HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RPapaki  happy_var_2
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_2  26 happyReduction_68
happyReduction_68 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RNot     happy_var_2
	)
happyReduction_68 _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_2  26 happyReduction_69
happyReduction_69 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RPos     happy_var_2
	)
happyReduction_69 _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_2  26 happyReduction_70
happyReduction_70 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RNeg     happy_var_2
	)
happyReduction_70 _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  26 happyReduction_71
happyReduction_71 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RPlus    happy_var_1 happy_var_3
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  26 happyReduction_72
happyReduction_72 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RMul     happy_var_1 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  26 happyReduction_73
happyReduction_73 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RMinus   happy_var_1 happy_var_3
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_3  26 happyReduction_74
happyReduction_74 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RRealDiv happy_var_1 happy_var_3
	)
happyReduction_74 _ _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_3  26 happyReduction_75
happyReduction_75 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RDiv     happy_var_1 happy_var_3
	)
happyReduction_75 _ _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  26 happyReduction_76
happyReduction_76 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RMod     happy_var_1 happy_var_3
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_3  26 happyReduction_77
happyReduction_77 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (ROr      happy_var_1 happy_var_3
	)
happyReduction_77 _ _ _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  26 happyReduction_78
happyReduction_78 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RAnd     happy_var_1 happy_var_3
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  26 happyReduction_79
happyReduction_79 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (REq      happy_var_1 happy_var_3
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_3  26 happyReduction_80
happyReduction_80 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RDiff    happy_var_1 happy_var_3
	)
happyReduction_80 _ _ _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  26 happyReduction_81
happyReduction_81 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RLess    happy_var_1 happy_var_3
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_3  26 happyReduction_82
happyReduction_82 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RGreater happy_var_1 happy_var_3
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_3  26 happyReduction_83
happyReduction_83 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RGreq    happy_var_1 happy_var_3
	)
happyReduction_83 _ _ _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_3  26 happyReduction_84
happyReduction_84 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn26
		 (RSmeq    happy_var_1 happy_var_3
	)
happyReduction_84 _ _ _  = notHappyAtAll 

happyReduce_85 = happyReduce 4 27 happyReduction_85
happyReduction_85 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId          happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (CId happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_86 = happySpecReduce_2  28 happyReduction_86
happyReduction_86 (HappyAbsSyn28  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1:happy_var_2
	)
happyReduction_86 _ _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_0  28 happyReduction_87
happyReduction_87  =  HappyAbsSyn28
		 ([]
	)

happyReduce_88 = happySpecReduce_3  29 happyReduction_88
happyReduction_88 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_3:happy_var_1
	)
happyReduction_88 _ _ _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_0  29 happyReduction_89
happyReduction_89  =  HappyAbsSyn28
		 ([]
	)

happyNewToken action sts stk [] =
	action 88 88 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TAnd -> cont 30;
	TArray -> cont 31;
	TBegin -> cont 32;
	TBoolean -> cont 33;
	TChar -> cont 34;
	TDispose -> cont 35;
	TDivInt -> cont 36;
	TDo -> cont 37;
	TElse -> cont 38;
	TEnd -> cont 39;
	TFalse -> cont 40;
	TForward -> cont 41;
	TFunction -> cont 42;
	TGoto -> cont 43;
	TIf -> cont 44;
	TInteger -> cont 45;
	TLabel -> cont 46;
	TMod -> cont 47;
	TNew -> cont 48;
	TNil -> cont 49;
	TNot -> cont 50;
	TOf -> cont 51;
	TOr -> cont 52;
	TProcedure -> cont 53;
	TProgram -> cont 54;
	TReal -> cont 55;
	TResult -> cont 56;
	TReturn -> cont 57;
	TThen -> cont 58;
	TTrue -> cont 59;
	TVar -> cont 60;
	TWhile -> cont 61;
	TId          happy_dollar_dollar -> cont 62;
	TIntconst    happy_dollar_dollar -> cont 63;
	TRealconst   happy_dollar_dollar -> cont 64;
	TCharconst   happy_dollar_dollar -> cont 65;
	TStringconst happy_dollar_dollar -> cont 66;
	TLogiceq -> cont 67;
	TGreater -> cont 68;
	TSmaller -> cont 69;
	TDifferent -> cont 70;
	TGreaterequal -> cont 71;
	TSmallerequal -> cont 72;
	TAdd -> cont 73;
	TMinus -> cont 74;
	TMul -> cont 75;
	TDivReal -> cont 76;
	TPointer -> cont 77;
	TAdress -> cont 78;
	TEq -> cont 79;
	TSeperator -> cont 80;
	TDot -> cont 81;
	TLeftparen -> cont 82;
	TRightparen -> cont 83;
	TUpdown -> cont 84;
	TComma -> cont 85;
	TLeftbracket -> cont 86;
	TRightbracket -> cont 87;
	_ -> happyError' (tk:tks)
	}

happyError_ 88 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = return
    (<*>) = ap
instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> HappyIdentity a
happyError' = HappyIdentity . parseError

parse tks = happyRunIdentity happySomeParser where
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

type Id        = String
type Ids       = [Id]
type Variables = [(Ids,Type)]

data Local =
  LoVar Variables       |
  LoLabel Ids           |
  LoHeadBod Header Body |
  LoForward Header
--deriving(Show)
instance Show Local where
  show l = "Local" 

data Header =
  Procedure String Args |
  Function  String Args Type
  deriving(Show)

type Formal = (Ids,Type)
type Args   = [Formal]

data Type =
  Tint                | 
  Treal               |
  Tbool               |
  Tchar               |
  ArrayT ArrSize Type |
  PointerT Type 
  deriving(Show)

data ArrSize =
  Size Int |
  NoSize
  deriving(Show)

data Block =
  Bl Stmts
  deriving(Show)
  
type Stmts = [Stmt]

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

main = getContents >>= print . parse . alexScanTokens
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
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}

{-# LINE 46 "templates/GenericTemplate.hs" #-}








{-# LINE 67 "templates/GenericTemplate.hs" #-}

{-# LINE 77 "templates/GenericTemplate.hs" #-}

{-# LINE 86 "templates/GenericTemplate.hs" #-}

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

{-# LINE 155 "templates/GenericTemplate.hs" #-}

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
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

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
happyFail  i tk (HappyState (action)) sts stk =
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

{-# LINE 322 "templates/GenericTemplate.hs" #-}
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
