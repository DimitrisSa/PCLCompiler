	.text
	.file	"<string>"
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
	popq	%rcx
	retq
.Lfunc_end0:
	.size	writeString, .Lfunc_end0-writeString
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movabsq	$8022916924116329800, %rax # imm = 0x6F57206F6C6C6548
	movq	%rax, 1(%rsp)
	movl	$543452274, 9(%rsp)     # imm = 0x20646C72
	movw	$28252, 13(%rsp)        # imm = 0x6E5C
	movb	$0, 15(%rsp)
	leaq	1(%rsp), %rdi
	movq	%rdi, 16(%rsp)
	xorl	%eax, %eax
	callq	writeString
	addq	$24, %rsp
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
