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
	.globl	prime                   # -- Begin function prime
	.p2align	4, 0x90
	.type	prime,@function
prime:                                  # @prime
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
	movw	%di, -10(%rbp)
	testw	%di, %di
	js	.LBB18_1
# %bb.3:                                # %if.else
	movswl	-10(%rbp), %eax
	cmpl	$2, %eax
	jge	.LBB18_5
.LBB18_4:                               # %if.then1
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movb	$0, -16(%rax)
	jmp	.LBB18_2
.LBB18_1:                               # %if.then
	movq	%rsp, %rbx
	leaq	-16(%rbx), %rsp
	movzwl	-10(%rbp), %edi
	negw	%di
	callq	prime
	andb	$1, %al
	movb	%al, -16(%rbx)
	jmp	.LBB18_2
.LBB18_5:                               # %if.else1
	movzwl	-10(%rbp), %eax
	cmpl	$2, %eax
	jne	.LBB18_7
# %bb.6:                                # %if.then2
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movb	$1, -16(%rax)
	jmp	.LBB18_2
.LBB18_7:                               # %if.else2
	movzwl	-10(%rbp), %eax
	movl	%eax, %ecx
	shrl	$15, %ecx
	addl	%eax, %ecx
	andl	$65534, %ecx            # imm = 0xFFFE
	cmpw	%cx, %ax
	je	.LBB18_4
# %bb.8:                                # %if.else3
	movw	$3, -12(%rbp)
	movzwl	-10(%rbp), %eax
	movl	%eax, %ecx
	shrl	$15, %ecx
	addl	%eax, %ecx
	sarw	%cx
	movswl	%cx, %eax
	cmpl	$3, %eax
	jl	.LBB18_2
	.p2align	4, 0x90
.LBB18_9:                               # %while
                                        # =>This Inner Loop Header: Depth=1
	movzwl	-10(%rbp), %eax
	cwtd
	idivw	-12(%rbp)
	testw	%dx, %dx
	jne	.LBB18_11
# %bb.10:                               # %if.then4
                                        #   in Loop: Header=BB18_9 Depth=1
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movb	$0, -16(%rax)
.LBB18_11:                              # %if.exit4
                                        #   in Loop: Header=BB18_9 Depth=1
	movzwl	-12(%rbp), %eax
	addl	$2, %eax
	movw	%ax, -12(%rbp)
	movzwl	-10(%rbp), %ecx
	movl	%ecx, %edx
	shrl	$15, %edx
	addl	%ecx, %edx
	sarw	%dx
	cmpw	%dx, %ax
	jle	.LBB18_9
.LBB18_2:                               # %if.exit
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movb	$1, -16(%rax)
	movb	-16(%rax), %al
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end18:
	.size	prime, .Lfunc_end18-prime
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
	pushq	%r14
	pushq	%rbx
	subq	$80, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	movabsq	$2318339454418644048, %rax # imm = 0x202C657361656C50
	movq	%rax, -57(%rbp)
	movabsq	$7307218077898664295, %rax # imm = 0x6568742065766967
	movq	%rax, -49(%rbp)
	movw	$29984, -41(%rbp)       # imm = 0x7520
	movabsq	$7883951509302767728, %rax # imm = 0x6D696C2072657070
	movq	%rax, -39(%rbp)
	movl	$975205481, -31(%rbp)   # imm = 0x3A207469
	movw	$32, -27(%rbp)
	leaq	-57(%rbp), %rdi
	callq	writeString
	callq	readInteger
	movw	%ax, -20(%rbp)
	movabsq	$8461736369875153488, %rax # imm = 0x756E20656D697250
	movq	%rax, -86(%rbp)
	movabsq	$7305437225760940653, %rax # imm = 0x656220737265626D
	movq	%rax, -78(%rbp)
	movabsq	$2319389466615445364, %rax # imm = 0x2030206E65657774
	movq	%rax, -70(%rbp)
	movl	$543452769, -62(%rbp)   # imm = 0x20646E61
	movb	$0, -58(%rbp)
	leaq	-86(%rbp), %rdi
	callq	writeString
	movzwl	-20(%rbp), %edi
	callq	writeInteger
	movw	$2570, -25(%rbp)        # imm = 0xA0A
	movb	$0, -23(%rbp)
	leaq	-25(%rbp), %rdi
	callq	writeString
	movw	$0, -22(%rbp)
	movswl	-20(%rbp), %eax
	cmpl	$2, %eax
	jl	.LBB19_2
# %bb.1:                                # %if.then
	incw	-22(%rbp)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$2610, -16(%rax)        # imm = 0xA32
	movb	$0, -14(%rax)
	callq	writeString
.LBB19_2:                               # %if.exit
	movswl	-20(%rbp), %eax
	cmpl	$3, %eax
	jl	.LBB19_4
# %bb.3:                                # %if.then1
	incw	-22(%rbp)
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$2611, -16(%rax)        # imm = 0xA33
	movb	$0, -14(%rax)
	callq	writeString
.LBB19_4:                               # %if.exit1
	movw	$6, -18(%rbp)
	movswl	-20(%rbp), %eax
	cmpl	$6, %eax
	jl	.LBB19_11
	.p2align	4, 0x90
.LBB19_5:                               # %while
                                        # =>This Inner Loop Header: Depth=1
	movzwl	-18(%rbp), %edi
	decl	%edi
	callq	prime
	testb	$1, %al
	je	.LBB19_7
# %bb.6:                                # %if.then2
                                        #   in Loop: Header=BB19_5 Depth=1
	incw	-22(%rbp)
	movzwl	-18(%rbp), %edi
	decl	%edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
.LBB19_7:                               # %if.exit2
                                        #   in Loop: Header=BB19_5 Depth=1
	movzwl	-18(%rbp), %ebx
	movzwl	-20(%rbp), %r14d
	movl	%ebx, %edi
	incl	%edi
	callq	prime
	cmpw	%r14w, %bx
	je	.LBB19_10
# %bb.8:                                # %if.exit2
                                        #   in Loop: Header=BB19_5 Depth=1
	testb	$1, %al
	je	.LBB19_10
# %bb.9:                                # %if.then3
                                        #   in Loop: Header=BB19_5 Depth=1
	incw	-22(%rbp)
	movzwl	-18(%rbp), %edi
	incl	%edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
.LBB19_10:                              # %if.exit3
                                        #   in Loop: Header=BB19_5 Depth=1
	movzwl	-18(%rbp), %eax
	addl	$6, %eax
	movw	%ax, -18(%rbp)
	cmpw	-20(%rbp), %ax
	jle	.LBB19_5
.LBB19_11:                              # %while.exit
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movzwl	-22(%rbp), %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$7935454064021762080, %rcx # imm = 0x6E20656D69727020
	movq	%rcx, -32(%rax)
	movabsq	$2986775449669102965, %rcx # imm = 0x2973287265626D75
	movq	%rcx, -24(%rax)
	movw	$30496, -16(%rax)       # imm = 0x7720
	movabsq	$7959390400868086373, %rcx # imm = 0x6E756F6620657265
	movq	%rcx, -14(%rax)
	movl	$667236, -6(%rax)       # imm = 0xA2E64
	callq	writeString
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
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
