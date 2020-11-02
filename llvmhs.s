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
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	movl	$.L.realStr, %edi
	xorl	%eax, %eax
	callq	printf
	addq	$24, %rsp
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
	movq	(%rdi), %rdi
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
	movl	%edi, %r14d
	movq	(%rsi), %rbx
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
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	7(%rsp), %rsi
	movl	$.L.scanChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	movb	7(%rsp), %al
	popq	%rcx
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rsi
	movl	$.L.scanReal, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	fldt	(%rsp)
	addq	$24, %rsp
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
	.globl	fabs                    # -- Begin function fabs
	.p2align	4, 0x90
	.type	fabs,@function
fabs:                                   # @fabs
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	fabsl
	addq	$24, %rsp
	retq
.Lfunc_end11:
	.size	fabs, .Lfunc_end11-fabs
	.cfi_endproc
                                        # -- End function
	.globl	sqrt                    # -- Begin function sqrt
	.p2align	4, 0x90
	.type	sqrt,@function
sqrt:                                   # @sqrt
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	sqrtl
	addq	$24, %rsp
	retq
.Lfunc_end12:
	.size	sqrt, .Lfunc_end12-sqrt
	.cfi_endproc
                                        # -- End function
	.globl	sin                     # -- Begin function sin
	.p2align	4, 0x90
	.type	sin,@function
sin:                                    # @sin
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	sinl
	addq	$24, %rsp
	retq
.Lfunc_end13:
	.size	sin, .Lfunc_end13-sin
	.cfi_endproc
                                        # -- End function
	.globl	cos                     # -- Begin function cos
	.p2align	4, 0x90
	.type	cos,@function
cos:                                    # @cos
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	cosl
	addq	$24, %rsp
	retq
.Lfunc_end14:
	.size	cos, .Lfunc_end14-cos
	.cfi_endproc
                                        # -- End function
	.globl	tan                     # -- Begin function tan
	.p2align	4, 0x90
	.type	tan,@function
tan:                                    # @tan
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	tanl
	addq	$24, %rsp
	retq
.Lfunc_end15:
	.size	tan, .Lfunc_end15-tan
	.cfi_endproc
                                        # -- End function
	.globl	arctan                  # -- Begin function arctan
	.p2align	4, 0x90
	.type	arctan,@function
arctan:                                 # @arctan
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	atanl
	addq	$24, %rsp
	retq
.Lfunc_end16:
	.size	arctan, .Lfunc_end16-arctan
	.cfi_endproc
                                        # -- End function
	.globl	exp                     # -- Begin function exp
	.p2align	4, 0x90
	.type	exp,@function
exp:                                    # @exp
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	expl
	addq	$24, %rsp
	retq
.Lfunc_end17:
	.size	exp, .Lfunc_end17-exp
	.cfi_endproc
                                        # -- End function
	.globl	ln                      # -- Begin function ln
	.p2align	4, 0x90
	.type	ln,@function
ln:                                     # @ln
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fldt	32(%rsp)
	fstpt	(%rsp)
	callq	logl
	addq	$24, %rsp
	retq
.Lfunc_end18:
	.size	ln, .Lfunc_end18-ln
	.cfi_endproc
                                        # -- End function
	.globl	pi                      # -- Begin function pi
	.p2align	4, 0x90
	.type	pi,@function
pi:                                     # @pi
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	fld1
	fchs
	fstpt	(%rsp)
	callq	acosl
	addq	$24, %rsp
	retq
.Lfunc_end19:
	.size	pi, .Lfunc_end19-pi
	.cfi_endproc
                                        # -- End function
	.globl	trunc                   # -- Begin function trunc
	.p2align	4, 0x90
	.type	trunc,@function
trunc:                                  # @trunc
	.cfi_startproc
# %bb.0:                                # %entry
	fldt	8(%rsp)
	fnstcw	-6(%rsp)
	movzwl	-6(%rsp), %eax
	movw	$3199, -6(%rsp)         # imm = 0xC7F
	fldcw	-6(%rsp)
	movw	%ax, -6(%rsp)
	fistpl	-4(%rsp)
	fldcw	-6(%rsp)
	movl	-4(%rsp), %eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end20:
	.size	trunc, .Lfunc_end20-trunc
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2               # -- Begin function round
.LCPI21_0:
	.long	1056964608              # float 0.5
.LCPI21_1:
	.long	3204448256              # float -0.5
	.text
	.globl	round
	.p2align	4, 0x90
	.type	round,@function
round:                                  # @round
	.cfi_startproc
# %bb.0:                                # %entry
	fldt	8(%rsp)
	fnstcw	-10(%rsp)
	movzwl	-10(%rsp), %eax
	movw	$3199, -10(%rsp)        # imm = 0xC7F
	fldcw	-10(%rsp)
	movw	%ax, -10(%rsp)
	fistl	-4(%rsp)
	fldcw	-10(%rsp)
	movswl	-4(%rsp), %eax
	movl	%eax, -8(%rsp)
	fld	%st(0)
	fisubl	-8(%rsp)
	fldz
	fucompi	%st(2)
	fstp	%st(1)
	jbe	.LBB21_1
# %bb.3:                                # %neg
	flds	.LCPI21_1(%rip)
	fxch	%st(1)
	fucompi	%st(1)
	fstp	%st(0)
	ja	.LBB21_5
# %bb.4:                                # %negDown
	leal	-1(%rax), %eax
	jmp	.LBB21_5
.LBB21_1:                               # %pos
	flds	.LCPI21_0(%rip)
	fxch	%st(1)
	fucompi	%st(1)
	fstp	%st(0)
	jb	.LBB21_5
# %bb.2:                                # %posUp
	leal	1(%rax), %eax
                                        # kill: def %ax killed %ax killed %rax
	retq
.LBB21_5:                               # %exit
                                        # kill: def %ax killed %ax killed %rax
	retq
.Lfunc_end21:
	.size	round, .Lfunc_end21-round
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
.Lfunc_end22:
	.size	ord, .Lfunc_end22-ord
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
.Lfunc_end23:
	.size	chr, .Lfunc_end23-chr
	.cfi_endproc
                                        # -- End function
	.globl	ok                      # -- Begin function ok
	.p2align	4, 0x90
	.type	ok,@function
ok:                                     # @ok
	.cfi_startproc
# %bb.0:                                # %entry
	movzwl	(%rsi), %eax
	movw	%ax, -2(%rsp)
	retq
.Lfunc_end24:
	.size	ok, .Lfunc_end24-ok
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
	movw	$1, 6(%rsp)
	leaq	4(%rsp), %rdi
	leaq	6(%rsp), %rsi
	callq	ok
	movw	%ax, 4(%rsp)
	movzwl	4(%rsp), %edi
	callq	writeInteger
	popq	%rax
	retq
.Lfunc_end25:
	.size	main, .Lfunc_end25-main
	.cfi_endproc
                                        # -- End function
	.type	.LscanfChar,@object     # @scanfChar
	.section	.rodata.str1.1,"aMS",@progbits,1
.LscanfChar:
	.asciz	"%c"
	.size	.LscanfChar, 3

	.type	.L.intStr,@object       # @.intStr
.L.intStr:
	.asciz	"%hi"
	.size	.L.intStr, 4

	.type	.Ltrue,@object          # @true
.Ltrue:
	.asciz	"true"
	.size	.Ltrue, 5

	.type	.Lfalse,@object         # @false
.Lfalse:
	.asciz	"false"
	.size	.Lfalse, 6

	.type	.L.charStr,@object      # @.charStr
.L.charStr:
	.asciz	"%c"
	.size	.L.charStr, 3

	.type	.L.realStr,@object      # @.realStr
.L.realStr:
	.asciz	"%Lf"
	.size	.L.realStr, 4

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
	.asciz	"%Lf"
	.size	.L.scanReal, 4


	.section	".note.GNU-stack","",@progbits
