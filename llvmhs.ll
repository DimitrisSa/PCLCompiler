; ModuleID = 'LValues'
source_filename = "<string>"

@scanfChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.intStr = private unnamed_addr constant [5 x i8] c"%hi\0A\00", align 1
@true = private unnamed_addr constant [6 x i8] c"true\0A\00", align 1
@false = private unnamed_addr constant [7 x i8] c"false\0A\00", align 1
@.charStr = private unnamed_addr constant [4 x i8] c"%c\0A\00", align 1
@.realStr = private unnamed_addr constant [5 x i8] c"%lf\0A\00", align 1
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
  %1 = getelementptr inbounds [5 x i8], [5 x i8]* @.intStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i16 %0)
  ret void
}

define void @writeBoolean(i1) {
entry:
  br i1 %0, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %1 = getelementptr inbounds [6 x i8], [6 x i8]* @true, i16 0, i16 0
  br label %if.exit

if.else:                                          ; preds = %entry
  %2 = getelementptr inbounds [7 x i8], [7 x i8]* @false, i16 0, i16 0
  br label %if.exit

if.exit:                                          ; preds = %if.else, %if.then
  %3 = phi i8* [ %1, %if.then ], [ %2, %if.else ]
  %4 = call i32 (i8*, ...) @printf(i8* %3)
  ret void
}

define void @writeChar(i8) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.charStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i8 %0)
  ret void
}

define void @writeReal(double) {
entry:
  %1 = getelementptr inbounds [5 x i8], [5 x i8]* @.realStr, i16 0, i16 0
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
  %3 = alloca i16
  store i16 0, i16* %3
  %4 = sub i16 %0, 1
  %5 = icmp slt i16 0, %4
  br i1 %5, label %while1, label %while.exit

while1:                                           ; preds = %while2, %entry
  %6 = load i16, i16* %3
  %7 = getelementptr i8, i8* %1, i16 %6
  %8 = call i32 (i8*, ...) @__isoc99_scanf(i8* %2, i8* %7)
  %9 = load i8, i8* %7
  %10 = icmp ne i8 %9, 10
  br i1 %10, label %while2, label %while.exit

while2:                                           ; preds = %while1
  %11 = add i16 %6, 1
  store i16 %11, i16* %3
  %12 = icmp slt i16 %11, %4
  br i1 %12, label %while1, label %while.exit

while.exit:                                       ; preds = %while2, %while1, %entry
  %13 = load i16, i16* %3
  %14 = getelementptr i8, i8* %1, i16 %13
  store i8 0, i8* %14
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
  %4 = icmp eq i8 10, %3
  br i1 %4, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %5 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* %5, i8* %1)
  %7 = load i8, i8* %1
  %8 = icmp eq i8 10, %7
  br i1 %8, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %9 = load i8, i8* %1
  ret i8 %9
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

define i16 @add1(i16) {
entry:
  %1 = alloca i16
  %2 = alloca i16
  %3 = load i16, i16* %1
  %4 = add i16 %3, 1
  store i16 %4, i16* %2
  %5 = load i16, i16* %2
  ret i16 %5
}

define void @main() {
entry:
  %0 = alloca i16
  %1 = alloca [3 x i16]
  %2 = alloca i8
  %3 = alloca [5 x i8]
  %4 = alloca i8*
  store i16 0, i16* %0
  %5 = alloca [21 x i8]
  %6 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 0
  store i8 71, i8* %6
  %7 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 1
  store i8 105, i8* %7
  %8 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 2
  store i8 118, i8* %8
  %9 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 3
  store i8 101, i8* %9
  %10 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 4
  store i8 32, i8* %10
  %11 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 5
  store i8 109, i8* %11
  %12 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 6
  store i8 101, i8* %12
  %13 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 7
  store i8 32, i8* %13
  %14 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 8
  store i8 97, i8* %14
  %15 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 9
  store i8 110, i8* %15
  %16 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 10
  store i8 32, i8* %16
  %17 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 11
  store i8 105, i8* %17
  %18 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 12
  store i8 110, i8* %18
  %19 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 13
  store i8 116, i8* %19
  %20 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 14
  store i8 101, i8* %20
  %21 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 15
  store i8 103, i8* %21
  %22 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 16
  store i8 101, i8* %22
  %23 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 17
  store i8 114, i8* %23
  %24 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 18
  store i8 58, i8* %24
  %25 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 19
  store i8 32, i8* %25
  %26 = getelementptr [21 x i8], [21 x i8]* %5, i16 0, i16 20
  store i8 0, i8* %26
  %27 = getelementptr inbounds [21 x i8], [21 x i8]* %5, i16 0, i16 0
  call void @writeString(i8* %27)
  %28 = load i16, i16* %0
  %29 = icmp slt i16 %28, 2
  br i1 %29, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %30 = load i16, i16* %0
  %31 = getelementptr inbounds [3 x i16], [3 x i16]* %1, i16 0, i16 %30
  %32 = call i16 @readInteger()
  store i16 %32, i16* %31
  %33 = alloca [26 x i8]
  %34 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 0
  store i8 71, i8* %34
  %35 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 1
  store i8 105, i8* %35
  %36 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 2
  store i8 118, i8* %36
  %37 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 3
  store i8 101, i8* %37
  %38 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 4
  store i8 32, i8* %38
  %39 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 5
  store i8 109, i8* %39
  %40 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 6
  store i8 101, i8* %40
  %41 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 7
  store i8 32, i8* %41
  %42 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 8
  store i8 97, i8* %42
  %43 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 9
  store i8 110, i8* %43
  %44 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 10
  store i8 111, i8* %44
  %45 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 11
  store i8 116, i8* %45
  %46 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 12
  store i8 104, i8* %46
  %47 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 13
  store i8 101, i8* %47
  %48 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 14
  store i8 114, i8* %48
  %49 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 15
  store i8 32, i8* %49
  %50 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 16
  store i8 105, i8* %50
  %51 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 17
  store i8 110, i8* %51
  %52 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 18
  store i8 116, i8* %52
  %53 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 19
  store i8 101, i8* %53
  %54 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 20
  store i8 103, i8* %54
  %55 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 21
  store i8 101, i8* %55
  %56 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 22
  store i8 114, i8* %56
  %57 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 23
  store i8 58, i8* %57
  %58 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 24
  store i8 32, i8* %58
  %59 = getelementptr [26 x i8], [26 x i8]* %33, i16 0, i16 25
  store i8 0, i8* %59
  %60 = getelementptr inbounds [26 x i8], [26 x i8]* %33, i16 0, i16 0
  call void @writeString(i8* %60)
  %61 = load i16, i16* %0
  %62 = add i16 %61, 1
  store i16 %62, i16* %0
  %63 = load i16, i16* %0
  %64 = icmp slt i16 %63, 2
  br i1 %64, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %65 = getelementptr inbounds [3 x i16], [3 x i16]* %1, i16 0, i16 2
  %66 = call i16 @readInteger()
  store i16 %66, i16* %65
  store i16 0, i16* %0
  %67 = load i16, i16* %0
  %68 = icmp slt i16 %67, 3
  br i1 %68, label %while1, label %while.exit1

while1:                                           ; preds = %while1, %while.exit
  %69 = load i16, i16* %0
  %70 = getelementptr inbounds [3 x i16], [3 x i16]* %1, i16 0, i16 %69
  %71 = load i16, i16* %70
  call void @writeInteger(i16 %71)
  %72 = load i16, i16* %0
  %73 = getelementptr inbounds [3 x i16], [3 x i16]* %1, i16 0, i16 %72
  %74 = load i16, i16* %73
  %75 = call i16 @add1(i16 %74)
  call void @writeInteger(i16 %75)
  %76 = load i16, i16* %0
  %77 = add i16 %76, 1
  store i16 %77, i16* %0
  %78 = load i16, i16* %0
  %79 = icmp slt i16 %78, 3
  br i1 %79, label %while1, label %while.exit1

while.exit1:                                      ; preds = %while1, %while.exit
  %80 = alloca [26 x i8]
  %81 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 0
  store i8 71, i8* %81
  %82 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 1
  store i8 105, i8* %82
  %83 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 2
  store i8 118, i8* %83
  %84 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 3
  store i8 101, i8* %84
  %85 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 4
  store i8 32, i8* %85
  %86 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 5
  store i8 109, i8* %86
  %87 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 6
  store i8 101, i8* %87
  %88 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 7
  store i8 32, i8* %88
  %89 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 8
  store i8 97, i8* %89
  %90 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 9
  store i8 110, i8* %90
  %91 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 10
  store i8 111, i8* %91
  %92 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 11
  store i8 116, i8* %92
  %93 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 12
  store i8 104, i8* %93
  %94 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 13
  store i8 101, i8* %94
  %95 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 14
  store i8 114, i8* %95
  %96 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 15
  store i8 32, i8* %96
  %97 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 16
  store i8 105, i8* %97
  %98 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 17
  store i8 110, i8* %98
  %99 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 18
  store i8 116, i8* %99
  %100 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 19
  store i8 101, i8* %100
  %101 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 20
  store i8 103, i8* %101
  %102 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 21
  store i8 101, i8* %102
  %103 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 22
  store i8 114, i8* %103
  %104 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 23
  store i8 58, i8* %104
  %105 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 24
  store i8 32, i8* %105
  %106 = getelementptr [26 x i8], [26 x i8]* %80, i16 0, i16 25
  store i8 0, i8* %106
  %107 = getelementptr inbounds [26 x i8], [26 x i8]* %80, i16 0, i16 2
  %108 = load i8, i8* %107
  call void @writeChar(i8 %108)
  %109 = alloca [5 x i8]
  %110 = getelementptr [5 x i8], [5 x i8]* %109, i16 0, i16 0
  store i8 104, i8* %110
  %111 = getelementptr [5 x i8], [5 x i8]* %109, i16 0, i16 1
  store i8 101, i8* %111
  %112 = getelementptr [5 x i8], [5 x i8]* %109, i16 0, i16 2
  store i8 121, i8* %112
  %113 = getelementptr [5 x i8], [5 x i8]* %109, i16 0, i16 3
  store i8 10, i8* %113
  %114 = getelementptr [5 x i8], [5 x i8]* %109, i16 0, i16 4
  store i8 0, i8* %114
  %115 = load [5 x i8], [5 x i8]* %109
  store [5 x i8] %115, [5 x i8]* %3
  %116 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i16 0, i16 0
  call void @writeString(i8* %116)
  %117 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i16 0, i16 2
  store i8* %117, i8** %4
  %118 = load i8*, i8** %4
  %119 = load i8, i8* %118
  call void @writeChar(i8 %119)
  ret void
}
