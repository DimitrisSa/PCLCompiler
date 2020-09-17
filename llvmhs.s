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
.Lfunc_end1:
	.size	writeChar, .Lfunc_end1-writeChar
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
.Lfunc_end2:
	.size	writeReal, .Lfunc_end2-writeReal
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
.Lfunc_end3:
	.size	writeString, .Lfunc_end3-writeString
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI4_0:
	.quad	4607182418800017408     # double 1
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movw	$1, 14(%rsp)
	movabsq	$4607182418800017408, %rax # imm = 0x3FF0000000000000
	movq	%rax, 16(%rsp)
	movb	$99, 13(%rsp)
	movsd	.LCPI4_0(%rip), %xmm0   # xmm0 = mem[0],zero
	callq	writeReal
	movzwl	14(%rsp), %edi
	callq	writeInteger
	movzbl	13(%rsp), %edi
	callq	writeChar
	addq	$24, %rsp
	retq
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
	.cfi_endproc
                                        # -- End function
	.type	.L.intStr,@object       # @.intStr
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.intStr:
	.asciz	"%d\n"
	.size	.L.intStr, 4

	.type	.L.charStr,@object      # @.charStr
.L.charStr:
	.asciz	"%c\n"
	.size	.L.charStr, 4

	.type	.L.realStr,@object      # @.realStr
.L.realStr:
	.asciz	"%f\n"
	.size	.L.realStr, 4


	.section	".note.GNU-stack","",@progbits
