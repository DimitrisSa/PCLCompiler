; ModuleID = 'varFromParent'
source_filename = "<string>"

@scanfChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.intStr = private unnamed_addr constant [4 x i8] c"%hi\00", align 1
@true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.charStr = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.realStr = private unnamed_addr constant [4 x i8] c"%Lf\00", align 1
@.scanInt = private unnamed_addr constant [4 x i8] c"%hi\00", align 1
@scanfStr = private unnamed_addr constant [2 x i8] c"%s", align 1
@printStr = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@notBool = private unnamed_addr constant [20 x i8] c"Not a boolean value\00", align 1
@readBoolTrue = private unnamed_addr constant [5 x i8] c"true\00", align 1
@readBoolFalse = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.scanChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.scanReal = private unnamed_addr constant [4 x i8] c"%Lf\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @__isoc99_scanf(i8*, ...)

declare x86_fp80 @acosl(x86_fp80)

declare x86_fp80 @atanl(x86_fp80)

declare x86_fp80 @logl(x86_fp80)

declare x86_fp80 @fabsl(x86_fp80)

declare x86_fp80 @sqrtl(x86_fp80)

declare x86_fp80 @sinl(x86_fp80)

declare x86_fp80 @cosl(x86_fp80)

declare x86_fp80 @tanl(x86_fp80)

declare x86_fp80 @expl(x86_fp80)

declare i32 @strcmp(i8*, i8*)

declare void @free(i8*)

declare i8* @malloc(i64)

define void @writeInteger.(i16) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.intStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i16 %0)
  ret void
}

define void @writeBoolean.(i1) {
entry:
  br i1 %0, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %1 = getelementptr inbounds [5 x i8], [5 x i8]* @true, i16 0, i16 0
  br label %if.exit

if.else:                                          ; preds = %entry
  %2 = getelementptr inbounds [6 x i8], [6 x i8]* @false, i16 0, i16 0
  br label %if.exit

if.exit:                                          ; preds = %if.else, %if.then
  %3 = phi i8* [ %1, %if.then ], [ %2, %if.else ]
  %4 = call i32 (i8*, ...) @printf(i8* %3)
  ret void
}

define void @writeChar.(i8) {
entry:
  %1 = getelementptr inbounds [3 x i8], [3 x i8]* @.charStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i8 %0)
  ret void
}

define void @writeReal.(x86_fp80) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.realStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, x86_fp80 %0)
  ret void
}

define void @writeString.(i8**) {
entry:
  %1 = load i8*, i8** %0
  %2 = call i32 (i8*, ...) @printf(i8* %1)
  ret void
}

define void @readString.(i16, i8**) {
entry:
  %2 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %3 = load i8*, i8** %1
  %4 = alloca i16
  store i16 0, i16* %4
  %5 = sub i16 %0, 1
  %6 = icmp slt i16 0, %5
  br i1 %6, label %while1, label %while.exit

while1:                                           ; preds = %while2, %entry
  %7 = load i16, i16* %4
  %8 = getelementptr i8, i8* %3, i16 %7
  %9 = call i32 (i8*, ...) @__isoc99_scanf(i8* %2, i8* %8)
  %10 = load i8, i8* %8
  %11 = icmp ne i8 %10, 10
  br i1 %11, label %while2, label %while.exit

while2:                                           ; preds = %while1
  %12 = add i16 %7, 1
  store i16 %12, i16* %4
  %13 = icmp slt i16 %12, %5
  br i1 %13, label %while1, label %while.exit

while.exit:                                       ; preds = %while2, %while1, %entry
  %14 = load i16, i16* %4
  %15 = getelementptr i8, i8* %3, i16 %14
  store i8 0, i8* %15
  ret void
}

define i16 @readInteger.() {
entry:
  %0 = getelementptr inbounds [4 x i8], [4 x i8]* @.scanInt, i16 0, i16 0
  %1 = alloca i16
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i16* %1)
  %3 = load i16, i16* %1
  ret i16 %3
}

define i1 @readBoolean.() {
entry:
  %0 = getelementptr inbounds [2 x i8], [2 x i8]* @scanfStr, i16 0, i16 0
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @printStr, i16 0, i16 0
  %2 = getelementptr inbounds [20 x i8], [20 x i8]* @notBool, i16 0, i16 0
  %3 = getelementptr inbounds [5 x i8], [5 x i8]* @readBoolTrue, i16 0, i16 0
  %4 = getelementptr inbounds [6 x i8], [6 x i8]* @readBoolFalse, i16 0, i16 0
  br label %entry.

entry.:                                           ; preds = %while.error, %entry
  %5 = alloca i8, i16 100
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i8* %5)
  br label %while.true

while.true:                                       ; preds = %entry.
  %7 = call i32 @strcmp(i8* %5, i8* %3)
  %8 = icmp eq i32 %7, 0
  %9 = add i1 false, true
  br i1 %8, label %while.exit, label %while.false

while.false:                                      ; preds = %while.true
  %10 = call i32 @strcmp(i8* %5, i8* %4)
  %11 = icmp eq i32 %10, 0
  %12 = add i1 false, false
  br i1 %11, label %while.exit, label %while.error

while.error:                                      ; preds = %while.false
  %13 = call i32 (i8*, ...) @printf(i8* %1, i8* %2)
  br label %entry.

while.exit:                                       ; preds = %while.false, %while.true
  %14 = phi i1 [ %9, %while.true ], [ %12, %while.false ]
  ret i1 %14
}

define i8 @readChar.() {
entry:
  %0 = getelementptr inbounds [3 x i8], [3 x i8]* @.scanChar, i16 0, i16 0
  %1 = alloca i8
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i8* %1)
  %3 = load i8, i8* %1
  ret i8 %3
}

define x86_fp80 @readReal.() {
entry:
  %0 = getelementptr inbounds [4 x i8], [4 x i8]* @.scanReal, i16 0, i16 0
  %1 = alloca x86_fp80
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, x86_fp80* %1)
  %3 = load x86_fp80, x86_fp80* %1
  ret x86_fp80 %3
}

define i16 @abs.(i16) {
entry:
  %1 = icmp sge i16 %0, 0
  br i1 %1, label %pos, label %neg

pos:                                              ; preds = %entry
  %2 = add i16 %0, 0
  br label %exit

neg:                                              ; preds = %entry
  %3 = sub i16 0, %0
  br label %exit

exit:                                             ; preds = %neg, %pos
  %4 = phi i16 [ %2, %pos ], [ %3, %neg ]
  ret i16 %4
}

define x86_fp80 @fabs.(x86_fp80) {
entry:
  %1 = call x86_fp80 @fabsl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @sqrt.(x86_fp80) {
entry:
  %1 = call x86_fp80 @sqrtl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @sin.(x86_fp80) {
entry:
  %1 = call x86_fp80 @sinl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @cos.(x86_fp80) {
entry:
  %1 = call x86_fp80 @cosl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @tan.(x86_fp80) {
entry:
  %1 = call x86_fp80 @tanl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @arctan.(x86_fp80) {
entry:
  %1 = call x86_fp80 @atanl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @exp.(x86_fp80) {
entry:
  %1 = call x86_fp80 @expl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @ln.(x86_fp80) {
entry:
  %1 = call x86_fp80 @logl(x86_fp80 %0)
  ret x86_fp80 %1
}

define x86_fp80 @pi.() {
entry:
  %0 = fsub x86_fp80 0xK00000000000000000000, 0xK3FFF8000000000000000
  %1 = call x86_fp80 @acosl(x86_fp80 %0)
  ret x86_fp80 %1
}

define i16 @trunc.(x86_fp80) {
entry:
  %1 = fptosi x86_fp80 %0 to i16
  ret i16 %1
}

define i16 @round.(x86_fp80) {
entry:
  %1 = fptosi x86_fp80 %0 to i16
  %2 = sitofp i16 %1 to x86_fp80
  %3 = fsub x86_fp80 %0, %2
  %4 = fcmp olt x86_fp80 %0, 0xK00000000000000000000
  br i1 %4, label %neg, label %pos

pos:                                              ; preds = %entry
  %5 = fcmp oge x86_fp80 %3, 0xK3FFE8000000000000000
  br i1 %5, label %posUp, label %posDown

posUp:                                            ; preds = %pos
  %6 = add i16 %1, 1
  br label %exit

posDown:                                          ; preds = %pos
  %7 = add i16 %1, 0
  br label %exit

neg:                                              ; preds = %entry
  %8 = fsub x86_fp80 0xK00000000000000000000, 0xK3FFE8000000000000000
  %9 = fcmp ogt x86_fp80 %3, %8
  br i1 %9, label %negUp, label %negDown

negUp:                                            ; preds = %neg
  %10 = add i16 %1, 0
  br label %exit

negDown:                                          ; preds = %neg
  %11 = add i16 %1, -1
  br label %exit

exit:                                             ; preds = %negDown, %negUp, %posDown, %posUp
  %12 = phi i16 [ %10, %negUp ], [ %11, %negDown ], [ %6, %posUp ], [ %7, %posDown ]
  ret i16 %12
}

define i16 @ord.(i8) {
entry:
  %1 = zext i8 %0 to i16
  ret i16 %1
}

define i8 @chr.(i16) {
entry:
  %1 = trunc i16 %0 to i8
  ret i8 %1
}

define i16 @ok(i16*, i16*) {
entry:
  %2 = alloca i16
  %3 = load i16, i16* %1
  store i16 %3, i16* %2
  %4 = load i16, i16* %2
  ret i16 %4
}

define void @main() {
entry:
  %0 = alloca i16
  %1 = alloca i16
  store i16 1, i16* %1
  %2 = call i16 @ok(i16* %0, i16* %1)
  store i16 %2, i16* %0
  %3 = load i16, i16* %0
  call void @writeInteger.(i16 %3)
  ret void
}
