	.text
	.file	"<string>"
	.globl	writeReal               # -- Begin function writeReal
	.p2align	4, 0x90
	.type	writeReal,@function
writeReal:                              # @writeReal
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$.L.str, %edi
	movb	$1, %al
	callq	printf
	popq	%rax
	retq
.Lfunc_end0:
	.size	writeReal, .Lfunc_end0-writeReal
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
.Lfunc_end1:
	.size	writeString, .Lfunc_end1-writeString
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI2_0:
	.quad	4607182418800017408     # double 1
.LCPI2_1:
	.quad	4621819117588971520     # double 10
	.text
	.globl	main
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
	subq	$16, %rsp
	movq	$0, -8(%rbp)
	xorl	%eax, %eax
	testb	%al, %al
	jne	.LBB2_2
	.p2align	4, 0x90
.LBB2_1:                                # %while
                                        # =>This Inner Loop Header: Depth=1
	movsd	-8(%rbp), %xmm0         # xmm0 = mem[0],zero
	addsd	.LCPI2_0(%rip), %xmm0
	movsd	%xmm0, -8(%rbp)
	callq	writeReal
	movsd	.LCPI2_1(%rip), %xmm0   # xmm0 = mem[0],zero
	ucomisd	-8(%rbp), %xmm0
	ja	.LBB2_1
.LBB2_2:                                # %while.exit
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movq	%rsp, %rcx
	leaq	-16(%rcx), %rdi
	movq	%rdi, %rsp
	movabsq	$7309940765292982903, %rdx # imm = 0x65722065746F7277
	movq	%rdx, -16(%rcx)
	movl	$561212513, -8(%rcx)    # imm = 0x21736C61
	movw	$2593, -4(%rcx)         # imm = 0xA21
	movb	$0, -2(%rcx)
	movq	%rdi, -16(%rax)
	xorl	%eax, %eax
	callq	writeString
	movq	%rbp, %rsp
	popq	%rbp
	retq
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%f\n"
	.size	.L.str, 4


	.section	".note.GNU-stack","",@progbits
