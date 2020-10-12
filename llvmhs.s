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
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movl	%edi, %r14d
	jmp	.LBB5_1
	.p2align	4, 0x90
.LBB5_4:                                # %while
                                        #   in Loop: Header=BB5_1 Depth=1
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	movq	%r12, %rsi
	callq	__isoc99_scanf
.LBB5_1:                                # %entry
                                        # =>This Inner Loop Header: Depth=1
	movzbl	(%r12), %eax
	cmpb	$32, %al
	je	.LBB5_4
# %bb.2:                                # %entry
                                        #   in Loop: Header=BB5_1 Depth=1
	cmpb	$10, %al
	je	.LBB5_4
# %bb.3:                                # %entry
                                        #   in Loop: Header=BB5_1 Depth=1
	cmpb	$9, %al
	je	.LBB5_4
# %bb.5:                                # %while.exit1
	movq	%rsp, %rax
	leaq	-16(%rax), %r15
	movq	%r15, %rsp
	movw	$0, -16(%rax)
	decl	%r14d
	testw	%r14w, %r14w
	jle	.LBB5_8
	.p2align	4, 0x90
.LBB5_6:                                # %while1
                                        # =>This Inner Loop Header: Depth=1
	movswq	(%r15), %rbx
	leaq	(%r12,%rbx), %rsi
	movl	$.LscanfChar, %edi
	xorl	%eax, %eax
	callq	__isoc99_scanf
	cmpb	$10, (%r12,%rbx)
	je	.LBB5_8
# %bb.7:                                # %while2
                                        #   in Loop: Header=BB5_6 Depth=1
	incl	%ebx
	movw	%bx, (%r15)
	cmpw	%r14w, %bx
	jl	.LBB5_6
.LBB5_8:                                # %while.exit
	movswq	(%r15), %rax
	movb	$0, (%r12,%rax)
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
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
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI18_0:
	.quad	0                       # double 0
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
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$504, %rsp              # imm = 0x1F8
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movabsq	$2334391967770110279, %r14 # imm = 0x20656D2065766947
	movq	%r14, -306(%rbp)
	movabsq	$7450489176113311329, %rax # imm = 0x6765746E69206E61
	movq	%rax, -298(%rbp)
	movl	$540701285, -290(%rbp)  # imm = 0x203A7265
	movb	$0, -286(%rbp)
	leaq	-306(%rbp), %rdi
	callq	writeString
	callq	readInteger
	movw	%ax, -58(%rbp)
	movabsq	$8728102690886935880, %r12 # imm = 0x7920732765726548
	movq	%r12, -367(%rbp)
	movabsq	$7310589492924151151, %r13 # imm = 0x65746E692072756F
	movq	%r13, -359(%rbp)
	movl	$980575591, -351(%rbp)  # imm = 0x3A726567
	movw	$32, -347(%rbp)
	leaq	-367(%rbp), %rdi
	callq	writeString
	movzwl	-58(%rbp), %edi
	callq	writeInteger
	movw	$10, -104(%rbp)
	leaq	-104(%rbp), %rdi
	callq	writeString
	movabsq	$3107610355928556872, %rax # imm = 0x2B20732765726548
	movq	%rax, -210(%rbp)
	movabsq	$7955925892695292192, %rbx # imm = 0x6E692072756F7920
	movq	%rbx, -202(%rbp)
	movw	$25972, -194(%rbp)      # imm = 0x6574
	movl	$980575591, -192(%rbp)  # imm = 0x3A726567
	movw	$32, -188(%rbp)
	leaq	-210(%rbp), %rdi
	callq	writeString
	movzwl	-58(%rbp), %edi
	callq	writeInteger
	movw	$10, -102(%rbp)
	leaq	-102(%rbp), %rdi
	callq	writeString
	movabsq	$3251725544004412744, %rax # imm = 0x2D20732765726548
	movq	%rax, -186(%rbp)
	movq	%rbx, -178(%rbp)
	movw	$25972, -170(%rbp)      # imm = 0x6574
	movl	$980575591, -168(%rbp)  # imm = 0x3A726567
	movw	$32, -164(%rbp)
	leaq	-186(%rbp), %rdi
	callq	writeString
	movzwl	-58(%rbp), %edi
	negw	%di
	callq	writeInteger
	movw	$10, -100(%rbp)
	leaq	-100(%rbp), %rdi
	callq	writeString
	movq	%r12, -162(%rbp)
	movq	%r13, -154(%rbp)
	movw	$25959, -146(%rbp)      # imm = 0x6567
	movabsq	$8030870729827493746, %rax # imm = 0x6F73626120732772
	movq	%rax, -144(%rbp)
	movl	$1702131052, -136(%rbp) # imm = 0x6574756C
	movw	$30240, -132(%rbp)      # imm = 0x7620
	movl	$1702194273, -130(%rbp) # imm = 0x65756C61
	movw	$8250, -126(%rbp)       # imm = 0x203A
	movb	$0, -124(%rbp)
	leaq	-162(%rbp), %rdi
	callq	writeString
	movzwl	-58(%rbp), %edi
	callq	abs
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movw	$10, -98(%rbp)
	leaq	-98(%rbp), %rdi
	callq	writeString
	movq	%r12, -473(%rbp)
	movq	%r13, -465(%rbp)
	movw	$25959, -457(%rbp)      # imm = 0x6567
	movabsq	$7809634769682245490, %rax # imm = 0x6C61657220732772
	movq	%rax, -455(%rbp)
	movl	$1970365728, -447(%rbp) # imm = 0x75716520
	movw	$30313, -443(%rbp)      # imm = 0x7669
	movabsq	$9071470997498977, %rax # imm = 0x203A746E656C61
	movq	%rax, -441(%rbp)
	leaq	-473(%rbp), %rdi
	callq	writeString
	movswl	-58(%rbp), %eax
	cvtsi2sdl	%eax, %xmm0
	callq	writeReal
	movw	$10, -96(%rbp)
	leaq	-96(%rbp), %rdi
	callq	writeString
	movq	%r12, -413(%rbp)
	movq	%r13, -405(%rbp)
	movw	$25959, -397(%rbp)      # imm = 0x6567
	movabsq	$5279154727390750578, %rax # imm = 0x4943534120732772
	movq	%rax, -395(%rbp)
	movl	$1751326793, -387(%rbp) # imm = 0x68632049
	movw	$29281, -383(%rbp)      # imm = 0x7261
	movabsq	$7809653424151160096, %rax # imm = 0x6C61766975716520
	movq	%rax, -381(%rbp)
	movl	$980708965, -373(%rbp)  # imm = 0x3A746E65
	movw	$32, -369(%rbp)
	leaq	-413(%rbp), %rdi
	callq	writeString
	movzwl	-58(%rbp), %edi
	callq	chr
	movzbl	%al, %edi
	callq	writeChar
	movw	$10, -94(%rbp)
	leaq	-94(%rbp), %rdi
	callq	writeString
	leaq	-58(%rbp), %rax
	movq	%rax, -544(%rbp)
	movq	%r14, -433(%rbp)
	movabsq	$7018134820192657505, %rax # imm = 0x61656C6F6F622061
	movq	%rax, -425(%rbp)
	movl	$2112110, -417(%rbp)    # imm = 0x203A6E
	leaq	-433(%rbp), %rdi
	callq	writeString
	callq	readBoolean
	andb	$1, %al
	movb	%al, -62(%rbp)
	movq	%r12, -345(%rbp)
	movabsq	$7813586345752950127, %rax # imm = 0x6C6F6F622072756F
	movq	%rax, -337(%rbp)
	movl	$980312421, -329(%rbp)  # imm = 0x3A6E6165
	movw	$32, -325(%rbp)
	leaq	-345(%rbp), %rdi
	callq	writeString
	movzbl	-62(%rbp), %edi
	callq	writeBoolean
	movw	$10, -92(%rbp)
	leaq	-92(%rbp), %rdi
	callq	writeString
	movabsq	$7935469156469728584, %rax # imm = 0x6E20732765726548
	movq	%rax, -535(%rbp)
	movabsq	$2338060278192698479, %rax # imm = 0x2072756F7920746F
	movq	%rax, -527(%rbp)
	movw	$28514, -519(%rbp)      # imm = 0x6F62
	movabsq	$9071445009591407, %rax # imm = 0x203A6E61656C6F
	movq	%rax, -517(%rbp)
	leaq	-535(%rbp), %rdi
	callq	writeString
	movb	-62(%rbp), %al
	xorb	$1, %al
	movzbl	%al, %edi
	callq	writeBoolean
	movw	$10, -90(%rbp)
	leaq	-90(%rbp), %rdi
	callq	writeString
	movq	%r14, -323(%rbp)
	movabsq	$2322287723432517729, %rax # imm = 0x203A6C6165722061
	movq	%rax, -315(%rbp)
	movb	$0, -307(%rbp)
	leaq	-323(%rbp), %rdi
	callq	writeString
	callq	readReal
	movsd	%xmm0, -56(%rbp)
	movq	%r12, -123(%rbp)
	movabsq	$7809634769682199919, %r15 # imm = 0x6C6165722072756F
	movq	%r15, -115(%rbp)
	movw	$8250, -107(%rbp)       # imm = 0x203A
	movb	$0, -105(%rbp)
	leaq	-123(%rbp), %rdi
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	writeReal
	movw	$10, -88(%rbp)
	leaq	-88(%rbp), %rdi
	callq	writeString
	movabsq	$3107610355928556872, %rax # imm = 0x2B20732765726548
	movq	%rax, -285(%rbp)
	movabsq	$7309940821144336672, %r14 # imm = 0x65722072756F7920
	movq	%r14, -277(%rbp)
	movl	$540699745, -269(%rbp)  # imm = 0x203A6C61
	movb	$0, -265(%rbp)
	leaq	-285(%rbp), %rdi
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	writeReal
	movw	$10, -86(%rbp)
	leaq	-86(%rbp), %rdi
	callq	writeString
	movabsq	$3251725544004412744, %rax # imm = 0x2D20732765726548
	movq	%rax, -264(%rbp)
	movq	%r14, -256(%rbp)
	movl	$540699745, -248(%rbp)  # imm = 0x203A6C61
	movb	$0, -244(%rbp)
	leaq	-264(%rbp), %rdi
	callq	writeString
	xorpd	%xmm0, %xmm0
	subsd	-56(%rbp), %xmm0
	callq	writeReal
	movw	$10, -84(%rbp)
	leaq	-84(%rbp), %rdi
	callq	writeString
	movq	%r12, -509(%rbp)
	movq	%r15, -501(%rbp)
	movw	$29479, -493(%rbp)      # imm = 0x7327
	movabsq	$8391732706607784224, %rax # imm = 0x74756C6F73626120
	movq	%rax, -491(%rbp)
	movabsq	$4207898535199645797, %rax # imm = 0x3A65756C61762065
	movq	%rax, -483(%rbp)
	movw	$32, -475(%rbp)
	leaq	-509(%rbp), %rdi
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	fabs
	callq	writeReal
	movw	$10, -82(%rbp)
	leaq	-82(%rbp), %rdi
	callq	writeString
	movq	%r12, -243(%rbp)
	movq	%r15, %rbx
	movq	%r15, -235(%rbp)
	movw	$29479, -227(%rbp)      # imm = 0x7327
	movabsq	$2334397744769233696, %rax # imm = 0x2065726175717320
	movq	%rax, -225(%rbp)
	movl	$1953460082, -217(%rbp) # imm = 0x746F6F72
	movw	$8250, -213(%rbp)       # imm = 0x203A
	movb	$0, -211(%rbp)
	leaq	-243(%rbp), %rdi
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	ucomisd	.LCPI18_0, %xmm0
	jb	.LBB18_2
# %bb.1:
	sqrtsd	%xmm0, %xmm0
	jmp	.LBB18_3
.LBB18_2:                               # %call.sqrt
	callq	sqrt
.LBB18_3:                               # %entry.split
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29479, -16(%rax)       # imm = 0x7327
	movl	$1852404512, -14(%rax)  # imm = 0x6E697320
	movw	$8250, -10(%rax)        # imm = 0x203A
	movb	$0, -8(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	sin
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29479, -16(%rax)       # imm = 0x7327
	movl	$1936679712, -14(%rax)  # imm = 0x736F6320
	movw	$8250, -10(%rax)        # imm = 0x203A
	movb	$0, -8(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	cos
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29479, -16(%rax)       # imm = 0x7327
	movl	$1851880480, -14(%rax)  # imm = 0x6E617420
	movw	$8250, -10(%rax)        # imm = 0x203A
	movb	$0, -8(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	tan
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29479, -16(%rax)       # imm = 0x7327
	movabsq	$4210409854150533408, %rcx # imm = 0x3A6E617463726120
	movq	%rcx, -14(%rax)
	movw	$32, -6(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	arctan
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$7286950810128377160, %rcx # imm = 0x6520732765726548
	movq	%rcx, -32(%rax)
	movabsq	$2334102053248397856, %rcx # imm = 0x2064657369617220
	movq	%rcx, -24(%rax)
	movw	$28532, -16(%rax)       # imm = 0x6F74
	movq	%r14, -14(%rax)
	movl	$540699745, -6(%rax)    # imm = 0x203A6C61
	movb	$0, -2(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	exp
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movw	$29479, -32(%rax)       # imm = 0x7327
	movabsq	$7809649077626433056, %rcx # imm = 0x6C61727574616E20
	movq	%rcx, -30(%rax)
	movl	$1735355424, -22(%rax)  # imm = 0x676F6C20
	movw	$29281, -18(%rax)       # imm = 0x7261
	movl	$1835562089, -16(%rax)  # imm = 0x6D687469
	movw	$8250, -12(%rax)        # imm = 0x203A
	movb	$0, -10(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	ln
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$7310016643070193217, %rcx # imm = 0x6572656820646E41
	movq	%rcx, -32(%rax)
	movabsq	$2322205294599369511, %rcx # imm = 0x203A216970207327
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	pi
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29728, -16(%rax)       # imm = 0x7420
	movabsq	$7234316338069402994, %rcx # imm = 0x64657461636E7572
	movq	%rcx, -14(%rax)
	movw	$8250, -6(%rax)         # imm = 0x203A
	movb	$0, -4(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	trunc
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29216, -16(%rax)       # imm = 0x7220
	movabsq	$2322278944502347119, %rcx # imm = 0x203A6465646E756F
	movq	%rcx, -14(%rax)
	movb	$0, -6(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	callq	round
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$2334391967770110279, %rbx # imm = 0x20656D2065766947
	movq	%rbx, %r14
	movq	%r14, -32(%rax)
	movabsq	$2322294320551632993, %rcx # imm = 0x203A726168632061
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	readChar
	movb	%al, -61(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movabsq	$8241983568020141423, %rcx # imm = 0x726168632072756F
	movq	%rcx, -24(%rax)
	movq	%rcx, %rbx
	movw	$8250, -16(%rax)        # imm = 0x203A
	movb	$0, -14(%rax)
	callq	writeString
	movzbl	-61(%rbp), %edi
	callq	writeChar
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -32(%rax)
	movq	%rbx, -24(%rax)
	movw	$29479, -16(%rax)       # imm = 0x7327
	movabsq	$7142789588020576544, %rcx # imm = 0x6320494943534120
	movq	%rcx, -14(%rax)
	movl	$979723375, -6(%rax)    # imm = 0x3A65646F
	movw	$32, -2(%rax)
	callq	writeString
	movzbl	-61(%rbp), %edi
	callq	ord
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r14, -32(%rax)
	movabsq	$7450489176113311329, %r15 # imm = 0x6765746E69206E61
	movq	%r15, -24(%rax)
	movl	$540701285, -16(%rax)   # imm = 0x203A7265
	movb	$0, -12(%rax)
	callq	writeString
	callq	readInteger
	movw	%ax, -42(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r14, -32(%rax)
	movabsq	$2338042655863172705, %rcx # imm = 0x20726568746F6E61
	movq	%rcx, -24(%rax)
	movw	$28265, -16(%rax)       # imm = 0x6E69
	movabsq	$9071462256698740, %rcx # imm = 0x203A7265676574
	movq	%rcx, -14(%rax)
	callq	writeString
	callq	readInteger
	movw	%ax, -44(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620354674, %rcx # imm = 0x72756F79202B2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movabsq	$8243108378414311712, %r14 # imm = 0x72656765746E6920
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %edi
	addw	-44(%rbp), %di
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620289138, %rcx # imm = 0x72756F79202A2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %edi
	imulw	-44(%rbp), %di
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620485746, %rcx # imm = 0x72756F79202D2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %edi
	subw	-44(%rbp), %di
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620616818, %rcx # imm = 0x72756F79202F2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	cvtsi2sdl	%eax, %xmm0
	movswl	-44(%rbp), %eax
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8032487103338389618, %rcx # imm = 0x6F79207669642072
	movq	%rcx, -30(%rax)
	movl	$1864397429, -22(%rax)  # imm = 0x6F207275
	movw	$26740, -18(%rax)       # imm = 0x6874
	movabsq	$7450489176113312357, %rbx # imm = 0x6765746E69207265
	movq	%rbx, -16(%rax)
	movl	$540701285, -8(%rax)    # imm = 0x203A7265
	movb	$0, -4(%rax)
	callq	writeString
	movzwl	-42(%rbp), %eax
	cwtd
	idivw	-44(%rbp)
                                        # kill: def %ax killed %ax def %eax
	movl	%eax, %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8032487026130231410, %rcx # imm = 0x6F7920646F6D2072
	movq	%rcx, -30(%rax)
	movl	$1864397429, -22(%rax)  # imm = 0x6F207275
	movw	$26740, -18(%rax)       # imm = 0x6874
	movq	%rbx, -16(%rax)
	movl	$540701285, -8(%rax)    # imm = 0x203A7265
	movb	$0, -4(%rax)
	callq	writeString
	movzwl	-42(%rbp), %eax
	cwtd
	idivw	-44(%rbp)
                                        # kill: def %dx killed %dx def %edx
	movl	%edx, %edi
	callq	writeInteger
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621468786, %rcx # imm = 0x72756F79203C2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	setl	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621599858, %rcx # imm = 0x72756F79203E2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	setg	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404225716338, %rcx # imm = 0x756F79203D3C2072
	movq	%rcx, -30(%rax)
	movl	$1953439858, -22(%rax)  # imm = 0x746F2072
	movw	$25960, -18(%rax)       # imm = 0x6568
	movabsq	$7306920471174914162, %rbx # imm = 0x656765746E692072
	movq	%rbx, -16(%rax)
	movl	$2112114, -8(%rax)      # imm = 0x203A72
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	setle	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404225847410, %rcx # imm = 0x756F79203D3E2072
	movq	%rcx, -30(%rax)
	movl	$1953439858, -22(%rax)  # imm = 0x746F2072
	movw	$25960, -18(%rax)       # imm = 0x6568
	movq	%rbx, -16(%rax)
	movl	$2112114, -8(%rax)      # imm = 0x203A72
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	setge	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621534322, %rcx # imm = 0x72756F79203D2072
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movq	%r14, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	sete	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404242493554, %rcx # imm = 0x756F79203E3C2072
	movq	%rcx, -30(%rax)
	movl	$1953439858, -22(%rax)  # imm = 0x746F2072
	movw	$25960, -18(%rax)       # imm = 0x6568
	movq	%rbx, -16(%rax)
	movl	$2112114, -8(%rax)      # imm = 0x203A72
	callq	writeString
	movzwl	-42(%rbp), %eax
	xorl	%edi, %edi
	cmpw	-44(%rbp), %ax
	setne	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$2334391967770110279, %rbx # imm = 0x20656D2065766947
	movq	%rbx, -32(%rax)
	movq	%r15, -24(%rax)
	movl	$540701285, -16(%rax)   # imm = 0x203A7265
	movb	$0, -12(%rax)
	callq	writeString
	callq	readInteger
	movw	%ax, -42(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%rbx, -32(%rax)
	movq	%rbx, %r15
	movabsq	$2322287723432517729, %rcx # imm = 0x203A6C6165722061
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	readReal
	movsd	%xmm0, -56(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620354674, %rcx # imm = 0x72756F79202B2072
	movq	%rcx, -30(%rax)
	movabsq	$9071436419658272, %rbx # imm = 0x203A6C61657220
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	cvtsi2sdl	%eax, %xmm0
	addsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620289138, %rcx # imm = 0x72756F79202A2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	mulsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620485746, %rcx # imm = 0x72756F79202D2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	subsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858620616818, %rcx # imm = 0x72756F79202F2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621468786, %rcx # imm = 0x72756F79203C2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	cvtsi2sdl	%eax, %xmm1
	xorl	%edi, %edi
	ucomisd	%xmm1, %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621599858, %rcx # imm = 0x72756F79203E2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404225716338, %rcx # imm = 0x756F79203D3C2072
	movq	%rcx, -30(%rax)
	movabsq	$2322287723432517746, %r14 # imm = 0x203A6C6165722072
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	xorl	%edi, %edi
	ucomisd	%xmm1, %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404225847410, %rcx # imm = 0x756F79203D3E2072
	movq	%rcx, -30(%rax)
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8247620858621534322, %rcx # imm = 0x72756F79203D2072
	movq	%rcx, -30(%rax)
	movq	%rbx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	cmpeqsd	-56(%rbp), %xmm0
	movq	%xmm0, %rdi
	andl	$1, %edi
                                        # kill: def %edi killed %edi killed %rdi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$25959, -32(%rax)       # imm = 0x6567
	movabsq	$8462115404242493554, %rcx # imm = 0x756F79203E3C2072
	movq	%rcx, -30(%rax)
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	setne	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r15, %rbx
	movq	%rbx, -32(%rax)
	movabsq	$2322287723432517729, %rcx # imm = 0x203A6C6165722061
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	readReal
	movsd	%xmm0, -56(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%rbx, -32(%rax)
	movabsq	$7450489176113311329, %rcx # imm = 0x6765746E69206E61
	movq	%rcx, -24(%rax)
	movl	$540701285, -16(%rax)   # imm = 0x203A7265
	movb	$0, -12(%rax)
	callq	writeString
	callq	readInteger
	movw	%ax, -42(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movabsq	$7809634769682199919, %rbx # imm = 0x6C6165722072756F
	movq	%rbx, -40(%rax)
	movw	$11040, -32(%rax)       # imm = 0x2B20
	movabsq	$7955925892695292192, %r15 # imm = 0x6E692072756F7920
	movq	%r15, -30(%rax)
	movabsq	$9071462256698740, %r14 # imm = 0x203A7265676574
	movq	%r14, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	addsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movq	%rbx, %r13
	movw	$10784, -32(%rax)       # imm = 0x2A20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	mulsd	-56(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$11552, -32(%rax)       # imm = 0x2D20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	cvtsi2sdl	%eax, %xmm1
	subsd	%xmm1, %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$12064, -32(%rax)       # imm = 0x2F20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15904, -32(%rax)       # imm = 0x3E20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	xorl	%edi, %edi
	ucomisd	%xmm1, %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movabsq	$7575180421944123453, %rbx # imm = 0x692072756F79203D
	movq	%rbx, -30(%rax)
	movabsq	$2322294337714877550, %r14 # imm = 0x203A72656765746E
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15904, -32(%rax)       # imm = 0x3E20
	movq	%rbx, -30(%rax)
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movsd	-56(%rbp), %xmm0        # xmm0 = mem[0],zero
	movswl	-42(%rbp), %eax
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	xorl	%edi, %edi
	ucomisd	%xmm1, %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15648, -32(%rax)       # imm = 0x3D20
	movq	%r15, -30(%rax)
	movabsq	$9071462256698740, %rcx # imm = 0x203A7265676574
	movq	%rcx, -22(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	cmpeqsd	-56(%rbp), %xmm0
	movq	%xmm0, %rdi
	andl	$1, %edi
                                        # kill: def %edi killed %edi killed %rdi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movabsq	$7575180421944123454, %rcx # imm = 0x692072756F79203E
	movq	%rcx, -30(%rax)
	movq	%r14, -22(%rax)
	movb	$0, -14(%rax)
	callq	writeString
	movswl	-42(%rbp), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	xorl	%edi, %edi
	ucomisd	-56(%rbp), %xmm0
	setne	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$2334391967770110279, %rbx # imm = 0x20656D2065766947
	movq	%rbx, -32(%rax)
	movabsq	$2322287723432517729, %rcx # imm = 0x203A6C6165722061
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	readReal
	movsd	%xmm0, -80(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%rbx, -32(%rax)
	movabsq	$2338042655863172705, %rcx # imm = 0x20726568746F6E61
	movq	%rcx, -24(%rax)
	movw	$25970, -16(%rax)       # imm = 0x6572
	movl	$540699745, -14(%rax)   # imm = 0x203A6C61
	movb	$0, -10(%rax)
	callq	writeString
	callq	readReal
	movsd	%xmm0, -72(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$11040, -32(%rax)       # imm = 0x2B20
	movabsq	$8389960306783123744, %r15 # imm = 0x746F2072756F7920
	movq	%r15, -30(%rax)
	movabsq	$7809634769682195816, %r14 # imm = 0x6C61657220726568
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	addsd	-72(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$10784, -32(%rax)       # imm = 0x2A20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	mulsd	-72(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$11552, -32(%rax)       # imm = 0x2D20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	subsd	-72(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$12064, -32(%rax)       # imm = 0x2F20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	divsd	-72(%rbp), %xmm0
	callq	writeReal
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-72(%rbp), %xmm0        # xmm0 = mem[0],zero
	xorl	%edi, %edi
	ucomisd	-80(%rbp), %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15904, -32(%rax)       # imm = 0x3E20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	xorl	%edi, %edi
	ucomisd	-72(%rbp), %xmm0
	seta	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movabsq	$8007525986171691069, %rbx # imm = 0x6F2072756F79203D
	movq	%rbx, -30(%rax)
	movl	$1919248500, -22(%rax)  # imm = 0x72656874
	movw	$29216, -18(%rax)       # imm = 0x7220
	movl	$980181349, -16(%rax)   # imm = 0x3A6C6165
	movw	$32, -12(%rax)
	callq	writeString
	movsd	-72(%rbp), %xmm0        # xmm0 = mem[0],zero
	xorl	%edi, %edi
	ucomisd	-80(%rbp), %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15904, -32(%rax)       # imm = 0x3E20
	movq	%rbx, -30(%rax)
	movl	$1919248500, -22(%rax)  # imm = 0x72656874
	movw	$29216, -18(%rax)       # imm = 0x7220
	movl	$980181349, -16(%rax)   # imm = 0x3A6C6165
	movw	$32, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	xorl	%edi, %edi
	ucomisd	-72(%rbp), %xmm0
	setae	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15648, -32(%rax)       # imm = 0x3D20
	movq	%r15, -30(%rax)
	movq	%r14, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movsd	-72(%rbp), %xmm0        # xmm0 = mem[0],zero
	cmpeqsd	-80(%rbp), %xmm0
	movq	%xmm0, %rdi
	andl	$1, %edi
                                        # kill: def %edi killed %edi killed %rdi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%r13, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movabsq	$8007525986171691070, %rcx # imm = 0x6F2072756F79203E
	movq	%rcx, -30(%rax)
	movl	$1919248500, -22(%rax)  # imm = 0x72656874
	movw	$29216, -18(%rax)       # imm = 0x7220
	movl	$980181349, -16(%rax)   # imm = 0x3A6C6165
	movw	$32, -12(%rax)
	callq	writeString
	movsd	-80(%rbp), %xmm0        # xmm0 = mem[0],zero
	xorl	%edi, %edi
	ucomisd	-72(%rbp), %xmm0
	setne	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$2334391967770110279, %rbx # imm = 0x20656D2065766947
	movq	%rbx, -32(%rax)
	movabsq	$7018134820192657505, %rcx # imm = 0x61656C6F6F622061
	movq	%rcx, -24(%rax)
	movl	$2112110, -16(%rax)     # imm = 0x203A6E
	callq	writeString
	callq	readBoolean
	andb	$1, %al
	movb	%al, -46(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%rbx, -32(%rax)
	movabsq	$2338042655863172705, %r14 # imm = 0x20726568746F6E61
	movq	%r14, -24(%rax)
	movw	$28514, -16(%rax)       # imm = 0x6F62
	movabsq	$9071445009591407, %rcx # imm = 0x203A6E61656C6F
	movq	%rcx, -14(%rax)
	callq	writeString
	callq	readBoolean
	andb	$1, %al
	movb	%al, -45(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movabsq	$7813586345752950127, %rbx # imm = 0x6C6F6F622072756F
	movq	%rbx, -40(%rax)
	movw	$24933, -32(%rax)       # imm = 0x6165
	movabsq	$8032487026112667758, %rcx # imm = 0x6F7920646E61206E
	movq	%rcx, -30(%rax)
	movl	$1864397429, -22(%rax)  # imm = 0x6F207275
	movw	$26740, -18(%rax)       # imm = 0x6874
	movabsq	$7308338819493818981, %rcx # imm = 0x656C6F6F62207265
	movq	%rcx, -16(%rax)
	movl	$540700257, -8(%rax)    # imm = 0x203A6E61
	movb	$0, -4(%rax)
	callq	writeString
	movb	-45(%rbp), %al
	andb	-46(%rbp), %al
	movzbl	%al, %edi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movw	$24933, -32(%rax)       # imm = 0x6165
	movabsq	$8462115405118251118, %rcx # imm = 0x756F7920726F206E
	movq	%rcx, -30(%rax)
	movl	$1953439858, -22(%rax)  # imm = 0x746F2072
	movw	$25960, -18(%rax)       # imm = 0x6568
	movabsq	$7018134820192657522, %r13 # imm = 0x61656C6F6F622072
	movq	%r13, -16(%rax)
	movl	$2112110, -8(%rax)      # imm = 0x203A6E
	callq	writeString
	movb	-45(%rbp), %al
	orb	-46(%rbp), %al
	movzbl	%al, %edi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movw	$24933, -32(%rax)       # imm = 0x6165
	movabsq	$8247620858621534318, %rcx # imm = 0x72756F79203D206E
	movq	%rcx, -30(%rax)
	movl	$1752461088, -22(%rax)  # imm = 0x68746F20
	movw	$29285, -18(%rax)       # imm = 0x7265
	movabsq	$7953749933313450528, %rcx # imm = 0x6E61656C6F6F6220
	movq	%rcx, -16(%rax)
	movw	$8250, -8(%rax)         # imm = 0x203A
	movb	$0, -6(%rax)
	callq	writeString
	movb	-45(%rbp), %al
	xorb	-46(%rbp), %al
	xorb	$1, %al
	movzbl	%al, %edi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movw	$24933, -32(%rax)       # imm = 0x6165
	movabsq	$8462115404242493550, %rcx # imm = 0x756F79203E3C206E
	movq	%rcx, -30(%rax)
	movl	$1953439858, -22(%rax)  # imm = 0x746F2072
	movw	$25960, -18(%rax)       # imm = 0x6568
	movq	%r13, -16(%rax)
	movl	$2112110, -8(%rax)      # imm = 0x203A6E
	callq	writeString
	movb	-45(%rbp), %al
	xorb	-46(%rbp), %al
	movzbl	%al, %edi
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movabsq	$2334391967770110279, %rbx # imm = 0x20656D2065766947
	movq	%rbx, -32(%rax)
	movabsq	$2322294320551632993, %rcx # imm = 0x203A726168632061
	movq	%rcx, -24(%rax)
	movb	$0, -16(%rax)
	callq	writeString
	callq	readChar
	movb	%al, -60(%rbp)
	movq	%rsp, %rax
	leaq	-32(%rax), %rdi
	movq	%rdi, %rsp
	movq	%rbx, -32(%rax)
	movq	%r14, -24(%rax)
	movw	$26723, -16(%rax)       # imm = 0x6863
	movl	$540701281, -14(%rax)   # imm = 0x203A7261
	movb	$0, -10(%rax)
	callq	writeString
	callq	readChar
	movb	%al, -59(%rbp)
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movabsq	$8241983568020141423, %rbx # imm = 0x726168632072756F
	movq	%rbx, -40(%rax)
	movw	$15648, -32(%rax)       # imm = 0x3D20
	movq	%r15, -30(%rax)
	movabsq	$8241983568020137320, %rcx # imm = 0x7261686320726568
	movq	%rcx, -22(%rax)
	movw	$8250, -14(%rax)        # imm = 0x203A
	movb	$0, -12(%rax)
	callq	writeString
	movb	-60(%rbp), %al
	xorl	%edi, %edi
	cmpb	-59(%rbp), %al
	sete	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	movq	%rsp, %rax
	leaq	-48(%rax), %rdi
	movq	%rdi, %rsp
	movq	%r12, -48(%rax)
	movq	%rbx, -40(%rax)
	movw	$15392, -32(%rax)       # imm = 0x3C20
	movabsq	$8007525986171691070, %rcx # imm = 0x6F2072756F79203E
	movq	%rcx, -30(%rax)
	movl	$1919248500, -22(%rax)  # imm = 0x72656874
	movw	$25376, -18(%rax)       # imm = 0x6320
	movl	$980574568, -16(%rax)   # imm = 0x3A726168
	movw	$32, -12(%rax)
	callq	writeString
	movb	-60(%rbp), %al
	xorl	%edi, %edi
	cmpb	-59(%rbp), %al
	setne	%dil
	callq	writeBoolean
	movq	%rsp, %rax
	leaq	-16(%rax), %rdi
	movq	%rdi, %rsp
	movw	$10, -16(%rax)
	callq	writeString
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end18:
	.size	main, .Lfunc_end18-main
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
	.asciz	"%lf"
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
	.asciz	"%lf"
	.size	.L.scanReal, 4


	.section	".note.GNU-stack","",@progbits
