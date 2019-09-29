{-# OPTIONS_GHC -w #-}
module Main where
import Lexer
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29
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

action_9 (80) = happyShift action_50
action_9 _ = happyFail

action_10 _ = happyReduce_2

action_11 (32) = happyShift action_11
action_11 (35) = happyShift action_30
action_11 (40) = happyShift action_31
action_11 (43) = happyShift action_32
action_11 (44) = happyShift action_33
action_11 (48) = happyShift action_34
action_11 (49) = happyShift action_35
action_11 (50) = happyShift action_36
action_11 (56) = happyShift action_37
action_11 (57) = happyShift action_38
action_11 (59) = happyShift action_39
action_11 (61) = happyShift action_40
action_11 (62) = happyShift action_41
action_11 (63) = happyShift action_42
action_11 (64) = happyShift action_43
action_11 (65) = happyShift action_44
action_11 (66) = happyShift action_45
action_11 (73) = happyShift action_46
action_11 (74) = happyShift action_47
action_11 (78) = happyShift action_48
action_11 (82) = happyShift action_49
action_11 (18) = happyGoto action_24
action_11 (20) = happyGoto action_25
action_11 (24) = happyGoto action_26
action_11 (25) = happyGoto action_27
action_11 (26) = happyGoto action_28
action_11 (27) = happyGoto action_29
action_11 _ = happyReduce_35

action_12 (42) = happyShift action_13
action_12 (53) = happyShift action_15
action_12 (11) = happyGoto action_23
action_12 _ = happyFail

action_13 (62) = happyShift action_22
action_13 _ = happyFail

action_14 (62) = happyShift action_21
action_14 _ = happyFail

action_15 (62) = happyShift action_20
action_15 _ = happyFail

action_16 (62) = happyShift action_19
action_16 (8) = happyGoto action_18
action_16 _ = happyFail

action_17 _ = happyReduce_1

action_18 (62) = happyShift action_93
action_18 _ = happyReduce_5

action_19 (9) = happyGoto action_92
action_19 _ = happyReduce_12

action_20 (82) = happyShift action_91
action_20 _ = happyFail

action_21 (10) = happyGoto action_90
action_21 _ = happyReduce_14

action_22 (82) = happyShift action_89
action_22 _ = happyFail

action_23 (80) = happyShift action_88
action_23 _ = happyFail

action_24 _ = happyReduce_37

action_25 (19) = happyGoto action_87
action_25 _ = happyReduce_34

action_26 (30) = happyShift action_72
action_26 (36) = happyShift action_73
action_26 (47) = happyShift action_74
action_26 (52) = happyShift action_75
action_26 (67) = happyShift action_76
action_26 (68) = happyShift action_77
action_26 (69) = happyShift action_78
action_26 (70) = happyShift action_79
action_26 (71) = happyShift action_80
action_26 (72) = happyShift action_81
action_26 (73) = happyShift action_82
action_26 (74) = happyShift action_83
action_26 (75) = happyShift action_84
action_26 (76) = happyShift action_85
action_26 (77) = happyShift action_86
action_26 _ = happyFail

action_27 (79) = happyShift action_70
action_27 (86) = happyShift action_71
action_27 _ = happyReduce_52

action_28 _ = happyReduce_53

action_29 (38) = happyReduce_38
action_29 (39) = happyReduce_38
action_29 (80) = happyReduce_38
action_29 _ = happyReduce_67

action_30 (86) = happyShift action_69
action_30 (23) = happyGoto action_68
action_30 _ = happyReduce_51

action_31 _ = happyReduce_62

action_32 (62) = happyShift action_67
action_32 _ = happyFail

action_33 (40) = happyShift action_31
action_33 (49) = happyShift action_35
action_33 (50) = happyShift action_36
action_33 (56) = happyShift action_37
action_33 (59) = happyShift action_39
action_33 (62) = happyShift action_55
action_33 (63) = happyShift action_42
action_33 (64) = happyShift action_43
action_33 (65) = happyShift action_44
action_33 (66) = happyShift action_45
action_33 (73) = happyShift action_46
action_33 (74) = happyShift action_47
action_33 (78) = happyShift action_48
action_33 (82) = happyShift action_49
action_33 (24) = happyGoto action_66
action_33 (25) = happyGoto action_58
action_33 (26) = happyGoto action_28
action_33 (27) = happyGoto action_54
action_33 _ = happyFail

action_34 (86) = happyShift action_65
action_34 (22) = happyGoto action_64
action_34 _ = happyReduce_49

action_35 _ = happyReduce_66

action_36 (40) = happyShift action_31
action_36 (49) = happyShift action_35
action_36 (50) = happyShift action_36
action_36 (56) = happyShift action_37
action_36 (59) = happyShift action_39
action_36 (62) = happyShift action_55
action_36 (63) = happyShift action_42
action_36 (64) = happyShift action_43
action_36 (65) = happyShift action_44
action_36 (66) = happyShift action_45
action_36 (73) = happyShift action_46
action_36 (74) = happyShift action_47
action_36 (78) = happyShift action_48
action_36 (82) = happyShift action_49
action_36 (24) = happyGoto action_63
action_36 (25) = happyGoto action_58
action_36 (26) = happyGoto action_28
action_36 (27) = happyGoto action_54
action_36 _ = happyFail

action_37 _ = happyReduce_55

action_38 _ = happyReduce_43

action_39 _ = happyReduce_61

action_40 (40) = happyShift action_31
action_40 (49) = happyShift action_35
action_40 (50) = happyShift action_36
action_40 (56) = happyShift action_37
action_40 (59) = happyShift action_39
action_40 (62) = happyShift action_55
action_40 (63) = happyShift action_42
action_40 (64) = happyShift action_43
action_40 (65) = happyShift action_44
action_40 (66) = happyShift action_45
action_40 (73) = happyShift action_46
action_40 (74) = happyShift action_47
action_40 (78) = happyShift action_48
action_40 (82) = happyShift action_49
action_40 (24) = happyGoto action_62
action_40 (25) = happyGoto action_58
action_40 (26) = happyGoto action_28
action_40 (27) = happyGoto action_54
action_40 _ = happyFail

action_41 (82) = happyShift action_60
action_41 (84) = happyShift action_61
action_41 _ = happyReduce_54

action_42 _ = happyReduce_60

action_43 _ = happyReduce_63

action_44 _ = happyReduce_64

action_45 _ = happyReduce_56

action_46 (40) = happyShift action_31
action_46 (49) = happyShift action_35
action_46 (50) = happyShift action_36
action_46 (56) = happyShift action_37
action_46 (59) = happyShift action_39
action_46 (62) = happyShift action_55
action_46 (63) = happyShift action_42
action_46 (64) = happyShift action_43
action_46 (65) = happyShift action_44
action_46 (66) = happyShift action_45
action_46 (73) = happyShift action_46
action_46 (74) = happyShift action_47
action_46 (78) = happyShift action_48
action_46 (82) = happyShift action_49
action_46 (24) = happyGoto action_59
action_46 (25) = happyGoto action_58
action_46 (26) = happyGoto action_28
action_46 (27) = happyGoto action_54
action_46 _ = happyFail

action_47 (40) = happyShift action_31
action_47 (49) = happyShift action_35
action_47 (50) = happyShift action_36
action_47 (56) = happyShift action_37
action_47 (59) = happyShift action_39
action_47 (62) = happyShift action_55
action_47 (63) = happyShift action_42
action_47 (64) = happyShift action_43
action_47 (65) = happyShift action_44
action_47 (66) = happyShift action_45
action_47 (73) = happyShift action_46
action_47 (74) = happyShift action_47
action_47 (78) = happyShift action_48
action_47 (82) = happyShift action_49
action_47 (24) = happyGoto action_57
action_47 (25) = happyGoto action_58
action_47 (26) = happyGoto action_28
action_47 (27) = happyGoto action_54
action_47 _ = happyFail

action_48 (40) = happyShift action_31
action_48 (49) = happyShift action_35
action_48 (50) = happyShift action_36
action_48 (56) = happyShift action_37
action_48 (59) = happyShift action_39
action_48 (62) = happyShift action_55
action_48 (63) = happyShift action_42
action_48 (64) = happyShift action_43
action_48 (65) = happyShift action_44
action_48 (66) = happyShift action_45
action_48 (73) = happyShift action_46
action_48 (74) = happyShift action_47
action_48 (78) = happyShift action_48
action_48 (82) = happyShift action_49
action_48 (24) = happyGoto action_26
action_48 (25) = happyGoto action_56
action_48 (26) = happyGoto action_28
action_48 (27) = happyGoto action_54
action_48 _ = happyFail

action_49 (40) = happyShift action_31
action_49 (49) = happyShift action_35
action_49 (50) = happyShift action_36
action_49 (56) = happyShift action_37
action_49 (59) = happyShift action_39
action_49 (62) = happyShift action_55
action_49 (63) = happyShift action_42
action_49 (64) = happyShift action_43
action_49 (65) = happyShift action_44
action_49 (66) = happyShift action_45
action_49 (73) = happyShift action_46
action_49 (74) = happyShift action_47
action_49 (78) = happyShift action_48
action_49 (82) = happyShift action_49
action_49 (24) = happyGoto action_26
action_49 (25) = happyGoto action_52
action_49 (26) = happyGoto action_53
action_49 (27) = happyGoto action_54
action_49 _ = happyFail

action_50 (5) = happyGoto action_51
action_50 (6) = happyGoto action_7
action_50 _ = happyReduce_4

action_51 (80) = happyShift action_134
action_51 _ = happyFail

action_52 (83) = happyShift action_133
action_52 (86) = happyShift action_71
action_52 _ = happyReduce_52

action_53 (83) = happyShift action_132
action_53 _ = happyReduce_53

action_54 _ = happyReduce_67

action_55 (82) = happyShift action_60
action_55 _ = happyReduce_54

action_56 (30) = happyReduce_68
action_56 (36) = happyReduce_68
action_56 (47) = happyReduce_68
action_56 (52) = happyReduce_68
action_56 (67) = happyReduce_68
action_56 (68) = happyReduce_68
action_56 (69) = happyReduce_68
action_56 (70) = happyReduce_68
action_56 (71) = happyReduce_68
action_56 (72) = happyReduce_68
action_56 (73) = happyReduce_68
action_56 (74) = happyReduce_68
action_56 (75) = happyReduce_68
action_56 (76) = happyReduce_68
action_56 (77) = happyReduce_68
action_56 (86) = happyShift action_71
action_56 _ = happyReduce_68

action_57 (77) = happyShift action_86
action_57 _ = happyReduce_71

action_58 (86) = happyShift action_71
action_58 _ = happyReduce_52

action_59 (77) = happyShift action_86
action_59 _ = happyReduce_70

action_60 (40) = happyShift action_31
action_60 (49) = happyShift action_35
action_60 (50) = happyShift action_36
action_60 (56) = happyShift action_37
action_60 (59) = happyShift action_39
action_60 (62) = happyShift action_55
action_60 (63) = happyShift action_42
action_60 (64) = happyShift action_43
action_60 (65) = happyShift action_44
action_60 (66) = happyShift action_45
action_60 (73) = happyShift action_46
action_60 (74) = happyShift action_47
action_60 (78) = happyShift action_48
action_60 (82) = happyShift action_49
action_60 (24) = happyGoto action_130
action_60 (25) = happyGoto action_58
action_60 (26) = happyGoto action_28
action_60 (27) = happyGoto action_54
action_60 (28) = happyGoto action_131
action_60 _ = happyReduce_87

action_61 (32) = happyShift action_11
action_61 (35) = happyShift action_30
action_61 (40) = happyShift action_31
action_61 (43) = happyShift action_32
action_61 (44) = happyShift action_33
action_61 (48) = happyShift action_34
action_61 (49) = happyShift action_35
action_61 (50) = happyShift action_36
action_61 (56) = happyShift action_37
action_61 (57) = happyShift action_38
action_61 (59) = happyShift action_39
action_61 (61) = happyShift action_40
action_61 (62) = happyShift action_41
action_61 (63) = happyShift action_42
action_61 (64) = happyShift action_43
action_61 (65) = happyShift action_44
action_61 (66) = happyShift action_45
action_61 (73) = happyShift action_46
action_61 (74) = happyShift action_47
action_61 (78) = happyShift action_48
action_61 (82) = happyShift action_49
action_61 (18) = happyGoto action_24
action_61 (20) = happyGoto action_129
action_61 (24) = happyGoto action_26
action_61 (25) = happyGoto action_27
action_61 (26) = happyGoto action_28
action_61 (27) = happyGoto action_29
action_61 _ = happyReduce_35

action_62 (30) = happyShift action_72
action_62 (36) = happyShift action_73
action_62 (37) = happyShift action_128
action_62 (47) = happyShift action_74
action_62 (52) = happyShift action_75
action_62 (67) = happyShift action_76
action_62 (68) = happyShift action_77
action_62 (69) = happyShift action_78
action_62 (70) = happyShift action_79
action_62 (71) = happyShift action_80
action_62 (72) = happyShift action_81
action_62 (73) = happyShift action_82
action_62 (74) = happyShift action_83
action_62 (75) = happyShift action_84
action_62 (76) = happyShift action_85
action_62 (77) = happyShift action_86
action_62 _ = happyFail

action_63 (77) = happyShift action_86
action_63 _ = happyReduce_69

action_64 (40) = happyShift action_31
action_64 (49) = happyShift action_35
action_64 (50) = happyShift action_36
action_64 (56) = happyShift action_37
action_64 (59) = happyShift action_39
action_64 (62) = happyShift action_55
action_64 (63) = happyShift action_42
action_64 (64) = happyShift action_43
action_64 (65) = happyShift action_44
action_64 (66) = happyShift action_45
action_64 (73) = happyShift action_46
action_64 (74) = happyShift action_47
action_64 (78) = happyShift action_48
action_64 (82) = happyShift action_49
action_64 (24) = happyGoto action_26
action_64 (25) = happyGoto action_127
action_64 (26) = happyGoto action_28
action_64 (27) = happyGoto action_54
action_64 _ = happyFail

action_65 (40) = happyShift action_31
action_65 (49) = happyShift action_35
action_65 (50) = happyShift action_36
action_65 (56) = happyShift action_37
action_65 (59) = happyShift action_39
action_65 (62) = happyShift action_55
action_65 (63) = happyShift action_42
action_65 (64) = happyShift action_43
action_65 (65) = happyShift action_44
action_65 (66) = happyShift action_45
action_65 (73) = happyShift action_46
action_65 (74) = happyShift action_47
action_65 (78) = happyShift action_48
action_65 (82) = happyShift action_49
action_65 (24) = happyGoto action_126
action_65 (25) = happyGoto action_58
action_65 (26) = happyGoto action_28
action_65 (27) = happyGoto action_54
action_65 _ = happyFail

action_66 (30) = happyShift action_72
action_66 (36) = happyShift action_73
action_66 (47) = happyShift action_74
action_66 (52) = happyShift action_75
action_66 (58) = happyShift action_125
action_66 (67) = happyShift action_76
action_66 (68) = happyShift action_77
action_66 (69) = happyShift action_78
action_66 (70) = happyShift action_79
action_66 (71) = happyShift action_80
action_66 (72) = happyShift action_81
action_66 (73) = happyShift action_82
action_66 (74) = happyShift action_83
action_66 (75) = happyShift action_84
action_66 (76) = happyShift action_85
action_66 (77) = happyShift action_86
action_66 _ = happyFail

action_67 _ = happyReduce_42

action_68 (40) = happyShift action_31
action_68 (49) = happyShift action_35
action_68 (50) = happyShift action_36
action_68 (56) = happyShift action_37
action_68 (59) = happyShift action_39
action_68 (62) = happyShift action_55
action_68 (63) = happyShift action_42
action_68 (64) = happyShift action_43
action_68 (65) = happyShift action_44
action_68 (66) = happyShift action_45
action_68 (73) = happyShift action_46
action_68 (74) = happyShift action_47
action_68 (78) = happyShift action_48
action_68 (82) = happyShift action_49
action_68 (24) = happyGoto action_26
action_68 (25) = happyGoto action_124
action_68 (26) = happyGoto action_28
action_68 (27) = happyGoto action_54
action_68 _ = happyFail

action_69 (87) = happyShift action_123
action_69 _ = happyFail

action_70 (40) = happyShift action_31
action_70 (49) = happyShift action_35
action_70 (50) = happyShift action_36
action_70 (56) = happyShift action_37
action_70 (59) = happyShift action_39
action_70 (62) = happyShift action_55
action_70 (63) = happyShift action_42
action_70 (64) = happyShift action_43
action_70 (65) = happyShift action_44
action_70 (66) = happyShift action_45
action_70 (73) = happyShift action_46
action_70 (74) = happyShift action_47
action_70 (78) = happyShift action_48
action_70 (82) = happyShift action_49
action_70 (24) = happyGoto action_122
action_70 (25) = happyGoto action_58
action_70 (26) = happyGoto action_28
action_70 (27) = happyGoto action_54
action_70 _ = happyFail

action_71 (40) = happyShift action_31
action_71 (49) = happyShift action_35
action_71 (50) = happyShift action_36
action_71 (56) = happyShift action_37
action_71 (59) = happyShift action_39
action_71 (62) = happyShift action_55
action_71 (63) = happyShift action_42
action_71 (64) = happyShift action_43
action_71 (65) = happyShift action_44
action_71 (66) = happyShift action_45
action_71 (73) = happyShift action_46
action_71 (74) = happyShift action_47
action_71 (78) = happyShift action_48
action_71 (82) = happyShift action_49
action_71 (24) = happyGoto action_121
action_71 (25) = happyGoto action_58
action_71 (26) = happyGoto action_28
action_71 (27) = happyGoto action_54
action_71 _ = happyFail

action_72 (40) = happyShift action_31
action_72 (49) = happyShift action_35
action_72 (50) = happyShift action_36
action_72 (56) = happyShift action_37
action_72 (59) = happyShift action_39
action_72 (62) = happyShift action_55
action_72 (63) = happyShift action_42
action_72 (64) = happyShift action_43
action_72 (65) = happyShift action_44
action_72 (66) = happyShift action_45
action_72 (73) = happyShift action_46
action_72 (74) = happyShift action_47
action_72 (78) = happyShift action_48
action_72 (82) = happyShift action_49
action_72 (24) = happyGoto action_120
action_72 (25) = happyGoto action_58
action_72 (26) = happyGoto action_28
action_72 (27) = happyGoto action_54
action_72 _ = happyFail

action_73 (40) = happyShift action_31
action_73 (49) = happyShift action_35
action_73 (50) = happyShift action_36
action_73 (56) = happyShift action_37
action_73 (59) = happyShift action_39
action_73 (62) = happyShift action_55
action_73 (63) = happyShift action_42
action_73 (64) = happyShift action_43
action_73 (65) = happyShift action_44
action_73 (66) = happyShift action_45
action_73 (73) = happyShift action_46
action_73 (74) = happyShift action_47
action_73 (78) = happyShift action_48
action_73 (82) = happyShift action_49
action_73 (24) = happyGoto action_119
action_73 (25) = happyGoto action_58
action_73 (26) = happyGoto action_28
action_73 (27) = happyGoto action_54
action_73 _ = happyFail

action_74 (40) = happyShift action_31
action_74 (49) = happyShift action_35
action_74 (50) = happyShift action_36
action_74 (56) = happyShift action_37
action_74 (59) = happyShift action_39
action_74 (62) = happyShift action_55
action_74 (63) = happyShift action_42
action_74 (64) = happyShift action_43
action_74 (65) = happyShift action_44
action_74 (66) = happyShift action_45
action_74 (73) = happyShift action_46
action_74 (74) = happyShift action_47
action_74 (78) = happyShift action_48
action_74 (82) = happyShift action_49
action_74 (24) = happyGoto action_118
action_74 (25) = happyGoto action_58
action_74 (26) = happyGoto action_28
action_74 (27) = happyGoto action_54
action_74 _ = happyFail

action_75 (40) = happyShift action_31
action_75 (49) = happyShift action_35
action_75 (50) = happyShift action_36
action_75 (56) = happyShift action_37
action_75 (59) = happyShift action_39
action_75 (62) = happyShift action_55
action_75 (63) = happyShift action_42
action_75 (64) = happyShift action_43
action_75 (65) = happyShift action_44
action_75 (66) = happyShift action_45
action_75 (73) = happyShift action_46
action_75 (74) = happyShift action_47
action_75 (78) = happyShift action_48
action_75 (82) = happyShift action_49
action_75 (24) = happyGoto action_117
action_75 (25) = happyGoto action_58
action_75 (26) = happyGoto action_28
action_75 (27) = happyGoto action_54
action_75 _ = happyFail

action_76 (40) = happyShift action_31
action_76 (49) = happyShift action_35
action_76 (50) = happyShift action_36
action_76 (56) = happyShift action_37
action_76 (59) = happyShift action_39
action_76 (62) = happyShift action_55
action_76 (63) = happyShift action_42
action_76 (64) = happyShift action_43
action_76 (65) = happyShift action_44
action_76 (66) = happyShift action_45
action_76 (73) = happyShift action_46
action_76 (74) = happyShift action_47
action_76 (78) = happyShift action_48
action_76 (82) = happyShift action_49
action_76 (24) = happyGoto action_116
action_76 (25) = happyGoto action_58
action_76 (26) = happyGoto action_28
action_76 (27) = happyGoto action_54
action_76 _ = happyFail

action_77 (40) = happyShift action_31
action_77 (49) = happyShift action_35
action_77 (50) = happyShift action_36
action_77 (56) = happyShift action_37
action_77 (59) = happyShift action_39
action_77 (62) = happyShift action_55
action_77 (63) = happyShift action_42
action_77 (64) = happyShift action_43
action_77 (65) = happyShift action_44
action_77 (66) = happyShift action_45
action_77 (73) = happyShift action_46
action_77 (74) = happyShift action_47
action_77 (78) = happyShift action_48
action_77 (82) = happyShift action_49
action_77 (24) = happyGoto action_115
action_77 (25) = happyGoto action_58
action_77 (26) = happyGoto action_28
action_77 (27) = happyGoto action_54
action_77 _ = happyFail

action_78 (40) = happyShift action_31
action_78 (49) = happyShift action_35
action_78 (50) = happyShift action_36
action_78 (56) = happyShift action_37
action_78 (59) = happyShift action_39
action_78 (62) = happyShift action_55
action_78 (63) = happyShift action_42
action_78 (64) = happyShift action_43
action_78 (65) = happyShift action_44
action_78 (66) = happyShift action_45
action_78 (73) = happyShift action_46
action_78 (74) = happyShift action_47
action_78 (78) = happyShift action_48
action_78 (82) = happyShift action_49
action_78 (24) = happyGoto action_114
action_78 (25) = happyGoto action_58
action_78 (26) = happyGoto action_28
action_78 (27) = happyGoto action_54
action_78 _ = happyFail

action_79 (40) = happyShift action_31
action_79 (49) = happyShift action_35
action_79 (50) = happyShift action_36
action_79 (56) = happyShift action_37
action_79 (59) = happyShift action_39
action_79 (62) = happyShift action_55
action_79 (63) = happyShift action_42
action_79 (64) = happyShift action_43
action_79 (65) = happyShift action_44
action_79 (66) = happyShift action_45
action_79 (73) = happyShift action_46
action_79 (74) = happyShift action_47
action_79 (78) = happyShift action_48
action_79 (82) = happyShift action_49
action_79 (24) = happyGoto action_113
action_79 (25) = happyGoto action_58
action_79 (26) = happyGoto action_28
action_79 (27) = happyGoto action_54
action_79 _ = happyFail

action_80 (40) = happyShift action_31
action_80 (49) = happyShift action_35
action_80 (50) = happyShift action_36
action_80 (56) = happyShift action_37
action_80 (59) = happyShift action_39
action_80 (62) = happyShift action_55
action_80 (63) = happyShift action_42
action_80 (64) = happyShift action_43
action_80 (65) = happyShift action_44
action_80 (66) = happyShift action_45
action_80 (73) = happyShift action_46
action_80 (74) = happyShift action_47
action_80 (78) = happyShift action_48
action_80 (82) = happyShift action_49
action_80 (24) = happyGoto action_112
action_80 (25) = happyGoto action_58
action_80 (26) = happyGoto action_28
action_80 (27) = happyGoto action_54
action_80 _ = happyFail

action_81 (40) = happyShift action_31
action_81 (49) = happyShift action_35
action_81 (50) = happyShift action_36
action_81 (56) = happyShift action_37
action_81 (59) = happyShift action_39
action_81 (62) = happyShift action_55
action_81 (63) = happyShift action_42
action_81 (64) = happyShift action_43
action_81 (65) = happyShift action_44
action_81 (66) = happyShift action_45
action_81 (73) = happyShift action_46
action_81 (74) = happyShift action_47
action_81 (78) = happyShift action_48
action_81 (82) = happyShift action_49
action_81 (24) = happyGoto action_111
action_81 (25) = happyGoto action_58
action_81 (26) = happyGoto action_28
action_81 (27) = happyGoto action_54
action_81 _ = happyFail

action_82 (40) = happyShift action_31
action_82 (49) = happyShift action_35
action_82 (50) = happyShift action_36
action_82 (56) = happyShift action_37
action_82 (59) = happyShift action_39
action_82 (62) = happyShift action_55
action_82 (63) = happyShift action_42
action_82 (64) = happyShift action_43
action_82 (65) = happyShift action_44
action_82 (66) = happyShift action_45
action_82 (73) = happyShift action_46
action_82 (74) = happyShift action_47
action_82 (78) = happyShift action_48
action_82 (82) = happyShift action_49
action_82 (24) = happyGoto action_110
action_82 (25) = happyGoto action_58
action_82 (26) = happyGoto action_28
action_82 (27) = happyGoto action_54
action_82 _ = happyFail

action_83 (40) = happyShift action_31
action_83 (49) = happyShift action_35
action_83 (50) = happyShift action_36
action_83 (56) = happyShift action_37
action_83 (59) = happyShift action_39
action_83 (62) = happyShift action_55
action_83 (63) = happyShift action_42
action_83 (64) = happyShift action_43
action_83 (65) = happyShift action_44
action_83 (66) = happyShift action_45
action_83 (73) = happyShift action_46
action_83 (74) = happyShift action_47
action_83 (78) = happyShift action_48
action_83 (82) = happyShift action_49
action_83 (24) = happyGoto action_109
action_83 (25) = happyGoto action_58
action_83 (26) = happyGoto action_28
action_83 (27) = happyGoto action_54
action_83 _ = happyFail

action_84 (40) = happyShift action_31
action_84 (49) = happyShift action_35
action_84 (50) = happyShift action_36
action_84 (56) = happyShift action_37
action_84 (59) = happyShift action_39
action_84 (62) = happyShift action_55
action_84 (63) = happyShift action_42
action_84 (64) = happyShift action_43
action_84 (65) = happyShift action_44
action_84 (66) = happyShift action_45
action_84 (73) = happyShift action_46
action_84 (74) = happyShift action_47
action_84 (78) = happyShift action_48
action_84 (82) = happyShift action_49
action_84 (24) = happyGoto action_108
action_84 (25) = happyGoto action_58
action_84 (26) = happyGoto action_28
action_84 (27) = happyGoto action_54
action_84 _ = happyFail

action_85 (40) = happyShift action_31
action_85 (49) = happyShift action_35
action_85 (50) = happyShift action_36
action_85 (56) = happyShift action_37
action_85 (59) = happyShift action_39
action_85 (62) = happyShift action_55
action_85 (63) = happyShift action_42
action_85 (64) = happyShift action_43
action_85 (65) = happyShift action_44
action_85 (66) = happyShift action_45
action_85 (73) = happyShift action_46
action_85 (74) = happyShift action_47
action_85 (78) = happyShift action_48
action_85 (82) = happyShift action_49
action_85 (24) = happyGoto action_107
action_85 (25) = happyGoto action_58
action_85 (26) = happyGoto action_28
action_85 (27) = happyGoto action_54
action_85 _ = happyFail

action_86 _ = happyReduce_58

action_87 (39) = happyShift action_105
action_87 (80) = happyShift action_106
action_87 _ = happyFail

action_88 _ = happyReduce_8

action_89 (60) = happyShift action_101
action_89 (83) = happyReduce_17
action_89 (12) = happyGoto action_104
action_89 (13) = happyGoto action_98
action_89 (14) = happyGoto action_99
action_89 (15) = happyGoto action_100
action_89 _ = happyReduce_22

action_90 (80) = happyShift action_102
action_90 (85) = happyShift action_103
action_90 _ = happyFail

action_91 (60) = happyShift action_101
action_91 (83) = happyReduce_17
action_91 (12) = happyGoto action_97
action_91 (13) = happyGoto action_98
action_91 (14) = happyGoto action_99
action_91 (15) = happyGoto action_100
action_91 _ = happyReduce_22

action_92 (84) = happyShift action_95
action_92 (85) = happyShift action_96
action_92 _ = happyFail

action_93 (9) = happyGoto action_94
action_93 _ = happyReduce_12

action_94 (84) = happyShift action_155
action_94 (85) = happyShift action_96
action_94 _ = happyFail

action_95 (31) = happyShift action_149
action_95 (33) = happyShift action_150
action_95 (34) = happyShift action_151
action_95 (45) = happyShift action_152
action_95 (55) = happyShift action_153
action_95 (77) = happyShift action_154
action_95 (16) = happyGoto action_148
action_95 _ = happyFail

action_96 (62) = happyShift action_147
action_96 _ = happyFail

action_97 (83) = happyShift action_146
action_97 _ = happyFail

action_98 (80) = happyShift action_145
action_98 _ = happyReduce_18

action_99 _ = happyReduce_20

action_100 (62) = happyShift action_144
action_100 _ = happyFail

action_101 _ = happyReduce_23

action_102 _ = happyReduce_6

action_103 (62) = happyShift action_143
action_103 _ = happyFail

action_104 (83) = happyShift action_142
action_104 _ = happyFail

action_105 _ = happyReduce_32

action_106 (32) = happyShift action_11
action_106 (35) = happyShift action_30
action_106 (40) = happyShift action_31
action_106 (43) = happyShift action_32
action_106 (44) = happyShift action_33
action_106 (48) = happyShift action_34
action_106 (49) = happyShift action_35
action_106 (50) = happyShift action_36
action_106 (56) = happyShift action_37
action_106 (57) = happyShift action_38
action_106 (59) = happyShift action_39
action_106 (61) = happyShift action_40
action_106 (62) = happyShift action_41
action_106 (63) = happyShift action_42
action_106 (64) = happyShift action_43
action_106 (65) = happyShift action_44
action_106 (66) = happyShift action_45
action_106 (73) = happyShift action_46
action_106 (74) = happyShift action_47
action_106 (78) = happyShift action_48
action_106 (82) = happyShift action_49
action_106 (18) = happyGoto action_24
action_106 (20) = happyGoto action_141
action_106 (24) = happyGoto action_26
action_106 (25) = happyGoto action_27
action_106 (26) = happyGoto action_28
action_106 (27) = happyGoto action_29
action_106 _ = happyReduce_35

action_107 (77) = happyShift action_86
action_107 _ = happyReduce_75

action_108 (77) = happyShift action_86
action_108 _ = happyReduce_73

action_109 (30) = happyShift action_72
action_109 (36) = happyShift action_73
action_109 (47) = happyShift action_74
action_109 (75) = happyShift action_84
action_109 (76) = happyShift action_85
action_109 (77) = happyShift action_86
action_109 _ = happyReduce_74

action_110 (30) = happyShift action_72
action_110 (36) = happyShift action_73
action_110 (47) = happyShift action_74
action_110 (75) = happyShift action_84
action_110 (76) = happyShift action_85
action_110 (77) = happyShift action_86
action_110 _ = happyReduce_72

action_111 (30) = happyShift action_72
action_111 (36) = happyShift action_73
action_111 (47) = happyShift action_74
action_111 (52) = happyShift action_75
action_111 (67) = happyFail
action_111 (68) = happyFail
action_111 (69) = happyFail
action_111 (70) = happyFail
action_111 (71) = happyFail
action_111 (72) = happyFail
action_111 (73) = happyShift action_82
action_111 (74) = happyShift action_83
action_111 (75) = happyShift action_84
action_111 (76) = happyShift action_85
action_111 (77) = happyShift action_86
action_111 _ = happyReduce_85

action_112 (30) = happyShift action_72
action_112 (36) = happyShift action_73
action_112 (47) = happyShift action_74
action_112 (52) = happyShift action_75
action_112 (67) = happyFail
action_112 (68) = happyFail
action_112 (69) = happyFail
action_112 (70) = happyFail
action_112 (71) = happyFail
action_112 (72) = happyFail
action_112 (73) = happyShift action_82
action_112 (74) = happyShift action_83
action_112 (75) = happyShift action_84
action_112 (76) = happyShift action_85
action_112 (77) = happyShift action_86
action_112 _ = happyReduce_84

action_113 (30) = happyShift action_72
action_113 (36) = happyShift action_73
action_113 (47) = happyShift action_74
action_113 (52) = happyShift action_75
action_113 (67) = happyFail
action_113 (68) = happyFail
action_113 (69) = happyFail
action_113 (70) = happyFail
action_113 (71) = happyFail
action_113 (72) = happyFail
action_113 (73) = happyShift action_82
action_113 (74) = happyShift action_83
action_113 (75) = happyShift action_84
action_113 (76) = happyShift action_85
action_113 (77) = happyShift action_86
action_113 _ = happyReduce_81

action_114 (30) = happyShift action_72
action_114 (36) = happyShift action_73
action_114 (47) = happyShift action_74
action_114 (52) = happyShift action_75
action_114 (67) = happyFail
action_114 (68) = happyFail
action_114 (69) = happyFail
action_114 (70) = happyFail
action_114 (71) = happyFail
action_114 (72) = happyFail
action_114 (73) = happyShift action_82
action_114 (74) = happyShift action_83
action_114 (75) = happyShift action_84
action_114 (76) = happyShift action_85
action_114 (77) = happyShift action_86
action_114 _ = happyReduce_82

action_115 (30) = happyShift action_72
action_115 (36) = happyShift action_73
action_115 (47) = happyShift action_74
action_115 (52) = happyShift action_75
action_115 (67) = happyFail
action_115 (68) = happyFail
action_115 (69) = happyFail
action_115 (70) = happyFail
action_115 (71) = happyFail
action_115 (72) = happyFail
action_115 (73) = happyShift action_82
action_115 (74) = happyShift action_83
action_115 (75) = happyShift action_84
action_115 (76) = happyShift action_85
action_115 (77) = happyShift action_86
action_115 _ = happyReduce_83

action_116 (30) = happyShift action_72
action_116 (36) = happyShift action_73
action_116 (47) = happyShift action_74
action_116 (52) = happyShift action_75
action_116 (67) = happyFail
action_116 (68) = happyFail
action_116 (69) = happyFail
action_116 (70) = happyFail
action_116 (71) = happyFail
action_116 (72) = happyFail
action_116 (73) = happyShift action_82
action_116 (74) = happyShift action_83
action_116 (75) = happyShift action_84
action_116 (76) = happyShift action_85
action_116 (77) = happyShift action_86
action_116 _ = happyReduce_80

action_117 (30) = happyShift action_72
action_117 (36) = happyShift action_73
action_117 (47) = happyShift action_74
action_117 (75) = happyShift action_84
action_117 (76) = happyShift action_85
action_117 (77) = happyShift action_86
action_117 _ = happyReduce_78

action_118 (77) = happyShift action_86
action_118 _ = happyReduce_77

action_119 (77) = happyShift action_86
action_119 _ = happyReduce_76

action_120 (77) = happyShift action_86
action_120 _ = happyReduce_79

action_121 (30) = happyShift action_72
action_121 (36) = happyShift action_73
action_121 (47) = happyShift action_74
action_121 (52) = happyShift action_75
action_121 (67) = happyShift action_76
action_121 (68) = happyShift action_77
action_121 (69) = happyShift action_78
action_121 (70) = happyShift action_79
action_121 (71) = happyShift action_80
action_121 (72) = happyShift action_81
action_121 (73) = happyShift action_82
action_121 (74) = happyShift action_83
action_121 (75) = happyShift action_84
action_121 (76) = happyShift action_85
action_121 (77) = happyShift action_86
action_121 (87) = happyShift action_140
action_121 _ = happyFail

action_122 (30) = happyShift action_72
action_122 (36) = happyShift action_73
action_122 (47) = happyShift action_74
action_122 (52) = happyShift action_75
action_122 (67) = happyShift action_76
action_122 (68) = happyShift action_77
action_122 (69) = happyShift action_78
action_122 (70) = happyShift action_79
action_122 (71) = happyShift action_80
action_122 (72) = happyShift action_81
action_122 (73) = happyShift action_82
action_122 (74) = happyShift action_83
action_122 (75) = happyShift action_84
action_122 (76) = happyShift action_85
action_122 (77) = happyShift action_86
action_122 _ = happyReduce_36

action_123 _ = happyReduce_50

action_124 (38) = happyReduce_45
action_124 (39) = happyReduce_45
action_124 (80) = happyReduce_45
action_124 (86) = happyShift action_71
action_124 _ = happyReduce_52

action_125 (32) = happyShift action_11
action_125 (35) = happyShift action_30
action_125 (40) = happyShift action_31
action_125 (43) = happyShift action_32
action_125 (44) = happyShift action_33
action_125 (48) = happyShift action_34
action_125 (49) = happyShift action_35
action_125 (50) = happyShift action_36
action_125 (56) = happyShift action_37
action_125 (57) = happyShift action_38
action_125 (59) = happyShift action_39
action_125 (61) = happyShift action_40
action_125 (62) = happyShift action_41
action_125 (63) = happyShift action_42
action_125 (64) = happyShift action_43
action_125 (65) = happyShift action_44
action_125 (66) = happyShift action_45
action_125 (73) = happyShift action_46
action_125 (74) = happyShift action_47
action_125 (78) = happyShift action_48
action_125 (82) = happyShift action_49
action_125 (18) = happyGoto action_24
action_125 (20) = happyGoto action_139
action_125 (24) = happyGoto action_26
action_125 (25) = happyGoto action_27
action_125 (26) = happyGoto action_28
action_125 (27) = happyGoto action_29
action_125 _ = happyReduce_35

action_126 (30) = happyShift action_72
action_126 (36) = happyShift action_73
action_126 (47) = happyShift action_74
action_126 (52) = happyShift action_75
action_126 (67) = happyShift action_76
action_126 (68) = happyShift action_77
action_126 (69) = happyShift action_78
action_126 (70) = happyShift action_79
action_126 (71) = happyShift action_80
action_126 (72) = happyShift action_81
action_126 (73) = happyShift action_82
action_126 (74) = happyShift action_83
action_126 (75) = happyShift action_84
action_126 (76) = happyShift action_85
action_126 (77) = happyShift action_86
action_126 (87) = happyShift action_138
action_126 _ = happyFail

action_127 (38) = happyReduce_44
action_127 (39) = happyReduce_44
action_127 (80) = happyReduce_44
action_127 (86) = happyShift action_71
action_127 _ = happyReduce_52

action_128 (32) = happyShift action_11
action_128 (35) = happyShift action_30
action_128 (40) = happyShift action_31
action_128 (43) = happyShift action_32
action_128 (44) = happyShift action_33
action_128 (48) = happyShift action_34
action_128 (49) = happyShift action_35
action_128 (50) = happyShift action_36
action_128 (56) = happyShift action_37
action_128 (57) = happyShift action_38
action_128 (59) = happyShift action_39
action_128 (61) = happyShift action_40
action_128 (62) = happyShift action_41
action_128 (63) = happyShift action_42
action_128 (64) = happyShift action_43
action_128 (65) = happyShift action_44
action_128 (66) = happyShift action_45
action_128 (73) = happyShift action_46
action_128 (74) = happyShift action_47
action_128 (78) = happyShift action_48
action_128 (82) = happyShift action_49
action_128 (18) = happyGoto action_24
action_128 (20) = happyGoto action_137
action_128 (24) = happyGoto action_26
action_128 (25) = happyGoto action_27
action_128 (26) = happyGoto action_28
action_128 (27) = happyGoto action_29
action_128 _ = happyReduce_35

action_129 _ = happyReduce_41

action_130 (30) = happyShift action_72
action_130 (36) = happyShift action_73
action_130 (47) = happyShift action_74
action_130 (52) = happyShift action_75
action_130 (67) = happyShift action_76
action_130 (68) = happyShift action_77
action_130 (69) = happyShift action_78
action_130 (70) = happyShift action_79
action_130 (71) = happyShift action_80
action_130 (72) = happyShift action_81
action_130 (73) = happyShift action_82
action_130 (74) = happyShift action_83
action_130 (75) = happyShift action_84
action_130 (76) = happyShift action_85
action_130 (77) = happyShift action_86
action_130 (29) = happyGoto action_136
action_130 _ = happyReduce_90

action_131 (83) = happyShift action_135
action_131 _ = happyFail

action_132 _ = happyReduce_65

action_133 _ = happyReduce_59

action_134 _ = happyReduce_7

action_135 _ = happyReduce_86

action_136 (85) = happyShift action_166
action_136 _ = happyReduce_88

action_137 _ = happyReduce_40

action_138 _ = happyReduce_48

action_139 (38) = happyShift action_165
action_139 (21) = happyGoto action_164
action_139 _ = happyReduce_47

action_140 _ = happyReduce_57

action_141 _ = happyReduce_33

action_142 (84) = happyShift action_163
action_142 _ = happyFail

action_143 _ = happyReduce_13

action_144 (10) = happyGoto action_162
action_144 _ = happyReduce_14

action_145 (60) = happyShift action_101
action_145 (14) = happyGoto action_161
action_145 (15) = happyGoto action_100
action_145 _ = happyReduce_22

action_146 _ = happyReduce_15

action_147 _ = happyReduce_11

action_148 (80) = happyShift action_160
action_148 _ = happyFail

action_149 (86) = happyShift action_159
action_149 (17) = happyGoto action_158
action_149 _ = happyReduce_31

action_150 _ = happyReduce_26

action_151 _ = happyReduce_27

action_152 _ = happyReduce_24

action_153 _ = happyReduce_25

action_154 (31) = happyShift action_149
action_154 (33) = happyShift action_150
action_154 (34) = happyShift action_151
action_154 (45) = happyShift action_152
action_154 (55) = happyShift action_153
action_154 (77) = happyShift action_154
action_154 (16) = happyGoto action_157
action_154 _ = happyFail

action_155 (31) = happyShift action_149
action_155 (33) = happyShift action_150
action_155 (34) = happyShift action_151
action_155 (45) = happyShift action_152
action_155 (55) = happyShift action_153
action_155 (77) = happyShift action_154
action_155 (16) = happyGoto action_156
action_155 _ = happyFail

action_156 (80) = happyShift action_173
action_156 _ = happyFail

action_157 _ = happyReduce_29

action_158 (51) = happyShift action_172
action_158 _ = happyFail

action_159 (63) = happyShift action_171
action_159 _ = happyFail

action_160 _ = happyReduce_10

action_161 _ = happyReduce_19

action_162 (84) = happyShift action_170
action_162 (85) = happyShift action_103
action_162 _ = happyFail

action_163 (31) = happyShift action_149
action_163 (33) = happyShift action_150
action_163 (34) = happyShift action_151
action_163 (45) = happyShift action_152
action_163 (55) = happyShift action_153
action_163 (77) = happyShift action_154
action_163 (16) = happyGoto action_169
action_163 _ = happyFail

action_164 _ = happyReduce_39

action_165 (32) = happyShift action_11
action_165 (35) = happyShift action_30
action_165 (40) = happyShift action_31
action_165 (43) = happyShift action_32
action_165 (44) = happyShift action_33
action_165 (48) = happyShift action_34
action_165 (49) = happyShift action_35
action_165 (50) = happyShift action_36
action_165 (56) = happyShift action_37
action_165 (57) = happyShift action_38
action_165 (59) = happyShift action_39
action_165 (61) = happyShift action_40
action_165 (62) = happyShift action_41
action_165 (63) = happyShift action_42
action_165 (64) = happyShift action_43
action_165 (65) = happyShift action_44
action_165 (66) = happyShift action_45
action_165 (73) = happyShift action_46
action_165 (74) = happyShift action_47
action_165 (78) = happyShift action_48
action_165 (82) = happyShift action_49
action_165 (18) = happyGoto action_24
action_165 (20) = happyGoto action_168
action_165 (24) = happyGoto action_26
action_165 (25) = happyGoto action_27
action_165 (26) = happyGoto action_28
action_165 (27) = happyGoto action_29
action_165 _ = happyReduce_35

action_166 (40) = happyShift action_31
action_166 (49) = happyShift action_35
action_166 (50) = happyShift action_36
action_166 (56) = happyShift action_37
action_166 (59) = happyShift action_39
action_166 (62) = happyShift action_55
action_166 (63) = happyShift action_42
action_166 (64) = happyShift action_43
action_166 (65) = happyShift action_44
action_166 (66) = happyShift action_45
action_166 (73) = happyShift action_46
action_166 (74) = happyShift action_47
action_166 (78) = happyShift action_48
action_166 (82) = happyShift action_49
action_166 (24) = happyGoto action_167
action_166 (25) = happyGoto action_58
action_166 (26) = happyGoto action_28
action_166 (27) = happyGoto action_54
action_166 _ = happyFail

action_167 (30) = happyShift action_72
action_167 (36) = happyShift action_73
action_167 (47) = happyShift action_74
action_167 (52) = happyShift action_75
action_167 (67) = happyShift action_76
action_167 (68) = happyShift action_77
action_167 (69) = happyShift action_78
action_167 (70) = happyShift action_79
action_167 (71) = happyShift action_80
action_167 (72) = happyShift action_81
action_167 (73) = happyShift action_82
action_167 (74) = happyShift action_83
action_167 (75) = happyShift action_84
action_167 (76) = happyShift action_85
action_167 (77) = happyShift action_86
action_167 _ = happyReduce_89

action_168 _ = happyReduce_46

action_169 _ = happyReduce_16

action_170 (31) = happyShift action_149
action_170 (33) = happyShift action_150
action_170 (34) = happyShift action_151
action_170 (45) = happyShift action_152
action_170 (55) = happyShift action_153
action_170 (77) = happyShift action_154
action_170 (16) = happyGoto action_176
action_170 _ = happyFail

action_171 (87) = happyShift action_175
action_171 _ = happyFail

action_172 (31) = happyShift action_149
action_172 (33) = happyShift action_150
action_172 (34) = happyShift action_151
action_172 (45) = happyShift action_152
action_172 (55) = happyShift action_153
action_172 (77) = happyShift action_154
action_172 (16) = happyGoto action_174
action_172 _ = happyFail

action_173 _ = happyReduce_9

action_174 _ = happyReduce_28

action_175 _ = happyReduce_30

action_176 _ = happyReduce_21

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
		 (RInt     happy_var_1
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
		 (RReal    happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  26 happyReduction_64
happyReduction_64 (HappyTerminal (TCharconst happy_var_1))
	 =  HappyAbsSyn26
		 (RChar    happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  26 happyReduction_65
happyReduction_65 _
	(HappyAbsSyn26  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RParen   happy_var_2
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
		 (RCall    happy_var_1
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_2  26 happyReduction_68
happyReduction_68 (HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RPapaki  happy_var_2
	)
happyReduction_68 _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_2  26 happyReduction_69
happyReduction_69 (HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RNot     happy_var_2
	)
happyReduction_69 _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_2  26 happyReduction_70
happyReduction_70 (HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RPos     happy_var_2
	)
happyReduction_70 _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_2  26 happyReduction_71
happyReduction_71 (HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn26
		 (RNeg     happy_var_2
	)
happyReduction_71 _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  26 happyReduction_72
happyReduction_72 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RPlus    happy_var_1 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  26 happyReduction_73
happyReduction_73 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RMul     happy_var_1 happy_var_3
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_3  26 happyReduction_74
happyReduction_74 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RMinus   happy_var_1 happy_var_3
	)
happyReduction_74 _ _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_3  26 happyReduction_75
happyReduction_75 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RRealDiv happy_var_1 happy_var_3
	)
happyReduction_75 _ _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  26 happyReduction_76
happyReduction_76 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RDiv     happy_var_1 happy_var_3
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_3  26 happyReduction_77
happyReduction_77 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RMod     happy_var_1 happy_var_3
	)
happyReduction_77 _ _ _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  26 happyReduction_78
happyReduction_78 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (ROr      happy_var_1 happy_var_3
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  26 happyReduction_79
happyReduction_79 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RAnd     happy_var_1 happy_var_3
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_3  26 happyReduction_80
happyReduction_80 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (REq      happy_var_1 happy_var_3
	)
happyReduction_80 _ _ _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  26 happyReduction_81
happyReduction_81 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RDiff    happy_var_1 happy_var_3
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_3  26 happyReduction_82
happyReduction_82 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RLess    happy_var_1 happy_var_3
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_3  26 happyReduction_83
happyReduction_83 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RGreater happy_var_1 happy_var_3
	)
happyReduction_83 _ _ _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_3  26 happyReduction_84
happyReduction_84 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RGreq    happy_var_1 happy_var_3
	)
happyReduction_84 _ _ _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_3  26 happyReduction_85
happyReduction_85 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn26
		 (RSmeq    happy_var_1 happy_var_3
	)
happyReduction_85 _ _ _  = notHappyAtAll 

happyReduce_86 = happyReduce 4 27 happyReduction_86
happyReduction_86 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TId happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (CId happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_87 = happySpecReduce_0  28 happyReduction_87
happyReduction_87  =  HappyAbsSyn28
		 ([]
	)

happyReduce_88 = happySpecReduce_2  28 happyReduction_88
happyReduction_88 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 : happy_var_2
	)
happyReduction_88 _ _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_3  29 happyReduction_89
happyReduction_89 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_3 : happy_var_1
	)
happyReduction_89 _ _ _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_0  29 happyReduction_90
happyReduction_90  =  HappyAbsSyn29
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
	TId happy_dollar_dollar -> cont 62;
	TIntconst happy_dollar_dollar -> cont 63;
	TRealconst happy_dollar_dollar -> cont 64;
	TCharconst happy_dollar_dollar -> cont 65;
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
  RInt Int           |
  RTrue              |
  RFalse             |
  RReal Double       |
  RChar Char         |
  RParen RValue      |
  RNil               |
  RCall Call         |
  RPapaki LValue     |
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

main = getContents >>= print . calc . alexScanTokens
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
