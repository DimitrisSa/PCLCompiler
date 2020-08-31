	.text
	.file	"<string>"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI0_0:
	.quad	4607182418800017408     # double 1
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movabsq	$4607182418800017408, %rax # imm = 0x3FF0000000000000
	movq	%rax, -32(%rsp)
	movabsq	$4611686018427387904, %rax # imm = 0x4000000000000000
	movq	%rax, -24(%rsp)
	movabsq	$4621819117588971520, %rax # imm = 0x4024000000000000
	movq	%rax, -16(%rsp)
	movabsq	$-4616189618054758400, %rax # imm = 0xBFF0000000000000
	movq	%rax, -8(%rsp)
	xorl	%eax, %eax
	testb	%al, %al
	jne	.LBB0_3
# %bb.1:                                # %while.preheader
	movsd	.LCPI0_0(%rip), %xmm0   # xmm0 = mem[0],zero
	xorps	%xmm1, %xmm1
	.p2align	4, 0x90
.LBB0_2:                                # %while
                                        # =>This Inner Loop Header: Depth=1
	movsd	-16(%rsp), %xmm2        # xmm2 = mem[0],zero
	addsd	-8(%rsp), %xmm2
	movsd	%xmm2, -16(%rsp)
	movsd	-24(%rsp), %xmm3        # xmm3 = mem[0],zero
	addsd	%xmm0, %xmm3
	movsd	%xmm3, -24(%rsp)
	movsd	-32(%rsp), %xmm3        # xmm3 = mem[0],zero
	addsd	%xmm0, %xmm3
	movsd	%xmm3, -32(%rsp)
	ucomisd	%xmm1, %xmm2
	ja	.LBB0_2
.LBB0_3:                                # %while.exit
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
