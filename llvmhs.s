	.text
	.file	"<string>"
	.globl	writeInteger            # -- Begin function writeInteger
	.p2align	4, 0x90
	.type	writeInteger,@function
writeInteger:                           # @writeInteger
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%edi, %ecx
	movl	$.L.intStr, %edi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	printf
	popq	%rax
	retq
.Lfunc_end0:
	.size	writeInteger, .Lfunc_end0-writeInteger
	.cfi_endproc
                                        # -- End function
	.globl	writeBoolean            # -- Begin function writeBoolean
	.p2align	4, 0x90
	.type	writeBoolean,@function
writeBoolean:                           # @writeBoolean
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	testb	$1, %dil
	je	.LBB1_2
# %bb.1:                                # %if.then
	movl	$.Ltrue, %edi
	jmp	.LBB1_3
.LBB1_2:                                # %if.else
	movl	$.Lfalse, %edi
.LBB1_3:                                # %if.exit
	xorl	%eax, %eax
	callq	printf
	popq	%rax
	retq
.Lfunc_end1:
	.size	writeBoolean, .Lfunc_end1-writeBoolean
	.cfi_endproc
                                        # -- End function
	.globl	writeChar               # -- Begin function writeChar
	.p2align	4, 0x90
	.type	writeChar,@function
writeChar:                              # @writeChar
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%edi, %ecx
	movl	$.L.charStr, %edi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	printf
	popq	%rax
	retq
.Lfunc_end2:
	.size	writeChar, .Lfunc_end2-writeChar
	.cfi_endproc
                                        # -- End function
	.globl	writeReal               # -- Begin function writeReal
	.p2align	4, 0x90
	.type	writeReal,@function
writeReal:                              # @writeReal
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$.L.realStr, %edi
	movb	$1, %al
	callq	printf
	popq	%rax
	retq
.Lfunc_end3:
	.size	writeReal, .Lfunc_end3-writeReal
	.cfi_endproc
                                        # -- End function
	.globl	writeString             # -- Begin function writeString
	.p2align	4, 0x90
	.type	writeString,@function
writeString:                            # @writeString
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	callq	printf
	popq	%rax
	retq
.Lfunc_end4:
	.size	writeString, .Lfunc_end4-writeString
	.cfi_endproc
                                        # -- End function
	.globl	readInteger             # -- Begin function readInteger
	.p2align	4, 0x90
	.type	readInteger,@function
readInteger:                            # @readInteger
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	leaq	12(%rsp), %rsi
	movl	$.L.scanInt, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movzwl	12(%rsp), %ebx
	leaq	15(%rsp), %rsi
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movl	%ebx, %eax
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end5:
	.size	readInteger, .Lfunc_end5-readInteger
	.cfi_endproc
                                        # -- End function
	.globl	readBoolean             # -- Begin function readBoolean
	.p2align	4, 0x90
	.type	readBoolean,@function
readBoolean:                            # @readBoolean
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -24
	jmp	.LBB6_1
	.p2align	4, 0x90
.LBB6_6:                                # %while.error
                                        #   in Loop: Header=BB6_1 Depth=1
	movl	$.LprintStr, %edi
	movl	$.LnotBool, %esi
	xorl	%eax, %eax
	callq	printf
.LBB6_1:                                # %while.true
                                        # =>This Inner Loop Header: Depth=1
	movq	%rsp, %rbx
	addq	$-112, %rbx
	movq	%rbx, %rsp
	movl	$.LscanfStr, %edi
	xorl	%eax, %eax
	movq	%rbx, %rsi
	callq	__isoc99_scanf
	movl	$.LreadBoolTrue, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	je	.LBB6_2
# %bb.3:                                # %while.false
                                        #   in Loop: Header=BB6_1 Depth=1
	movl	$.LreadBoolFalse, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	jne	.LBB6_6
# %bb.4:
	xorl	%eax, %eax
	jmp	.LBB6_5
.LBB6_2:
	movb	$1, %al
.LBB6_5:                                # %while.exit
                                        # kill: def %al killed %al killed %eax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end6:
	.size	readBoolean, .Lfunc_end6-readBoolean
	.cfi_endproc
                                        # -- End function
	.globl	readChar                # -- Begin function readChar
	.p2align	4, 0x90
	.type	readChar,@function
readChar:                               # @readChar
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	leaq	14(%rsp), %rsi
	movl	$.L.scanChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movb	14(%rsp), %bl
	leaq	15(%rsp), %rsi
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movl	%ebx, %eax
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end7:
	.size	readChar, .Lfunc_end7-readChar
	.cfi_endproc
                                        # -- End function
	.globl	readReal                # -- Begin function readReal
	.p2align	4, 0x90
	.type	readReal,@function
readReal:                               # @readReal
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	leaq	16(%rsp), %rsi
	movl	$.L.scanReal, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movsd	16(%rsp), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, 8(%rsp)          # 8-byte Spill
	leaq	7(%rsp), %rsi
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movsd	8(%rsp), %xmm0          # 8-byte Reload
                                        # xmm0 = mem[0],zero
	addq	$24, %rsp
	retq
.Lfunc_end8:
	.size	readReal, .Lfunc_end8-readReal
	.cfi_endproc
                                        # -- End function
	.globl	abs                     # -- Begin function abs
	.p2align	4, 0x90
	.type	abs,@function
abs:                                    # @abs
	.cfi_startproc
# %bb.0:                                # %entry
	testw	%di, %di
	jns	.LBB9_2
# %bb.1:                                # %neg
	negl	%edi
.LBB9_2:                                # %exit
	movl	%edi, %eax
	retq
.Lfunc_end9:
	.size	abs, .Lfunc_end9-abs
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function pi
.LCPI10_0:
	.quad	-4616189618054758400    # double -1
	.text
	.globl	pi
	.p2align	4, 0x90
	.type	pi,@function
pi:                                     # @pi
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movsd	.LCPI10_0(%rip), %xmm0  # xmm0 = mem[0],zero
	callq	acos
	popq	%rax
	retq
.Lfunc_end10:
	.size	pi, .Lfunc_end10-pi
	.cfi_endproc
                                        # -- End function
	.globl	trunc                   # -- Begin function trunc
	.p2align	4, 0x90
	.type	trunc,@function
trunc:                                  # @trunc
	.cfi_startproc
# %bb.0:                                # %entry
	cvttsd2si	%xmm0, %eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end11:
	.size	trunc, .Lfunc_end11-trunc
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function round
.LCPI12_0:
	.quad	4602678819172646912     # double 0.5
.LCPI12_1:
	.quad	-4620693217682128896    # double -0.5
	.text
	.globl	round
	.p2align	4, 0x90
	.type	round,@function
round:                                  # @round
	.cfi_startproc
# %bb.0:                                # %entry
	cvttsd2si	%xmm0, %eax
	movswl	%ax, %ecx
	cvtsi2sdl	%ecx, %xmm1
	xorps	%xmm2, %xmm2
	ucomisd	%xmm0, %xmm2
	subsd	%xmm1, %xmm0
	jbe	.LBB12_1
# %bb.3:                                # %neg
	ucomisd	.LCPI12_1(%rip), %xmm0
	ja	.LBB12_5
# %bb.4:                                # %negDown
	decl	%eax
	jmp	.LBB12_5
.LBB12_1:                               # %pos
	ucomisd	.LCPI12_0(%rip), %xmm0
	jb	.LBB12_5
# %bb.2:                                # %posUp
	incl	%eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.LBB12_5:                               # %exit
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end12:
	.size	round, .Lfunc_end12-round
	.cfi_endproc
                                        # -- End function
	.globl	ord                     # -- Begin function ord
	.p2align	4, 0x90
	.type	ord,@function
ord:                                    # @ord
	.cfi_startproc
# %bb.0:                                # %entry
	movzbl	%dil, %eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end13:
	.size	ord, .Lfunc_end13-ord
	.cfi_endproc
                                        # -- End function
	.globl	chr                     # -- Begin function chr
	.p2align	4, 0x90
	.type	chr,@function
chr:                                    # @chr
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	retq
.Lfunc_end14:
	.size	chr, .Lfunc_end14-chr
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movw	$2657, 5(%rsp)          # imm = 0xA61
	movb	$0, 7(%rsp)
	leaq	5(%rsp), %rdi
	xorl	%eax, %eax
	callq	writeString
	popq	%rax
	retq
.Lfunc_end15:
	.size	main, .Lfunc_end15-main
	.cfi_endproc
                                        # -- End function
	.type	.LscanfChar,@object     # @scanfChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LscanfChar:
	.asciz	"%c"
	.size	.LscanfChar, 3

	.type	.L.intStr,@object       # @.intStr
.L.intStr:
	.asciz	"%hi\n"
	.size	.L.intStr, 5

	.type	.Ltrue,@object          # @true
.Ltrue:
	.asciz	"true\n"
	.size	.Ltrue, 6

	.type	.Lfalse,@object         # @false
.Lfalse:
	.asciz	"false\n"
	.size	.Lfalse, 7

	.type	.L.charStr,@object      # @.charStr
.L.charStr:
	.asciz	"%c\n"
	.size	.L.charStr, 4

	.type	.L.realStr,@object      # @.realStr
.L.realStr:
	.asciz	"%lf\n"
	.size	.L.realStr, 5

	.type	.L.scanInt,@object      # @.scanInt
.L.scanInt:
	.asciz	"%hi"
	.size	.L.scanInt, 4

	.type	.LscanfStr,@object      # @scanfStr
	.section	.rodata,"a",@progbits
.LscanfStr:
	.ascii	"%s"
	.size	.LscanfStr, 2

	.type	.LprintStr,@object      # @printStr
	.section	.rodata.str1.1,"aMS",@progbits,1
.LprintStr:
	.asciz	"%s\n"
	.size	.LprintStr, 4

	.type	.LnotBool,@object       # @notBool
.LnotBool:
	.asciz	"Not a boolean value"
	.size	.LnotBool, 20

	.type	.LreadBoolTrue,@object  # @readBoolTrue
.LreadBoolTrue:
	.asciz	"true"
	.size	.LreadBoolTrue, 5

	.type	.LreadBoolFalse,@object # @readBoolFalse
.LreadBoolFalse:
	.asciz	"false"
	.size	.LreadBoolFalse, 6

	.type	.L.scanChar,@object     # @.scanChar
.L.scanChar:
	.asciz	"%c"
	.size	.L.scanChar, 3

	.type	.L.scanReal,@object     # @.scanReal
.L.scanReal:
	.asciz	"%lf"
	.size	.L.scanReal, 4


	.section	".note.GNU-stack","",@progbits
