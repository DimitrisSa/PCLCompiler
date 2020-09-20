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
.Lfunc_end6:
	.size	readInteger, .Lfunc_end6-readInteger
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
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function pi
.LCPI9_0:
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
	movsd	.LCPI9_0(%rip), %xmm0   # xmm0 = mem[0],zero
	callq	acos
	popq	%rax
	retq
.Lfunc_end9:
	.size	pi, .Lfunc_end9-pi
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
.Lfunc_end10:
	.size	trunc, .Lfunc_end10-trunc
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function round
.LCPI11_0:
	.quad	4602678819172646912     # double 0.5
.LCPI11_1:
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
	jbe	.LBB11_1
# %bb.3:                                # %neg
	ucomisd	.LCPI11_1(%rip), %xmm0
	ja	.LBB11_5
# %bb.4:                                # %negDown
	decl	%eax
	jmp	.LBB11_5
.LBB11_1:                               # %pos
	ucomisd	.LCPI11_0(%rip), %xmm0
	jb	.LBB11_5
# %bb.2:                                # %posUp
	incl	%eax
                                        # kill: def %ax killed %ax killed %eax
	retq
.LBB11_5:                               # %exit
                                        # kill: def %ax killed %ax killed %eax
	retq
.Lfunc_end11:
	.size	round, .Lfunc_end11-round
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
.Lfunc_end12:
	.size	ord, .Lfunc_end12-ord
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
.Lfunc_end13:
	.size	chr, .Lfunc_end13-chr
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
	callq	readInteger
	movw	%ax, 6(%rsp)
	movzwl	6(%rsp), %edi
	callq	chr
	movb	%al, 5(%rsp)
	movzbl	5(%rsp), %edi
	callq	writeChar
	popq	%rax
	retq
.Lfunc_end14:
	.size	main, .Lfunc_end14-main
	.cfi_endproc
                                        # -- End function
	.type	.L.intStr,@object       # @.intStr
	.section	.rodata.str1.1,"aMS",@progbits,1
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

	.type	.LscanfChar,@object     # @scanfChar
.LscanfChar:
	.asciz	"%c"
	.size	.LscanfChar, 3

	.type	.L.scanInt,@object      # @.scanInt
.L.scanInt:
	.asciz	"%hi"
	.size	.L.scanInt, 4

	.type	.L.scanChar,@object     # @.scanChar
.L.scanChar:
	.asciz	"%c"
	.size	.L.scanChar, 3

	.type	.L.scanReal,@object     # @.scanReal
.L.scanReal:
	.asciz	"%lf"
	.size	.L.scanReal, 4


	.section	".note.GNU-stack","",@progbits
