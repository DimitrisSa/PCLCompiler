; ModuleID = 'primes'
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

define void @writeString(i8**) {
entry:
  %1 = load i8*, i8** %0
  %2 = call i32 (i8*, ...) @printf(i8* %1)
  ret void
}

define void @readString(i16, i8**) {
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

define i1 @prime(i16) {
entry:
  %1 = alloca i16
  store i16 %0, i16* %1
  %2 = alloca i16
  %3 = load i16, i16* %1
  %4 = icmp slt i16 %3, 0
  br i1 %4, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %5 = alloca i1
  %6 = load i16, i16* %1
  %7 = sub i16 0, %6
  %8 = call i1 @prime(i16 %7)
  store i1 %8, i1* %5
  br label %if.exit

if.else:                                          ; preds = %entry
  %9 = load i16, i16* %1
  %10 = icmp slt i16 %9, 2
  br i1 %10, label %if.then1, label %if.else1

if.exit:                                          ; preds = %if.exit1, %if.then
  %11 = alloca i1
  store i1 true, i1* %11
  %12 = load i1, i1* %11
  ret i1 %12

if.then1:                                         ; preds = %if.else
  %13 = alloca i1
  store i1 false, i1* %13
  br label %if.exit1

if.else1:                                         ; preds = %if.else
  %14 = load i16, i16* %1
  %15 = icmp eq i16 %14, 2
  br i1 %15, label %if.then2, label %if.else2

if.exit1:                                         ; preds = %if.exit2, %if.then1
  br label %if.exit

if.then2:                                         ; preds = %if.else1
  %16 = alloca i1
  store i1 true, i1* %16
  br label %if.exit2

if.else2:                                         ; preds = %if.else1
  %17 = load i16, i16* %1
  %18 = srem i16 %17, 2
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %if.then3, label %if.else3

if.exit2:                                         ; preds = %if.exit3, %if.then2
  br label %if.exit1

if.then3:                                         ; preds = %if.else2
  %20 = alloca i1
  store i1 false, i1* %20
  br label %if.exit3

if.else3:                                         ; preds = %if.else2
  store i16 3, i16* %2
  %21 = load i16, i16* %2
  %22 = load i16, i16* %1
  %23 = sdiv i16 %22, 2
  %24 = icmp sle i16 %21, %23
  br i1 %24, label %while, label %while.exit

if.exit3:                                         ; preds = %while.exit, %if.then3
  br label %if.exit2

while:                                            ; preds = %if.exit4, %if.else3
  %25 = load i16, i16* %1
  %26 = load i16, i16* %2
  %27 = srem i16 %25, %26
  %28 = icmp eq i16 %27, 0
  br i1 %28, label %if.then4, label %if.exit4

while.exit:                                       ; preds = %if.exit4, %if.else3
  br label %if.exit3

if.then4:                                         ; preds = %while
  %29 = alloca i1
  store i1 false, i1* %29
  %30 = load i1, i1* %29
  br label %if.exit4

if.exit4:                                         ; preds = %if.then4, %while
  %31 = load i16, i16* %2
  %32 = add i16 %31, 2
  store i16 %32, i16* %2
  %33 = load i16, i16* %2
  %34 = load i16, i16* %1
  %35 = sdiv i16 %34, 2
  %36 = icmp sle i16 %33, %35
  br i1 %36, label %while, label %while.exit
}

define void @main() {
entry:
  %0 = alloca i16
  %1 = alloca i16
  %2 = alloca i16
  %3 = alloca [32 x i8]
  %4 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 0
  store i8 80, i8* %4
  %5 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 1
  store i8 108, i8* %5
  %6 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 2
  store i8 101, i8* %6
  %7 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 3
  store i8 97, i8* %7
  %8 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 4
  store i8 115, i8* %8
  %9 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 5
  store i8 101, i8* %9
  %10 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 6
  store i8 44, i8* %10
  %11 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 7
  store i8 32, i8* %11
  %12 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 8
  store i8 103, i8* %12
  %13 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 9
  store i8 105, i8* %13
  %14 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 10
  store i8 118, i8* %14
  %15 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 11
  store i8 101, i8* %15
  %16 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 12
  store i8 32, i8* %16
  %17 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 13
  store i8 116, i8* %17
  %18 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 14
  store i8 104, i8* %18
  %19 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 15
  store i8 101, i8* %19
  %20 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 16
  store i8 32, i8* %20
  %21 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 17
  store i8 117, i8* %21
  %22 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 18
  store i8 112, i8* %22
  %23 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 19
  store i8 112, i8* %23
  %24 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 20
  store i8 101, i8* %24
  %25 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 21
  store i8 114, i8* %25
  %26 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 22
  store i8 32, i8* %26
  %27 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 23
  store i8 108, i8* %27
  %28 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 24
  store i8 105, i8* %28
  %29 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 25
  store i8 109, i8* %29
  %30 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 26
  store i8 105, i8* %30
  %31 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 27
  store i8 116, i8* %31
  %32 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 28
  store i8 32, i8* %32
  %33 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 29
  store i8 58, i8* %33
  %34 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 30
  store i8 32, i8* %34
  %35 = getelementptr [32 x i8], [32 x i8]* %3, i16 0, i16 31
  store i8 0, i8* %35
  %36 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i16 0, i16 0
  %37 = alloca i8*
  store i8* %36, i8** %37
  call void @writeString(i8** %37)
  %38 = call i16 @readInteger()
  store i16 %38, i16* %0
  %39 = alloca [29 x i8]
  %40 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 0
  store i8 80, i8* %40
  %41 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 1
  store i8 114, i8* %41
  %42 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 2
  store i8 105, i8* %42
  %43 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 3
  store i8 109, i8* %43
  %44 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 4
  store i8 101, i8* %44
  %45 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 5
  store i8 32, i8* %45
  %46 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 6
  store i8 110, i8* %46
  %47 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 7
  store i8 117, i8* %47
  %48 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 8
  store i8 109, i8* %48
  %49 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 9
  store i8 98, i8* %49
  %50 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 10
  store i8 101, i8* %50
  %51 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 11
  store i8 114, i8* %51
  %52 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 12
  store i8 115, i8* %52
  %53 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 13
  store i8 32, i8* %53
  %54 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 14
  store i8 98, i8* %54
  %55 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 15
  store i8 101, i8* %55
  %56 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 16
  store i8 116, i8* %56
  %57 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 17
  store i8 119, i8* %57
  %58 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 18
  store i8 101, i8* %58
  %59 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 19
  store i8 101, i8* %59
  %60 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 20
  store i8 110, i8* %60
  %61 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 21
  store i8 32, i8* %61
  %62 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 22
  store i8 48, i8* %62
  %63 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 23
  store i8 32, i8* %63
  %64 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 24
  store i8 97, i8* %64
  %65 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 25
  store i8 110, i8* %65
  %66 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 26
  store i8 100, i8* %66
  %67 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 27
  store i8 32, i8* %67
  %68 = getelementptr [29 x i8], [29 x i8]* %39, i16 0, i16 28
  store i8 0, i8* %68
  %69 = getelementptr inbounds [29 x i8], [29 x i8]* %39, i16 0, i16 0
  %70 = alloca i8*
  store i8* %69, i8** %70
  call void @writeString(i8** %70)
  %71 = load i16, i16* %0
  call void @writeInteger(i16 %71)
  %72 = alloca [3 x i8]
  %73 = getelementptr [3 x i8], [3 x i8]* %72, i16 0, i16 0
  store i8 10, i8* %73
  %74 = getelementptr [3 x i8], [3 x i8]* %72, i16 0, i16 1
  store i8 10, i8* %74
  %75 = getelementptr [3 x i8], [3 x i8]* %72, i16 0, i16 2
  store i8 0, i8* %75
  %76 = getelementptr inbounds [3 x i8], [3 x i8]* %72, i16 0, i16 0
  %77 = alloca i8*
  store i8* %76, i8** %77
  call void @writeString(i8** %77)
  store i16 0, i16* %2
  %78 = load i16, i16* %0
  %79 = icmp sge i16 %78, 2
  br i1 %79, label %if.then, label %if.exit

if.then:                                          ; preds = %entry
  %80 = load i16, i16* %2
  %81 = add i16 %80, 1
  store i16 %81, i16* %2
  %82 = alloca [3 x i8]
  %83 = getelementptr [3 x i8], [3 x i8]* %82, i16 0, i16 0
  store i8 50, i8* %83
  %84 = getelementptr [3 x i8], [3 x i8]* %82, i16 0, i16 1
  store i8 10, i8* %84
  %85 = getelementptr [3 x i8], [3 x i8]* %82, i16 0, i16 2
  store i8 0, i8* %85
  %86 = getelementptr inbounds [3 x i8], [3 x i8]* %82, i16 0, i16 0
  %87 = alloca i8*
  store i8* %86, i8** %87
  call void @writeString(i8** %87)
  br label %if.exit

if.exit:                                          ; preds = %if.then, %entry
  %88 = load i16, i16* %0
  %89 = icmp sge i16 %88, 3
  br i1 %89, label %if.then1, label %if.exit1

if.then1:                                         ; preds = %if.exit
  %90 = load i16, i16* %2
  %91 = add i16 %90, 1
  store i16 %91, i16* %2
  %92 = alloca [3 x i8]
  %93 = getelementptr [3 x i8], [3 x i8]* %92, i16 0, i16 0
  store i8 51, i8* %93
  %94 = getelementptr [3 x i8], [3 x i8]* %92, i16 0, i16 1
  store i8 10, i8* %94
  %95 = getelementptr [3 x i8], [3 x i8]* %92, i16 0, i16 2
  store i8 0, i8* %95
  %96 = getelementptr inbounds [3 x i8], [3 x i8]* %92, i16 0, i16 0
  %97 = alloca i8*
  store i8* %96, i8** %97
  call void @writeString(i8** %97)
  br label %if.exit1

if.exit1:                                         ; preds = %if.then1, %if.exit
  store i16 6, i16* %1
  %98 = load i16, i16* %1
  %99 = load i16, i16* %0
  %100 = icmp sle i16 %98, %99
  br i1 %100, label %while, label %while.exit

while:                                            ; preds = %if.exit3, %if.exit1
  %101 = load i16, i16* %1
  %102 = sub i16 %101, 1
  %103 = call i1 @prime(i16 %102)
  br i1 %103, label %if.then2, label %if.exit2

while.exit:                                       ; preds = %if.exit3, %if.exit1
  %104 = alloca [2 x i8]
  %105 = getelementptr [2 x i8], [2 x i8]* %104, i16 0, i16 0
  store i8 10, i8* %105
  %106 = getelementptr [2 x i8], [2 x i8]* %104, i16 0, i16 1
  store i8 0, i8* %106
  %107 = getelementptr inbounds [2 x i8], [2 x i8]* %104, i16 0, i16 0
  %108 = alloca i8*
  store i8* %107, i8** %108
  call void @writeString(i8** %108)
  %109 = load i16, i16* %2
  call void @writeInteger(i16 %109)
  %110 = alloca [30 x i8]
  %111 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 0
  store i8 32, i8* %111
  %112 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 1
  store i8 112, i8* %112
  %113 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 2
  store i8 114, i8* %113
  %114 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 3
  store i8 105, i8* %114
  %115 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 4
  store i8 109, i8* %115
  %116 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 5
  store i8 101, i8* %116
  %117 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 6
  store i8 32, i8* %117
  %118 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 7
  store i8 110, i8* %118
  %119 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 8
  store i8 117, i8* %119
  %120 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 9
  store i8 109, i8* %120
  %121 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 10
  store i8 98, i8* %121
  %122 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 11
  store i8 101, i8* %122
  %123 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 12
  store i8 114, i8* %123
  %124 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 13
  store i8 40, i8* %124
  %125 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 14
  store i8 115, i8* %125
  %126 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 15
  store i8 41, i8* %126
  %127 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 16
  store i8 32, i8* %127
  %128 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 17
  store i8 119, i8* %128
  %129 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 18
  store i8 101, i8* %129
  %130 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 19
  store i8 114, i8* %130
  %131 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 20
  store i8 101, i8* %131
  %132 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 21
  store i8 32, i8* %132
  %133 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 22
  store i8 102, i8* %133
  %134 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 23
  store i8 111, i8* %134
  %135 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 24
  store i8 117, i8* %135
  %136 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 25
  store i8 110, i8* %136
  %137 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 26
  store i8 100, i8* %137
  %138 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 27
  store i8 46, i8* %138
  %139 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 28
  store i8 10, i8* %139
  %140 = getelementptr [30 x i8], [30 x i8]* %110, i16 0, i16 29
  store i8 0, i8* %140
  %141 = getelementptr inbounds [30 x i8], [30 x i8]* %110, i16 0, i16 0
  %142 = alloca i8*
  store i8* %141, i8** %142
  call void @writeString(i8** %142)
  ret void

if.then2:                                         ; preds = %while
  %143 = load i16, i16* %2
  %144 = add i16 %143, 1
  store i16 %144, i16* %2
  %145 = load i16, i16* %1
  %146 = sub i16 %145, 1
  call void @writeInteger(i16 %146)
  %147 = alloca [2 x i8]
  %148 = getelementptr [2 x i8], [2 x i8]* %147, i16 0, i16 0
  store i8 10, i8* %148
  %149 = getelementptr [2 x i8], [2 x i8]* %147, i16 0, i16 1
  store i8 0, i8* %149
  %150 = getelementptr inbounds [2 x i8], [2 x i8]* %147, i16 0, i16 0
  %151 = alloca i8*
  store i8* %150, i8** %151
  call void @writeString(i8** %151)
  br label %if.exit2

if.exit2:                                         ; preds = %if.then2, %while
  %152 = load i16, i16* %1
  %153 = load i16, i16* %0
  %154 = icmp ne i16 %152, %153
  %155 = load i16, i16* %1
  %156 = add i16 %155, 1
  %157 = call i1 @prime(i16 %156)
  %158 = and i1 %154, %157
  br i1 %158, label %if.then3, label %if.exit3

if.then3:                                         ; preds = %if.exit2
  %159 = load i16, i16* %2
  %160 = add i16 %159, 1
  store i16 %160, i16* %2
  %161 = load i16, i16* %1
  %162 = add i16 %161, 1
  call void @writeInteger(i16 %162)
  %163 = alloca [2 x i8]
  %164 = getelementptr [2 x i8], [2 x i8]* %163, i16 0, i16 0
  store i8 10, i8* %164
  %165 = getelementptr [2 x i8], [2 x i8]* %163, i16 0, i16 1
  store i8 0, i8* %165
  %166 = getelementptr inbounds [2 x i8], [2 x i8]* %163, i16 0, i16 0
  %167 = alloca i8*
  store i8* %166, i8** %167
  call void @writeString(i8** %167)
  br label %if.exit3

if.exit3:                                         ; preds = %if.then3, %if.exit2
  %168 = load i16, i16* %1
  %169 = add i16 %168, 6
  store i16 %169, i16* %1
  %170 = load i16, i16* %1
  %171 = load i16, i16* %0
  %172 = icmp sle i16 %170, %171
  br i1 %172, label %while, label %while.exit
}
