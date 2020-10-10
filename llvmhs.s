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
	.globl	readString              # -- Begin function readString
	.p2align	4, 0x90
	.type	readString,@function
readString:                             # @readString
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rbx
	movl	%edi, %r14d
	movw	$0, 14(%rsp)
	decl	%r14d
	testw	%r14w, %r14w
	jle	.LBB5_3
	.p2align	4, 0x90
.LBB5_1:                                # %while1
                                        # =>This Inner Loop Header: Depth=1
	movswq	14(%rsp), %rbp
	leaq	(%rbx,%rbp), %rsi
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	cmpb	$10, (%rbx,%rbp)
	je	.LBB5_3
# %bb.2:                                # %while2
                                        #   in Loop: Header=BB5_1 Depth=1
	incl	%ebp
	movw	%bp, 14(%rsp)
	cmpw	%r14w, %bp
	jl	.LBB5_1
.LBB5_3:                                # %while.exit
	movswq	14(%rsp), %rax
	movb	$0, (%rbx,%rax)
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
.Lfunc_end5:
	.size	readString, .Lfunc_end5-readString
	.cfi_endproc
                                        # -- End function
	.globl	readInteger             # -- Begin function readInteger
	.p2align	4, 0x90
	.type	readInteger,@function
readInteger:                            # @readInteger
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	6(%rsp), %rsi
	movl	$.L.scanInt, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movzwl	6(%rsp), %eax
	popq	%rcx
	retq
.Lfunc_end6:
	.size	readInteger, .Lfunc_end6-readInteger
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
	jmp	.LBB7_1
	.p2align	4, 0x90
.LBB7_6:                                # %while.error
                                        #   in Loop: Header=BB7_1 Depth=1
	movl	$.LprintStr, %edi
	movl	$.LnotBool, %esi
	xorl	%eax, %eax
	callq	printf
.LBB7_1:                                # %while.true
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
	je	.LBB7_2
# %bb.3:                                # %while.false
                                        #   in Loop: Header=BB7_1 Depth=1
	movl	$.LreadBoolFalse, %esi
	movq	%rbx, %rdi
	callq	strcmp
	testl	%eax, %eax
	jne	.LBB7_6
# %bb.4:
	xorl	%eax, %eax
	jmp	.LBB7_5
.LBB7_2:
	movb	$1, %al
.LBB7_5:                                # %while.exit
                                        # kill: def %al killed %al killed %eax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end7:
	.size	readBoolean, .Lfunc_end7-readBoolean
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
	leaq	15(%rsp), %rsi
	movl	$.L.scanChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	cmpb	$10, 15(%rsp)
	jne	.LBB8_3
# %bb.1:                                # %while.preheader
	leaq	15(%rsp), %rbx
	.p2align	4, 0x90
.LBB8_2:                                # %while
                                        # =>This Inner Loop Header: Depth=1
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	movq	%rbx, %rsi
	callq	__isoc99_scanf
	cmpb	$10, 15(%rsp)
	je	.LBB8_2
.LBB8_3:                                # %while.exit
	movb	15(%rsp), %al
	addq	$16, %rsp
	popq	%rbx
	retq
.Lfunc_end8:
	.size	readChar, .Lfunc_end8-readChar
	.cfi_endproc
                                        # -- End function
	.globl	readReal                # -- Begin function readReal
	.p2align	4, 0x90
	.type	readReal,@function
readReal:                               # @readReal
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsp, %rsi
	movl	$.L.scanReal, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movsd	(%rsp), %xmm0           # xmm0 = mem[0],zero
	popq	%rax
	retq
.Lfunc_end9:
	.size	readReal, .Lfunc_end9-readReal
	.cfi_endproc
                                        # -- End function
	.globl	abs                     # -- Begin function abs
	.p2align	4, 0x90
	.type	abs,@function
abs:                                    # @abs
	.cfi_startproc
# %bb.0:                                # %entry
	testw	%di, %di
	jns	.LBB10_2
# %bb.1:                                # %neg
	negl	%edi
.LBB10_2:                               # %exit
	movl	%edi, %eax
	retq
.Lfunc_end10:
	.size	abs, .Lfunc_end10-abs
	.cfi_endproc
                                        # -- End function
	.globl	arctan                  # -- Begin function arctan
	.p2align	4, 0x90
	.type	arctan,@function
arctan:                                 # @arctan
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	atan
	popq	%rax
	retq
.Lfunc_end11:
	.size	arctan, .Lfunc_end11-arctan
	.cfi_endproc
                                        # -- End function
	.globl	ln                      # -- Begin function ln
	.p2align	4, 0x90
	.type	ln,@function
ln:                                     # @ln
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	log
	popq	%rax
	retq
.Lfunc_end12:
	.size	ln, .Lfunc_end12-ln
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function pi
.LCPI13_0:
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
	movsd	.LCPI13_0(%rip), %xmm0  # xmm0 = mem[0],zero
	callq	acos
	popq	%rax
	retq
.Lfunc_end13:
	.size	pi, .Lfunc_end13-pi
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
.Lfunc_end14:
	.size	trunc, .Lfunc_end14-trunc
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function round
.LCPI15_0:
	.quad	4602678819172646912     # double 0.5
.LCPI15_1:
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
	jbe	.LBB15_1
# %bb.3:                                # %neg
	ucomisd	.LCPI15_1(%rip), %xmm0
	ja	.LBB15_5
# %bb.4:                                # %negDown
	decl	%eax
	jmp	.LBB15_5
.LBB15_1:                               # %pos
	ucomisd	.LCPI15_0(%rip), %xmm0
	jb	.LBB15_5
# %bb.2:                                # %posUp
	incl	%eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.LBB15_5:                               # %exit
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end15:
	.size	round, .Lfunc_end15-round
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
.Lfunc_end16:
	.size	ord, .Lfunc_end16-ord
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
.Lfunc_end17:
	.size	chr, .Lfunc_end17-chr
	.cfi_endproc
                                        # -- End function
	.globl	add1                    # -- Begin function add1
	.p2align	4, 0x90
	.type	add1,@function
add1:                                   # @add1
	.cfi_startproc
# %bb.0:                                # %entry
	movzwl	-2(%rsp), %eax
	incl	%eax
	movw	%ax, -4(%rsp)
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end18:
	.size	add1, .Lfunc_end18-add1
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$64, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movw	$0, -34(%rbp)
	movabsq	$2334391967770110279, %r14 # imm = 0x20656D2065766947
	movq	%r14, -67(%rbp)
	movabsq	$7450489176113311329, %rax # imm = 0x6765746E69206E61
	movq	%rax, -59(%rbp)
	movl	$540701285, -51(%rbp)   # imm = 0x203A7265
	movb	$0, -47(%rbp)
	leaq	-67(%rbp), %rdi
	callq	writeString
	movswl	-34(%rbp), %eax
	cmpl	$1, %eax
	jg	.LBB19_3
# %bb.1:                                # %while.preheader
	movabsq	$2338042655863172705, %r15 # imm = 0x20726568746F6E61
	movabsq	$9071462256698740, %r12 # imm = 0x203A7265676574
	.p2align	4, 0x90
.LBB19_2:                               # %while
                                        # =>This Inner Loop Header: Depth=1
	movswq	-34(%rbp), %rbx
	callq	readInteger
	movw	%ax, -46(%rbp,%rbx,2)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r14, -32(%rax)
	movq	%r15, -24(%rax)
	movw	$28265, -16(%rax)       # imm = 0x6E69
	movq	%r12, -14(%rax)
	callq	writeString
	movzwl	-34(%rbp), %eax
	incl	%eax
	movw	%ax, -34(%rbp)
	cwtl
	cmpl	$2, %eax
	jl	.LBB19_2
.LBB19_3:                               # %while.exit
	callq	readInteger
	movw	%ax, -42(%rbp)
	movw	$0, -34(%rbp)
	xorl	%eax, %eax
	testb	%al, %al
	jne	.LBB19_5
	.p2align	4, 0x90
.LBB19_4:                               # %while1
                                        # =>This Inner Loop Header: Depth=1
	movswq	-34(%rbp), %rax
	movzwl	-46(%rbp,%rax,2), %edi
	callq	writeInteger
	movswq	-34(%rbp), %rax
	movzwl	-46(%rbp,%rax,2), %edi
	callq	add1
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movzwl	-34(%rbp), %eax
	incl	%eax
	movw	%ax, -34(%rbp)
	cwtl
	cmpl	$3, %eax
	jl	.LBB19_4
.LBB19_5:                               # %while.exit1
	movq	%rsp, %rax
	leaq	-32(%rax), %rsp
	movq	%r14, -32(%rax)
	movabsq	$2338042655863172705, %rcx # imm = 0x20726568746F6E61
	movq	%rcx, -24(%rax)
	movw	$28265, -16(%rax)       # imm = 0x6E69
	movabsq	$9071462256698740, %rcx # imm = 0x203A7265676574
	movq	%rcx, -14(%rax)
	movzbl	-30(%rax), %edi
	callq	writeChar
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movw	$25960, -16(%rax)       # imm = 0x6568
	movb	$121, -14(%rax)
	movw	$10, -13(%rax)
	movl	-16(%rax), %eax
	movl	%eax, -39(%rbp)
	movb	$0, -35(%rbp)
	leaq	-37(%rbp), %rbx
	leaq	-39(%rbp), %rdi
	callq	writeString
	movq	%rbx, -80(%rbp)
	movzbl	-37(%rbp), %edi
	callq	writeChar
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end19:
	.size	main, .Lfunc_end19-main
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
