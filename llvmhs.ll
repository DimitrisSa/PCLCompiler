; ModuleID = 'reverse'
source_filename = "<string>"

@scanfChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.intStr = private unnamed_addr constant [4 x i8] c"%hi\00", align 1
@true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.charStr = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.realStr = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.scanInt = private unnamed_addr constant [4 x i8] c"%hi\00", align 1
@scanfStr = private unnamed_addr constant [2 x i8] c"%s", align 1
@printStr = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@notBool = private unnamed_addr constant [20 x i8] c"Not a boolean value\00", align 1
@readBoolTrue = private unnamed_addr constant [5 x i8] c"true\00", align 1
@readBoolFalse = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.scanChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.scanReal = private unnamed_addr constant [4 x i8] c"%lf\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @__isoc99_scanf(i8*, ...)

declare double @acos(double)

declare double @atan(double)

declare double @log(double)

declare i32 @strcmp(i8*, i8*)

declare void @free(i8*)

declare i8* @malloc(i64)

define void @writeInteger(i16) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.intStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i16 %0)
  ret void
}

define void @writeBoolean(i1) {
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

define void @writeChar(i8) {
entry:
  %1 = getelementptr inbounds [3 x i8], [3 x i8]* @.charStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i8 %0)
  ret void
}

define void @writeReal(double) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.realStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, double %0)
  ret void
}

define void @writeString(i8*) {
entry:
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  ret void
}

define void @readString(i16, i8*) {
entry:
  %2 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %3 = load i8, i8* %1
  %4 = icmp eq i8 10, %3
  %5 = icmp eq i8 9, %3
  %6 = icmp eq i8 32, %3
  %7 = or i1 %4, %5
  %8 = or i1 %6, %7
  br i1 %8, label %while, label %while.exit1

while1:                                           ; preds = %while.exit1, %while2
  %9 = load i16, i16* %26
  %10 = getelementptr i8, i8* %1, i16 %9
  %11 = call i32 (i8*, ...) @__isoc99_scanf(i8* %2, i8* %10)
  %12 = load i8, i8* %10
  %13 = icmp ne i8 %12, 10
  br i1 %13, label %while2, label %while.exit

while2:                                           ; preds = %while1
  %14 = add i16 %9, 1
  store i16 %14, i16* %26
  %15 = icmp slt i16 %14, %27
  br i1 %15, label %while1, label %while.exit

while.exit:                                       ; preds = %while.exit1, %while2, %while1
  %16 = load i16, i16* %26
  %17 = getelementptr i8, i8* %1, i16 %16
  store i8 0, i8* %17
  ret void

while:                                            ; preds = %while, %entry
  %18 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %19 = call i32 (i8*, ...) @__isoc99_scanf(i8* %18, i8* %1)
  %20 = load i8, i8* %1
  %21 = icmp eq i8 10, %20
  %22 = icmp eq i8 9, %20
  %23 = icmp eq i8 32, %20
  %24 = or i1 %21, %22
  %25 = or i1 %23, %24
  br i1 %25, label %while, label %while.exit1

while.exit1:                                      ; preds = %while, %entry
  %26 = alloca i16
  store i16 0, i16* %26
  %27 = sub i16 %0, 1
  %28 = icmp slt i16 0, %27
  br i1 %28, label %while1, label %while.exit
}

define i16 @readInteger() {
entry:
  %0 = getelementptr inbounds [4 x i8], [4 x i8]* @.scanInt, i16 0, i16 0
  %1 = alloca i16
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i16* %1)
  %3 = load i16, i16* %1
  ret i16 %3
}

define i1 @readBoolean() {
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

define i8 @readChar() {
entry:
  %0 = getelementptr inbounds [3 x i8], [3 x i8]* @.scanChar, i16 0, i16 0
  %1 = alloca i8
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i8* %1)
  %3 = load i8, i8* %1
  ret i8 %3
}

define double @readReal() {
entry:
  %0 = getelementptr inbounds [4 x i8], [4 x i8]* @.scanReal, i16 0, i16 0
  %1 = alloca double
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, double* %1)
  %3 = load double, double* %1
  ret double %3
}

define i16 @abs(i16) {
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

declare double @fabs(double)

declare double @sqrt(double)

declare double @sin(double)

declare double @cos(double)

declare double @tan(double)

define double @arctan(double) {
entry:
  %1 = call double @atan(double %0)
  ret double %1
}

declare double @exp(double)

define double @ln(double) {
entry:
  %1 = call double @log(double %0)
  ret double %1
}

define double @pi() {
entry:
  %0 = call double @acos(double -1.000000e+00)
  ret double %0
}

define i16 @trunc(double) {
entry:
  %1 = fptosi double %0 to i16
  ret i16 %1
}

define i16 @round(double) {
entry:
  %1 = fptosi double %0 to i16
  %2 = sitofp i16 %1 to double
  %3 = fsub double %0, %2
  %4 = fcmp olt double %0, 0.000000e+00
  br i1 %4, label %neg, label %pos

pos:                                              ; preds = %entry
  %5 = fcmp oge double %3, 5.000000e-01
  br i1 %5, label %posUp, label %posDown

posUp:                                            ; preds = %pos
  %6 = add i16 %1, 1
  br label %exit

posDown:                                          ; preds = %pos
  %7 = add i16 %1, 0
  br label %exit

neg:                                              ; preds = %entry
  %8 = fcmp ogt double %3, -5.000000e-01
  br i1 %8, label %negUp, label %negDown

negUp:                                            ; preds = %neg
  %9 = add i16 %1, 0
  br label %exit

negDown:                                          ; preds = %neg
  %10 = add i16 %1, -1
  br label %exit

exit:                                             ; preds = %negDown, %negUp, %posDown, %posUp
  %11 = phi i16 [ %9, %negUp ], [ %10, %negDown ], [ %6, %posUp ], [ %7, %posDown ]
  ret i16 %11
}

define i16 @ord(i8) {
entry:
  %1 = zext i8 %0 to i16
  ret i16 %1
}

define i8 @chr(i16) {
entry:
  %1 = trunc i16 %0 to i8
  ret i8 %1
}

define i16 @strlen(i8*) {
entry:
  %1 = alloca i16
  store i16 0, i16* %1
  %2 = alloca i16
  %3 = load i16, i16* %2
  %4 = getelementptr i8, i8* %0, i16 %3
  %5 = load i8, i8* %4
  %6 = icmp ne i8 %5, 0
  br i1 %6, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %7 = alloca i16
  %8 = alloca i16
  %9 = load i16, i16* %8
  %10 = add i16 %9, 1
  store i16 %10, i16* %7
  %11 = alloca i16
  %12 = load i16, i16* %11
  %13 = getelementptr i8, i8* %0, i16 %12
  %14 = load i8, i8* %13
  %15 = icmp ne i8 %14, 0
  br i1 %15, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %16 = load i16, i16* %11
  ret i16 %16
}

define void @reverse(i8*, [32 x i8]*) {
entry:
  %2 = alloca i16
  %3 = alloca i16
  %4 = call i16 @strlen(i8* %0)
  store i16 %4, i16* %3
  store i16 0, i16* %2
  %5 = load i16, i16* %2
  %6 = load i16, i16* %3
  %7 = icmp slt i16 %5, %6
  br i1 %7, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %8 = load i16, i16* %2
  %9 = getelementptr inbounds [32 x i8], [32 x i8]* %1, i16 0, i16 %8
  %10 = load i16, i16* %3
  %11 = load i16, i16* %2
  %12 = sub i16 %10, %11
  %13 = sub i16 %12, 1
  %14 = getelementptr i8, i8* %0, i16 %13
  %15 = load i8, i8* %14
  store i8 %15, i8* %9
  %16 = load i16, i16* %2
  %17 = add i16 %16, 1
  store i16 %17, i16* %2
  %18 = load i16, i16* %2
  %19 = load i16, i16* %3
  %20 = icmp slt i16 %18, %19
  br i1 %20, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %21 = load i16, i16* %2
  %22 = getelementptr inbounds [32 x i8], [32 x i8]* %1, i16 0, i16 %21
  store i8 0, i8* %22
  ret void
}

define void @main() {
entry:
  %0 = alloca [32 x i8]
  %1 = alloca [14 x i8]
  %2 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 0
  store i8 10, i8* %2
  %3 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 1
  store i8 33, i8* %3
  %4 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 2
  store i8 100, i8* %4
  %5 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 3
  store i8 108, i8* %5
  %6 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 4
  store i8 114, i8* %6
  %7 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 5
  store i8 111, i8* %7
  %8 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 6
  store i8 119, i8* %8
  %9 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 7
  store i8 32, i8* %9
  %10 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 8
  store i8 111, i8* %10
  %11 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 9
  store i8 108, i8* %11
  %12 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 10
  store i8 108, i8* %12
  %13 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 11
  store i8 101, i8* %13
  %14 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 12
  store i8 72, i8* %14
  %15 = getelementptr [14 x i8], [14 x i8]* %1, i16 0, i16 13
  store i8 0, i8* %15
  %16 = getelementptr inbounds [14 x i8], [14 x i8]* %1, i16 0, i16 0
  %17 = getelementptr inbounds [32 x i8], [32 x i8]* %0, i16 0, i16 0
  call void @reverse(i8* %16, i8* %17)
  %18 = getelementptr inbounds [32 x i8], [32 x i8]* %0, i16 0, i16 0
  call void @writeString(i8* %18)
  ret void
}
