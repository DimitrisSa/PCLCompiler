; ModuleID = 'IfThenElse'
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

define void @main() {
entry:
  %0 = alloca i16
  %1 = alloca [68 x i8]
  %2 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 0
  store i8 71, i8* %2
  %3 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 1
  store i8 105, i8* %3
  %4 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 2
  store i8 118, i8* %4
  %5 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 3
  store i8 101, i8* %5
  %6 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 4
  store i8 32, i8* %6
  %7 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 5
  store i8 109, i8* %7
  %8 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 6
  store i8 101, i8* %8
  %9 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 7
  store i8 32, i8* %9
  %10 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 8
  store i8 97, i8* %10
  %11 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 9
  store i8 110, i8* %11
  %12 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 10
  store i8 32, i8* %12
  %13 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 11
  store i8 105, i8* %13
  %14 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 12
  store i8 110, i8* %14
  %15 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 13
  store i8 116, i8* %15
  %16 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 14
  store i8 101, i8* %16
  %17 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 15
  store i8 103, i8* %17
  %18 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 16
  store i8 101, i8* %18
  %19 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 17
  store i8 114, i8* %19
  %20 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 18
  store i8 32, i8* %20
  %21 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 19
  store i8 97, i8* %21
  %22 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 20
  store i8 110, i8* %22
  %23 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 21
  store i8 100, i8* %23
  %24 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 22
  store i8 32, i8* %24
  %25 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 23
  store i8 73, i8* %25
  %26 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 24
  store i8 39, i8* %26
  %27 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 25
  store i8 108, i8* %27
  %28 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 26
  store i8 108, i8* %28
  %29 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 27
  store i8 32, i8* %29
  %30 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 28
  store i8 116, i8* %30
  %31 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 29
  store i8 101, i8* %31
  %32 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 30
  store i8 108, i8* %32
  %33 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 31
  store i8 108, i8* %33
  %34 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 32
  store i8 32, i8* %34
  %35 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 33
  store i8 121, i8* %35
  %36 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 34
  store i8 111, i8* %36
  %37 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 35
  store i8 117, i8* %37
  %38 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 36
  store i8 32, i8* %38
  %39 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 37
  store i8 105, i8* %39
  %40 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 38
  store i8 102, i8* %40
  %41 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 39
  store i8 32, i8* %41
  %42 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 40
  store i8 105, i8* %42
  %43 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 41
  store i8 116, i8* %43
  %44 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 42
  store i8 39, i8* %44
  %45 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 43
  store i8 115, i8* %45
  %46 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 44
  store i8 32, i8* %46
  %47 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 45
  store i8 112, i8* %47
  %48 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 46
  store i8 111, i8* %48
  %49 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 47
  store i8 115, i8* %49
  %50 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 48
  store i8 105, i8* %50
  %51 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 49
  store i8 116, i8* %51
  %52 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 50
  store i8 105, i8* %52
  %53 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 51
  store i8 118, i8* %53
  %54 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 52
  store i8 101, i8* %54
  %55 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 53
  store i8 32, i8* %55
  %56 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 54
  store i8 111, i8* %56
  %57 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 55
  store i8 114, i8* %57
  %58 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 56
  store i8 32, i8* %58
  %59 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 57
  store i8 110, i8* %59
  %60 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 58
  store i8 101, i8* %60
  %61 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 59
  store i8 103, i8* %61
  %62 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 60
  store i8 97, i8* %62
  %63 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 61
  store i8 116, i8* %63
  %64 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 62
  store i8 105, i8* %64
  %65 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 63
  store i8 118, i8* %65
  %66 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 64
  store i8 101, i8* %66
  %67 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 65
  store i8 58, i8* %67
  %68 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 66
  store i8 32, i8* %68
  %69 = getelementptr [68 x i8], [68 x i8]* %1, i16 0, i16 67
  store i8 0, i8* %69
  %70 = getelementptr inbounds [68 x i8], [68 x i8]* %1, i16 0, i16 0
  call void @writeString(i8* %70)
  %71 = call i16 @readInteger()
  store i16 %71, i16* %0
  %72 = load i16, i16* %0
  %73 = icmp sge i16 %72, 0
  br i1 %73, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %74 = alloca [15 x i8]
  %75 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 0
  store i8 73, i8* %75
  %76 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 1
  store i8 116, i8* %76
  %77 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 2
  store i8 39, i8* %77
  %78 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 3
  store i8 115, i8* %78
  %79 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 4
  store i8 32, i8* %79
  %80 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 5
  store i8 112, i8* %80
  %81 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 6
  store i8 111, i8* %81
  %82 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 7
  store i8 115, i8* %82
  %83 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 8
  store i8 105, i8* %83
  %84 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 9
  store i8 116, i8* %84
  %85 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 10
  store i8 105, i8* %85
  %86 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 11
  store i8 118, i8* %86
  %87 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 12
  store i8 101, i8* %87
  %88 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 13
  store i8 10, i8* %88
  %89 = getelementptr [15 x i8], [15 x i8]* %74, i16 0, i16 14
  store i8 0, i8* %89
  %90 = getelementptr inbounds [15 x i8], [15 x i8]* %74, i16 0, i16 0
  call void @writeString(i8* %90)
  br label %if.exit

if.else:                                          ; preds = %entry
  %91 = alloca [15 x i8]
  %92 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 0
  store i8 73, i8* %92
  %93 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 1
  store i8 116, i8* %93
  %94 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 2
  store i8 39, i8* %94
  %95 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 3
  store i8 115, i8* %95
  %96 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 4
  store i8 32, i8* %96
  %97 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 5
  store i8 110, i8* %97
  %98 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 6
  store i8 101, i8* %98
  %99 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 7
  store i8 103, i8* %99
  %100 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 8
  store i8 97, i8* %100
  %101 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 9
  store i8 116, i8* %101
  %102 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 10
  store i8 105, i8* %102
  %103 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 11
  store i8 118, i8* %103
  %104 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 12
  store i8 101, i8* %104
  %105 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 13
  store i8 10, i8* %105
  %106 = getelementptr [15 x i8], [15 x i8]* %91, i16 0, i16 14
  store i8 0, i8* %106
  %107 = getelementptr inbounds [15 x i8], [15 x i8]* %91, i16 0, i16 0
  call void @writeString(i8* %107)
  br label %if.exit

if.exit:                                          ; preds = %if.else, %if.then
  ret void
}
