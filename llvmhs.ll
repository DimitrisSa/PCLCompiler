; ModuleID = 'RValuesPredefined'
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

define void @main() {
entry:
  %0 = alloca i16
  %1 = alloca i16
  %2 = alloca i16
  %3 = alloca i1
  %4 = alloca i1
  %5 = alloca i1
  %6 = alloca i8
  %7 = alloca i8
  %8 = alloca i8
  %9 = alloca double
  %10 = alloca double
  %11 = alloca double
  %12 = alloca i16*
  %13 = alloca [21 x i8]
  %14 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 0
  store i8 71, i8* %14
  %15 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 1
  store i8 105, i8* %15
  %16 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 2
  store i8 118, i8* %16
  %17 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 3
  store i8 101, i8* %17
  %18 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 4
  store i8 32, i8* %18
  %19 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 5
  store i8 109, i8* %19
  %20 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 6
  store i8 101, i8* %20
  %21 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 7
  store i8 32, i8* %21
  %22 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 8
  store i8 97, i8* %22
  %23 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 9
  store i8 110, i8* %23
  %24 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 10
  store i8 32, i8* %24
  %25 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 11
  store i8 105, i8* %25
  %26 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 12
  store i8 110, i8* %26
  %27 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 13
  store i8 116, i8* %27
  %28 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 14
  store i8 101, i8* %28
  %29 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 15
  store i8 103, i8* %29
  %30 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 16
  store i8 101, i8* %30
  %31 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 17
  store i8 114, i8* %31
  %32 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 18
  store i8 58, i8* %32
  %33 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 19
  store i8 32, i8* %33
  %34 = getelementptr [21 x i8], [21 x i8]* %13, i16 0, i16 20
  store i8 0, i8* %34
  %35 = getelementptr inbounds [21 x i8], [21 x i8]* %13, i16 0, i16 0
  %36 = alloca i8*
  store i8* %35, i8** %36
  call void @writeString(i8** %36)
  %37 = call i16 @readInteger()
  store i16 %37, i16* %0
  %38 = alloca [22 x i8]
  %39 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 0
  store i8 72, i8* %39
  %40 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 1
  store i8 101, i8* %40
  %41 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 2
  store i8 114, i8* %41
  %42 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 3
  store i8 101, i8* %42
  %43 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 4
  store i8 39, i8* %43
  %44 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 5
  store i8 115, i8* %44
  %45 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 6
  store i8 32, i8* %45
  %46 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 7
  store i8 121, i8* %46
  %47 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 8
  store i8 111, i8* %47
  %48 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 9
  store i8 117, i8* %48
  %49 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 10
  store i8 114, i8* %49
  %50 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 11
  store i8 32, i8* %50
  %51 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 12
  store i8 105, i8* %51
  %52 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 13
  store i8 110, i8* %52
  %53 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 14
  store i8 116, i8* %53
  %54 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 15
  store i8 101, i8* %54
  %55 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 16
  store i8 103, i8* %55
  %56 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 17
  store i8 101, i8* %56
  %57 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 18
  store i8 114, i8* %57
  %58 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 19
  store i8 58, i8* %58
  %59 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 20
  store i8 32, i8* %59
  %60 = getelementptr [22 x i8], [22 x i8]* %38, i16 0, i16 21
  store i8 0, i8* %60
  %61 = getelementptr inbounds [22 x i8], [22 x i8]* %38, i16 0, i16 0
  %62 = alloca i8*
  store i8* %61, i8** %62
  call void @writeString(i8** %62)
  %63 = load i16, i16* %0
  call void @writeInteger(i16 %63)
  %64 = alloca [2 x i8]
  %65 = getelementptr [2 x i8], [2 x i8]* %64, i16 0, i16 0
  store i8 10, i8* %65
  %66 = getelementptr [2 x i8], [2 x i8]* %64, i16 0, i16 1
  store i8 0, i8* %66
  %67 = getelementptr inbounds [2 x i8], [2 x i8]* %64, i16 0, i16 0
  %68 = alloca i8*
  store i8* %67, i8** %68
  call void @writeString(i8** %68)
  %69 = alloca [24 x i8]
  %70 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 0
  store i8 72, i8* %70
  %71 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 1
  store i8 101, i8* %71
  %72 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 2
  store i8 114, i8* %72
  %73 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 3
  store i8 101, i8* %73
  %74 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 4
  store i8 39, i8* %74
  %75 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 5
  store i8 115, i8* %75
  %76 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 6
  store i8 32, i8* %76
  %77 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 7
  store i8 43, i8* %77
  %78 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 8
  store i8 32, i8* %78
  %79 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 9
  store i8 121, i8* %79
  %80 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 10
  store i8 111, i8* %80
  %81 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 11
  store i8 117, i8* %81
  %82 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 12
  store i8 114, i8* %82
  %83 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 13
  store i8 32, i8* %83
  %84 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 14
  store i8 105, i8* %84
  %85 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 15
  store i8 110, i8* %85
  %86 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 16
  store i8 116, i8* %86
  %87 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 17
  store i8 101, i8* %87
  %88 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 18
  store i8 103, i8* %88
  %89 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 19
  store i8 101, i8* %89
  %90 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 20
  store i8 114, i8* %90
  %91 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 21
  store i8 58, i8* %91
  %92 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 22
  store i8 32, i8* %92
  %93 = getelementptr [24 x i8], [24 x i8]* %69, i16 0, i16 23
  store i8 0, i8* %93
  %94 = getelementptr inbounds [24 x i8], [24 x i8]* %69, i16 0, i16 0
  %95 = alloca i8*
  store i8* %94, i8** %95
  call void @writeString(i8** %95)
  %96 = load i16, i16* %0
  %97 = sub i16 0, %96
  call void @writeInteger(i16 %96)
  %98 = alloca [2 x i8]
  %99 = getelementptr [2 x i8], [2 x i8]* %98, i16 0, i16 0
  store i8 10, i8* %99
  %100 = getelementptr [2 x i8], [2 x i8]* %98, i16 0, i16 1
  store i8 0, i8* %100
  %101 = getelementptr inbounds [2 x i8], [2 x i8]* %98, i16 0, i16 0
  %102 = alloca i8*
  store i8* %101, i8** %102
  call void @writeString(i8** %102)
  %103 = alloca [24 x i8]
  %104 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 0
  store i8 72, i8* %104
  %105 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 1
  store i8 101, i8* %105
  %106 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 2
  store i8 114, i8* %106
  %107 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 3
  store i8 101, i8* %107
  %108 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 4
  store i8 39, i8* %108
  %109 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 5
  store i8 115, i8* %109
  %110 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 6
  store i8 32, i8* %110
  %111 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 7
  store i8 45, i8* %111
  %112 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 8
  store i8 32, i8* %112
  %113 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 9
  store i8 121, i8* %113
  %114 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 10
  store i8 111, i8* %114
  %115 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 11
  store i8 117, i8* %115
  %116 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 12
  store i8 114, i8* %116
  %117 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 13
  store i8 32, i8* %117
  %118 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 14
  store i8 105, i8* %118
  %119 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 15
  store i8 110, i8* %119
  %120 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 16
  store i8 116, i8* %120
  %121 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 17
  store i8 101, i8* %121
  %122 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 18
  store i8 103, i8* %122
  %123 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 19
  store i8 101, i8* %123
  %124 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 20
  store i8 114, i8* %124
  %125 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 21
  store i8 58, i8* %125
  %126 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 22
  store i8 32, i8* %126
  %127 = getelementptr [24 x i8], [24 x i8]* %103, i16 0, i16 23
  store i8 0, i8* %127
  %128 = getelementptr inbounds [24 x i8], [24 x i8]* %103, i16 0, i16 0
  %129 = alloca i8*
  store i8* %128, i8** %129
  call void @writeString(i8** %129)
  %130 = load i16, i16* %0
  %131 = sub i16 0, %130
  call void @writeInteger(i16 %131)
  %132 = alloca [2 x i8]
  %133 = getelementptr [2 x i8], [2 x i8]* %132, i16 0, i16 0
  store i8 10, i8* %133
  %134 = getelementptr [2 x i8], [2 x i8]* %132, i16 0, i16 1
  store i8 0, i8* %134
  %135 = getelementptr inbounds [2 x i8], [2 x i8]* %132, i16 0, i16 0
  %136 = alloca i8*
  store i8* %135, i8** %136
  call void @writeString(i8** %136)
  %137 = alloca [39 x i8]
  %138 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 0
  store i8 72, i8* %138
  %139 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 1
  store i8 101, i8* %139
  %140 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 2
  store i8 114, i8* %140
  %141 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 3
  store i8 101, i8* %141
  %142 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 4
  store i8 39, i8* %142
  %143 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 5
  store i8 115, i8* %143
  %144 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 6
  store i8 32, i8* %144
  %145 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 7
  store i8 121, i8* %145
  %146 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 8
  store i8 111, i8* %146
  %147 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 9
  store i8 117, i8* %147
  %148 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 10
  store i8 114, i8* %148
  %149 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 11
  store i8 32, i8* %149
  %150 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 12
  store i8 105, i8* %150
  %151 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 13
  store i8 110, i8* %151
  %152 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 14
  store i8 116, i8* %152
  %153 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 15
  store i8 101, i8* %153
  %154 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 16
  store i8 103, i8* %154
  %155 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 17
  store i8 101, i8* %155
  %156 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 18
  store i8 114, i8* %156
  %157 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 19
  store i8 39, i8* %157
  %158 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 20
  store i8 115, i8* %158
  %159 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 21
  store i8 32, i8* %159
  %160 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 22
  store i8 97, i8* %160
  %161 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 23
  store i8 98, i8* %161
  %162 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 24
  store i8 115, i8* %162
  %163 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 25
  store i8 111, i8* %163
  %164 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 26
  store i8 108, i8* %164
  %165 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 27
  store i8 117, i8* %165
  %166 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 28
  store i8 116, i8* %166
  %167 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 29
  store i8 101, i8* %167
  %168 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 30
  store i8 32, i8* %168
  %169 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 31
  store i8 118, i8* %169
  %170 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 32
  store i8 97, i8* %170
  %171 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 33
  store i8 108, i8* %171
  %172 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 34
  store i8 117, i8* %172
  %173 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 35
  store i8 101, i8* %173
  %174 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 36
  store i8 58, i8* %174
  %175 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 37
  store i8 32, i8* %175
  %176 = getelementptr [39 x i8], [39 x i8]* %137, i16 0, i16 38
  store i8 0, i8* %176
  %177 = getelementptr inbounds [39 x i8], [39 x i8]* %137, i16 0, i16 0
  %178 = alloca i8*
  store i8* %177, i8** %178
  call void @writeString(i8** %178)
  %179 = load i16, i16* %0
  %180 = call i16 @abs(i16 %179)
  call void @writeInteger(i16 %180)
  %181 = alloca [2 x i8]
  %182 = getelementptr [2 x i8], [2 x i8]* %181, i16 0, i16 0
  store i8 10, i8* %182
  %183 = getelementptr [2 x i8], [2 x i8]* %181, i16 0, i16 1
  store i8 0, i8* %183
  %184 = getelementptr inbounds [2 x i8], [2 x i8]* %181, i16 0, i16 0
  %185 = alloca i8*
  store i8* %184, i8** %185
  call void @writeString(i8** %185)
  %186 = alloca [40 x i8]
  %187 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 0
  store i8 72, i8* %187
  %188 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 1
  store i8 101, i8* %188
  %189 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 2
  store i8 114, i8* %189
  %190 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 3
  store i8 101, i8* %190
  %191 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 4
  store i8 39, i8* %191
  %192 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 5
  store i8 115, i8* %192
  %193 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 6
  store i8 32, i8* %193
  %194 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 7
  store i8 121, i8* %194
  %195 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 8
  store i8 111, i8* %195
  %196 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 9
  store i8 117, i8* %196
  %197 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 10
  store i8 114, i8* %197
  %198 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 11
  store i8 32, i8* %198
  %199 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 12
  store i8 105, i8* %199
  %200 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 13
  store i8 110, i8* %200
  %201 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 14
  store i8 116, i8* %201
  %202 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 15
  store i8 101, i8* %202
  %203 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 16
  store i8 103, i8* %203
  %204 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 17
  store i8 101, i8* %204
  %205 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 18
  store i8 114, i8* %205
  %206 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 19
  store i8 39, i8* %206
  %207 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 20
  store i8 115, i8* %207
  %208 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 21
  store i8 32, i8* %208
  %209 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 22
  store i8 114, i8* %209
  %210 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 23
  store i8 101, i8* %210
  %211 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 24
  store i8 97, i8* %211
  %212 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 25
  store i8 108, i8* %212
  %213 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 26
  store i8 32, i8* %213
  %214 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 27
  store i8 101, i8* %214
  %215 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 28
  store i8 113, i8* %215
  %216 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 29
  store i8 117, i8* %216
  %217 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 30
  store i8 105, i8* %217
  %218 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 31
  store i8 118, i8* %218
  %219 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 32
  store i8 97, i8* %219
  %220 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 33
  store i8 108, i8* %220
  %221 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 34
  store i8 101, i8* %221
  %222 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 35
  store i8 110, i8* %222
  %223 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 36
  store i8 116, i8* %223
  %224 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 37
  store i8 58, i8* %224
  %225 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 38
  store i8 32, i8* %225
  %226 = getelementptr [40 x i8], [40 x i8]* %186, i16 0, i16 39
  store i8 0, i8* %226
  %227 = getelementptr inbounds [40 x i8], [40 x i8]* %186, i16 0, i16 0
  %228 = alloca i8*
  store i8* %227, i8** %228
  call void @writeString(i8** %228)
  %229 = load i16, i16* %0
  %230 = sitofp i16 %229 to double
  call void @writeReal(double %230)
  %231 = alloca [2 x i8]
  %232 = getelementptr [2 x i8], [2 x i8]* %231, i16 0, i16 0
  store i8 10, i8* %232
  %233 = getelementptr [2 x i8], [2 x i8]* %231, i16 0, i16 1
  store i8 0, i8* %233
  %234 = getelementptr inbounds [2 x i8], [2 x i8]* %231, i16 0, i16 0
  %235 = alloca i8*
  store i8* %234, i8** %235
  call void @writeString(i8** %235)
  %236 = alloca [46 x i8]
  %237 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 0
  store i8 72, i8* %237
  %238 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 1
  store i8 101, i8* %238
  %239 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 2
  store i8 114, i8* %239
  %240 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 3
  store i8 101, i8* %240
  %241 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 4
  store i8 39, i8* %241
  %242 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 5
  store i8 115, i8* %242
  %243 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 6
  store i8 32, i8* %243
  %244 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 7
  store i8 121, i8* %244
  %245 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 8
  store i8 111, i8* %245
  %246 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 9
  store i8 117, i8* %246
  %247 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 10
  store i8 114, i8* %247
  %248 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 11
  store i8 32, i8* %248
  %249 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 12
  store i8 105, i8* %249
  %250 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 13
  store i8 110, i8* %250
  %251 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 14
  store i8 116, i8* %251
  %252 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 15
  store i8 101, i8* %252
  %253 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 16
  store i8 103, i8* %253
  %254 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 17
  store i8 101, i8* %254
  %255 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 18
  store i8 114, i8* %255
  %256 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 19
  store i8 39, i8* %256
  %257 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 20
  store i8 115, i8* %257
  %258 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 21
  store i8 32, i8* %258
  %259 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 22
  store i8 65, i8* %259
  %260 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 23
  store i8 83, i8* %260
  %261 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 24
  store i8 67, i8* %261
  %262 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 25
  store i8 73, i8* %262
  %263 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 26
  store i8 73, i8* %263
  %264 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 27
  store i8 32, i8* %264
  %265 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 28
  store i8 99, i8* %265
  %266 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 29
  store i8 104, i8* %266
  %267 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 30
  store i8 97, i8* %267
  %268 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 31
  store i8 114, i8* %268
  %269 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 32
  store i8 32, i8* %269
  %270 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 33
  store i8 101, i8* %270
  %271 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 34
  store i8 113, i8* %271
  %272 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 35
  store i8 117, i8* %272
  %273 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 36
  store i8 105, i8* %273
  %274 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 37
  store i8 118, i8* %274
  %275 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 38
  store i8 97, i8* %275
  %276 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 39
  store i8 108, i8* %276
  %277 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 40
  store i8 101, i8* %277
  %278 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 41
  store i8 110, i8* %278
  %279 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 42
  store i8 116, i8* %279
  %280 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 43
  store i8 58, i8* %280
  %281 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 44
  store i8 32, i8* %281
  %282 = getelementptr [46 x i8], [46 x i8]* %236, i16 0, i16 45
  store i8 0, i8* %282
  %283 = getelementptr inbounds [46 x i8], [46 x i8]* %236, i16 0, i16 0
  %284 = alloca i8*
  store i8* %283, i8** %284
  call void @writeString(i8** %284)
  %285 = load i16, i16* %0
  %286 = call i8 @chr(i16 %285)
  call void @writeChar(i8 %286)
  %287 = alloca [2 x i8]
  %288 = getelementptr [2 x i8], [2 x i8]* %287, i16 0, i16 0
  store i8 10, i8* %288
  %289 = getelementptr [2 x i8], [2 x i8]* %287, i16 0, i16 1
  store i8 0, i8* %289
  %290 = getelementptr inbounds [2 x i8], [2 x i8]* %287, i16 0, i16 0
  %291 = alloca i8*
  store i8* %290, i8** %291
  call void @writeString(i8** %291)
  store i16* %0, i16** %12
  %292 = alloca [20 x i8]
  %293 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 0
  store i8 71, i8* %293
  %294 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 1
  store i8 105, i8* %294
  %295 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 2
  store i8 118, i8* %295
  %296 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 3
  store i8 101, i8* %296
  %297 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 4
  store i8 32, i8* %297
  %298 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 5
  store i8 109, i8* %298
  %299 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 6
  store i8 101, i8* %299
  %300 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 7
  store i8 32, i8* %300
  %301 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 8
  store i8 97, i8* %301
  %302 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 9
  store i8 32, i8* %302
  %303 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 10
  store i8 98, i8* %303
  %304 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 11
  store i8 111, i8* %304
  %305 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 12
  store i8 111, i8* %305
  %306 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 13
  store i8 108, i8* %306
  %307 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 14
  store i8 101, i8* %307
  %308 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 15
  store i8 97, i8* %308
  %309 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 16
  store i8 110, i8* %309
  %310 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 17
  store i8 58, i8* %310
  %311 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 18
  store i8 32, i8* %311
  %312 = getelementptr [20 x i8], [20 x i8]* %292, i16 0, i16 19
  store i8 0, i8* %312
  %313 = getelementptr inbounds [20 x i8], [20 x i8]* %292, i16 0, i16 0
  %314 = alloca i8*
  store i8* %313, i8** %314
  call void @writeString(i8** %314)
  %315 = call i1 @readBoolean()
  store i1 %315, i1* %3
  %316 = alloca [22 x i8]
  %317 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 0
  store i8 72, i8* %317
  %318 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 1
  store i8 101, i8* %318
  %319 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 2
  store i8 114, i8* %319
  %320 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 3
  store i8 101, i8* %320
  %321 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 4
  store i8 39, i8* %321
  %322 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 5
  store i8 115, i8* %322
  %323 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 6
  store i8 32, i8* %323
  %324 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 7
  store i8 121, i8* %324
  %325 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 8
  store i8 111, i8* %325
  %326 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 9
  store i8 117, i8* %326
  %327 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 10
  store i8 114, i8* %327
  %328 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 11
  store i8 32, i8* %328
  %329 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 12
  store i8 98, i8* %329
  %330 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 13
  store i8 111, i8* %330
  %331 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 14
  store i8 111, i8* %331
  %332 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 15
  store i8 108, i8* %332
  %333 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 16
  store i8 101, i8* %333
  %334 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 17
  store i8 97, i8* %334
  %335 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 18
  store i8 110, i8* %335
  %336 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 19
  store i8 58, i8* %336
  %337 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 20
  store i8 32, i8* %337
  %338 = getelementptr [22 x i8], [22 x i8]* %316, i16 0, i16 21
  store i8 0, i8* %338
  %339 = getelementptr inbounds [22 x i8], [22 x i8]* %316, i16 0, i16 0
  %340 = alloca i8*
  store i8* %339, i8** %340
  call void @writeString(i8** %340)
  %341 = load i1, i1* %3
  call void @writeBoolean(i1 %341)
  %342 = alloca [2 x i8]
  %343 = getelementptr [2 x i8], [2 x i8]* %342, i16 0, i16 0
  store i8 10, i8* %343
  %344 = getelementptr [2 x i8], [2 x i8]* %342, i16 0, i16 1
  store i8 0, i8* %344
  %345 = getelementptr inbounds [2 x i8], [2 x i8]* %342, i16 0, i16 0
  %346 = alloca i8*
  store i8* %345, i8** %346
  call void @writeString(i8** %346)
  %347 = alloca [26 x i8]
  %348 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 0
  store i8 72, i8* %348
  %349 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 1
  store i8 101, i8* %349
  %350 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 2
  store i8 114, i8* %350
  %351 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 3
  store i8 101, i8* %351
  %352 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 4
  store i8 39, i8* %352
  %353 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 5
  store i8 115, i8* %353
  %354 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 6
  store i8 32, i8* %354
  %355 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 7
  store i8 110, i8* %355
  %356 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 8
  store i8 111, i8* %356
  %357 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 9
  store i8 116, i8* %357
  %358 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 10
  store i8 32, i8* %358
  %359 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 11
  store i8 121, i8* %359
  %360 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 12
  store i8 111, i8* %360
  %361 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 13
  store i8 117, i8* %361
  %362 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 14
  store i8 114, i8* %362
  %363 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 15
  store i8 32, i8* %363
  %364 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 16
  store i8 98, i8* %364
  %365 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 17
  store i8 111, i8* %365
  %366 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 18
  store i8 111, i8* %366
  %367 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 19
  store i8 108, i8* %367
  %368 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 20
  store i8 101, i8* %368
  %369 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 21
  store i8 97, i8* %369
  %370 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 22
  store i8 110, i8* %370
  %371 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 23
  store i8 58, i8* %371
  %372 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 24
  store i8 32, i8* %372
  %373 = getelementptr [26 x i8], [26 x i8]* %347, i16 0, i16 25
  store i8 0, i8* %373
  %374 = getelementptr inbounds [26 x i8], [26 x i8]* %347, i16 0, i16 0
  %375 = alloca i8*
  store i8* %374, i8** %375
  call void @writeString(i8** %375)
  %376 = load i1, i1* %3
  %377 = icmp eq i1 %376, false
  call void @writeBoolean(i1 %377)
  %378 = alloca [2 x i8]
  %379 = getelementptr [2 x i8], [2 x i8]* %378, i16 0, i16 0
  store i8 10, i8* %379
  %380 = getelementptr [2 x i8], [2 x i8]* %378, i16 0, i16 1
  store i8 0, i8* %380
  %381 = getelementptr inbounds [2 x i8], [2 x i8]* %378, i16 0, i16 0
  %382 = alloca i8*
  store i8* %381, i8** %382
  call void @writeString(i8** %382)
  %383 = alloca [17 x i8]
  %384 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 0
  store i8 71, i8* %384
  %385 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 1
  store i8 105, i8* %385
  %386 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 2
  store i8 118, i8* %386
  %387 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 3
  store i8 101, i8* %387
  %388 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 4
  store i8 32, i8* %388
  %389 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 5
  store i8 109, i8* %389
  %390 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 6
  store i8 101, i8* %390
  %391 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 7
  store i8 32, i8* %391
  %392 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 8
  store i8 97, i8* %392
  %393 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 9
  store i8 32, i8* %393
  %394 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 10
  store i8 114, i8* %394
  %395 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 11
  store i8 101, i8* %395
  %396 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 12
  store i8 97, i8* %396
  %397 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 13
  store i8 108, i8* %397
  %398 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 14
  store i8 58, i8* %398
  %399 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 15
  store i8 32, i8* %399
  %400 = getelementptr [17 x i8], [17 x i8]* %383, i16 0, i16 16
  store i8 0, i8* %400
  %401 = getelementptr inbounds [17 x i8], [17 x i8]* %383, i16 0, i16 0
  %402 = alloca i8*
  store i8* %401, i8** %402
  call void @writeString(i8** %402)
  %403 = call double @readReal()
  store double %403, double* %9
  %404 = alloca [19 x i8]
  %405 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 0
  store i8 72, i8* %405
  %406 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 1
  store i8 101, i8* %406
  %407 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 2
  store i8 114, i8* %407
  %408 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 3
  store i8 101, i8* %408
  %409 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 4
  store i8 39, i8* %409
  %410 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 5
  store i8 115, i8* %410
  %411 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 6
  store i8 32, i8* %411
  %412 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 7
  store i8 121, i8* %412
  %413 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 8
  store i8 111, i8* %413
  %414 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 9
  store i8 117, i8* %414
  %415 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 10
  store i8 114, i8* %415
  %416 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 11
  store i8 32, i8* %416
  %417 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 12
  store i8 114, i8* %417
  %418 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 13
  store i8 101, i8* %418
  %419 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 14
  store i8 97, i8* %419
  %420 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 15
  store i8 108, i8* %420
  %421 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 16
  store i8 58, i8* %421
  %422 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 17
  store i8 32, i8* %422
  %423 = getelementptr [19 x i8], [19 x i8]* %404, i16 0, i16 18
  store i8 0, i8* %423
  %424 = getelementptr inbounds [19 x i8], [19 x i8]* %404, i16 0, i16 0
  %425 = alloca i8*
  store i8* %424, i8** %425
  call void @writeString(i8** %425)
  %426 = load double, double* %9
  call void @writeReal(double %426)
  %427 = alloca [2 x i8]
  %428 = getelementptr [2 x i8], [2 x i8]* %427, i16 0, i16 0
  store i8 10, i8* %428
  %429 = getelementptr [2 x i8], [2 x i8]* %427, i16 0, i16 1
  store i8 0, i8* %429
  %430 = getelementptr inbounds [2 x i8], [2 x i8]* %427, i16 0, i16 0
  %431 = alloca i8*
  store i8* %430, i8** %431
  call void @writeString(i8** %431)
  %432 = alloca [21 x i8]
  %433 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 0
  store i8 72, i8* %433
  %434 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 1
  store i8 101, i8* %434
  %435 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 2
  store i8 114, i8* %435
  %436 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 3
  store i8 101, i8* %436
  %437 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 4
  store i8 39, i8* %437
  %438 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 5
  store i8 115, i8* %438
  %439 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 6
  store i8 32, i8* %439
  %440 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 7
  store i8 43, i8* %440
  %441 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 8
  store i8 32, i8* %441
  %442 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 9
  store i8 121, i8* %442
  %443 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 10
  store i8 111, i8* %443
  %444 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 11
  store i8 117, i8* %444
  %445 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 12
  store i8 114, i8* %445
  %446 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 13
  store i8 32, i8* %446
  %447 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 14
  store i8 114, i8* %447
  %448 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 15
  store i8 101, i8* %448
  %449 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 16
  store i8 97, i8* %449
  %450 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 17
  store i8 108, i8* %450
  %451 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 18
  store i8 58, i8* %451
  %452 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 19
  store i8 32, i8* %452
  %453 = getelementptr [21 x i8], [21 x i8]* %432, i16 0, i16 20
  store i8 0, i8* %453
  %454 = getelementptr inbounds [21 x i8], [21 x i8]* %432, i16 0, i16 0
  %455 = alloca i8*
  store i8* %454, i8** %455
  call void @writeString(i8** %455)
  %456 = load double, double* %9
  %457 = fsub double 0.000000e+00, %456
  call void @writeReal(double %456)
  %458 = alloca [2 x i8]
  %459 = getelementptr [2 x i8], [2 x i8]* %458, i16 0, i16 0
  store i8 10, i8* %459
  %460 = getelementptr [2 x i8], [2 x i8]* %458, i16 0, i16 1
  store i8 0, i8* %460
  %461 = getelementptr inbounds [2 x i8], [2 x i8]* %458, i16 0, i16 0
  %462 = alloca i8*
  store i8* %461, i8** %462
  call void @writeString(i8** %462)
  %463 = alloca [21 x i8]
  %464 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 0
  store i8 72, i8* %464
  %465 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 1
  store i8 101, i8* %465
  %466 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 2
  store i8 114, i8* %466
  %467 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 3
  store i8 101, i8* %467
  %468 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 4
  store i8 39, i8* %468
  %469 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 5
  store i8 115, i8* %469
  %470 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 6
  store i8 32, i8* %470
  %471 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 7
  store i8 45, i8* %471
  %472 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 8
  store i8 32, i8* %472
  %473 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 9
  store i8 121, i8* %473
  %474 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 10
  store i8 111, i8* %474
  %475 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 11
  store i8 117, i8* %475
  %476 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 12
  store i8 114, i8* %476
  %477 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 13
  store i8 32, i8* %477
  %478 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 14
  store i8 114, i8* %478
  %479 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 15
  store i8 101, i8* %479
  %480 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 16
  store i8 97, i8* %480
  %481 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 17
  store i8 108, i8* %481
  %482 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 18
  store i8 58, i8* %482
  %483 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 19
  store i8 32, i8* %483
  %484 = getelementptr [21 x i8], [21 x i8]* %463, i16 0, i16 20
  store i8 0, i8* %484
  %485 = getelementptr inbounds [21 x i8], [21 x i8]* %463, i16 0, i16 0
  %486 = alloca i8*
  store i8* %485, i8** %486
  call void @writeString(i8** %486)
  %487 = load double, double* %9
  %488 = fsub double 0.000000e+00, %487
  call void @writeReal(double %488)
  %489 = alloca [2 x i8]
  %490 = getelementptr [2 x i8], [2 x i8]* %489, i16 0, i16 0
  store i8 10, i8* %490
  %491 = getelementptr [2 x i8], [2 x i8]* %489, i16 0, i16 1
  store i8 0, i8* %491
  %492 = getelementptr inbounds [2 x i8], [2 x i8]* %489, i16 0, i16 0
  %493 = alloca i8*
  store i8* %492, i8** %493
  call void @writeString(i8** %493)
  %494 = alloca [36 x i8]
  %495 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 0
  store i8 72, i8* %495
  %496 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 1
  store i8 101, i8* %496
  %497 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 2
  store i8 114, i8* %497
  %498 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 3
  store i8 101, i8* %498
  %499 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 4
  store i8 39, i8* %499
  %500 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 5
  store i8 115, i8* %500
  %501 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 6
  store i8 32, i8* %501
  %502 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 7
  store i8 121, i8* %502
  %503 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 8
  store i8 111, i8* %503
  %504 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 9
  store i8 117, i8* %504
  %505 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 10
  store i8 114, i8* %505
  %506 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 11
  store i8 32, i8* %506
  %507 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 12
  store i8 114, i8* %507
  %508 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 13
  store i8 101, i8* %508
  %509 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 14
  store i8 97, i8* %509
  %510 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 15
  store i8 108, i8* %510
  %511 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 16
  store i8 39, i8* %511
  %512 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 17
  store i8 115, i8* %512
  %513 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 18
  store i8 32, i8* %513
  %514 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 19
  store i8 97, i8* %514
  %515 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 20
  store i8 98, i8* %515
  %516 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 21
  store i8 115, i8* %516
  %517 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 22
  store i8 111, i8* %517
  %518 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 23
  store i8 108, i8* %518
  %519 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 24
  store i8 117, i8* %519
  %520 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 25
  store i8 116, i8* %520
  %521 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 26
  store i8 101, i8* %521
  %522 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 27
  store i8 32, i8* %522
  %523 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 28
  store i8 118, i8* %523
  %524 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 29
  store i8 97, i8* %524
  %525 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 30
  store i8 108, i8* %525
  %526 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 31
  store i8 117, i8* %526
  %527 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 32
  store i8 101, i8* %527
  %528 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 33
  store i8 58, i8* %528
  %529 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 34
  store i8 32, i8* %529
  %530 = getelementptr [36 x i8], [36 x i8]* %494, i16 0, i16 35
  store i8 0, i8* %530
  %531 = getelementptr inbounds [36 x i8], [36 x i8]* %494, i16 0, i16 0
  %532 = alloca i8*
  store i8* %531, i8** %532
  call void @writeString(i8** %532)
  %533 = load double, double* %9
  %534 = call double @fabs(double %533)
  call void @writeReal(double %534)
  %535 = alloca [2 x i8]
  %536 = getelementptr [2 x i8], [2 x i8]* %535, i16 0, i16 0
  store i8 10, i8* %536
  %537 = getelementptr [2 x i8], [2 x i8]* %535, i16 0, i16 1
  store i8 0, i8* %537
  %538 = getelementptr inbounds [2 x i8], [2 x i8]* %535, i16 0, i16 0
  %539 = alloca i8*
  store i8* %538, i8** %539
  call void @writeString(i8** %539)
  %540 = alloca [33 x i8]
  %541 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 0
  store i8 72, i8* %541
  %542 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 1
  store i8 101, i8* %542
  %543 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 2
  store i8 114, i8* %543
  %544 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 3
  store i8 101, i8* %544
  %545 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 4
  store i8 39, i8* %545
  %546 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 5
  store i8 115, i8* %546
  %547 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 6
  store i8 32, i8* %547
  %548 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 7
  store i8 121, i8* %548
  %549 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 8
  store i8 111, i8* %549
  %550 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 9
  store i8 117, i8* %550
  %551 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 10
  store i8 114, i8* %551
  %552 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 11
  store i8 32, i8* %552
  %553 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 12
  store i8 114, i8* %553
  %554 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 13
  store i8 101, i8* %554
  %555 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 14
  store i8 97, i8* %555
  %556 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 15
  store i8 108, i8* %556
  %557 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 16
  store i8 39, i8* %557
  %558 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 17
  store i8 115, i8* %558
  %559 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 18
  store i8 32, i8* %559
  %560 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 19
  store i8 115, i8* %560
  %561 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 20
  store i8 113, i8* %561
  %562 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 21
  store i8 117, i8* %562
  %563 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 22
  store i8 97, i8* %563
  %564 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 23
  store i8 114, i8* %564
  %565 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 24
  store i8 101, i8* %565
  %566 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 25
  store i8 32, i8* %566
  %567 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 26
  store i8 114, i8* %567
  %568 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 27
  store i8 111, i8* %568
  %569 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 28
  store i8 111, i8* %569
  %570 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 29
  store i8 116, i8* %570
  %571 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 30
  store i8 58, i8* %571
  %572 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 31
  store i8 32, i8* %572
  %573 = getelementptr [33 x i8], [33 x i8]* %540, i16 0, i16 32
  store i8 0, i8* %573
  %574 = getelementptr inbounds [33 x i8], [33 x i8]* %540, i16 0, i16 0
  %575 = alloca i8*
  store i8* %574, i8** %575
  call void @writeString(i8** %575)
  %576 = load double, double* %9
  %577 = call double @sqrt(double %576)
  call void @writeReal(double %577)
  %578 = alloca [2 x i8]
  %579 = getelementptr [2 x i8], [2 x i8]* %578, i16 0, i16 0
  store i8 10, i8* %579
  %580 = getelementptr [2 x i8], [2 x i8]* %578, i16 0, i16 1
  store i8 0, i8* %580
  %581 = getelementptr inbounds [2 x i8], [2 x i8]* %578, i16 0, i16 0
  %582 = alloca i8*
  store i8* %581, i8** %582
  call void @writeString(i8** %582)
  %583 = alloca [25 x i8]
  %584 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 0
  store i8 72, i8* %584
  %585 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 1
  store i8 101, i8* %585
  %586 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 2
  store i8 114, i8* %586
  %587 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 3
  store i8 101, i8* %587
  %588 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 4
  store i8 39, i8* %588
  %589 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 5
  store i8 115, i8* %589
  %590 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 6
  store i8 32, i8* %590
  %591 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 7
  store i8 121, i8* %591
  %592 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 8
  store i8 111, i8* %592
  %593 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 9
  store i8 117, i8* %593
  %594 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 10
  store i8 114, i8* %594
  %595 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 11
  store i8 32, i8* %595
  %596 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 12
  store i8 114, i8* %596
  %597 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 13
  store i8 101, i8* %597
  %598 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 14
  store i8 97, i8* %598
  %599 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 15
  store i8 108, i8* %599
  %600 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 16
  store i8 39, i8* %600
  %601 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 17
  store i8 115, i8* %601
  %602 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 18
  store i8 32, i8* %602
  %603 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 19
  store i8 115, i8* %603
  %604 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 20
  store i8 105, i8* %604
  %605 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 21
  store i8 110, i8* %605
  %606 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 22
  store i8 58, i8* %606
  %607 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 23
  store i8 32, i8* %607
  %608 = getelementptr [25 x i8], [25 x i8]* %583, i16 0, i16 24
  store i8 0, i8* %608
  %609 = getelementptr inbounds [25 x i8], [25 x i8]* %583, i16 0, i16 0
  %610 = alloca i8*
  store i8* %609, i8** %610
  call void @writeString(i8** %610)
  %611 = load double, double* %9
  %612 = call double @sin(double %611)
  call void @writeReal(double %612)
  %613 = alloca [2 x i8]
  %614 = getelementptr [2 x i8], [2 x i8]* %613, i16 0, i16 0
  store i8 10, i8* %614
  %615 = getelementptr [2 x i8], [2 x i8]* %613, i16 0, i16 1
  store i8 0, i8* %615
  %616 = getelementptr inbounds [2 x i8], [2 x i8]* %613, i16 0, i16 0
  %617 = alloca i8*
  store i8* %616, i8** %617
  call void @writeString(i8** %617)
  %618 = alloca [25 x i8]
  %619 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 0
  store i8 72, i8* %619
  %620 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 1
  store i8 101, i8* %620
  %621 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 2
  store i8 114, i8* %621
  %622 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 3
  store i8 101, i8* %622
  %623 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 4
  store i8 39, i8* %623
  %624 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 5
  store i8 115, i8* %624
  %625 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 6
  store i8 32, i8* %625
  %626 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 7
  store i8 121, i8* %626
  %627 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 8
  store i8 111, i8* %627
  %628 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 9
  store i8 117, i8* %628
  %629 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 10
  store i8 114, i8* %629
  %630 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 11
  store i8 32, i8* %630
  %631 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 12
  store i8 114, i8* %631
  %632 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 13
  store i8 101, i8* %632
  %633 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 14
  store i8 97, i8* %633
  %634 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 15
  store i8 108, i8* %634
  %635 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 16
  store i8 39, i8* %635
  %636 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 17
  store i8 115, i8* %636
  %637 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 18
  store i8 32, i8* %637
  %638 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 19
  store i8 99, i8* %638
  %639 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 20
  store i8 111, i8* %639
  %640 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 21
  store i8 115, i8* %640
  %641 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 22
  store i8 58, i8* %641
  %642 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 23
  store i8 32, i8* %642
  %643 = getelementptr [25 x i8], [25 x i8]* %618, i16 0, i16 24
  store i8 0, i8* %643
  %644 = getelementptr inbounds [25 x i8], [25 x i8]* %618, i16 0, i16 0
  %645 = alloca i8*
  store i8* %644, i8** %645
  call void @writeString(i8** %645)
  %646 = load double, double* %9
  %647 = call double @cos(double %646)
  call void @writeReal(double %647)
  %648 = alloca [2 x i8]
  %649 = getelementptr [2 x i8], [2 x i8]* %648, i16 0, i16 0
  store i8 10, i8* %649
  %650 = getelementptr [2 x i8], [2 x i8]* %648, i16 0, i16 1
  store i8 0, i8* %650
  %651 = getelementptr inbounds [2 x i8], [2 x i8]* %648, i16 0, i16 0
  %652 = alloca i8*
  store i8* %651, i8** %652
  call void @writeString(i8** %652)
  %653 = alloca [25 x i8]
  %654 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 0
  store i8 72, i8* %654
  %655 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 1
  store i8 101, i8* %655
  %656 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 2
  store i8 114, i8* %656
  %657 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 3
  store i8 101, i8* %657
  %658 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 4
  store i8 39, i8* %658
  %659 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 5
  store i8 115, i8* %659
  %660 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 6
  store i8 32, i8* %660
  %661 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 7
  store i8 121, i8* %661
  %662 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 8
  store i8 111, i8* %662
  %663 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 9
  store i8 117, i8* %663
  %664 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 10
  store i8 114, i8* %664
  %665 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 11
  store i8 32, i8* %665
  %666 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 12
  store i8 114, i8* %666
  %667 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 13
  store i8 101, i8* %667
  %668 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 14
  store i8 97, i8* %668
  %669 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 15
  store i8 108, i8* %669
  %670 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 16
  store i8 39, i8* %670
  %671 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 17
  store i8 115, i8* %671
  %672 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 18
  store i8 32, i8* %672
  %673 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 19
  store i8 116, i8* %673
  %674 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 20
  store i8 97, i8* %674
  %675 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 21
  store i8 110, i8* %675
  %676 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 22
  store i8 58, i8* %676
  %677 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 23
  store i8 32, i8* %677
  %678 = getelementptr [25 x i8], [25 x i8]* %653, i16 0, i16 24
  store i8 0, i8* %678
  %679 = getelementptr inbounds [25 x i8], [25 x i8]* %653, i16 0, i16 0
  %680 = alloca i8*
  store i8* %679, i8** %680
  call void @writeString(i8** %680)
  %681 = load double, double* %9
  %682 = call double @tan(double %681)
  call void @writeReal(double %682)
  %683 = alloca [2 x i8]
  %684 = getelementptr [2 x i8], [2 x i8]* %683, i16 0, i16 0
  store i8 10, i8* %684
  %685 = getelementptr [2 x i8], [2 x i8]* %683, i16 0, i16 1
  store i8 0, i8* %685
  %686 = getelementptr inbounds [2 x i8], [2 x i8]* %683, i16 0, i16 0
  %687 = alloca i8*
  store i8* %686, i8** %687
  call void @writeString(i8** %687)
  %688 = alloca [28 x i8]
  %689 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 0
  store i8 72, i8* %689
  %690 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 1
  store i8 101, i8* %690
  %691 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 2
  store i8 114, i8* %691
  %692 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 3
  store i8 101, i8* %692
  %693 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 4
  store i8 39, i8* %693
  %694 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 5
  store i8 115, i8* %694
  %695 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 6
  store i8 32, i8* %695
  %696 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 7
  store i8 121, i8* %696
  %697 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 8
  store i8 111, i8* %697
  %698 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 9
  store i8 117, i8* %698
  %699 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 10
  store i8 114, i8* %699
  %700 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 11
  store i8 32, i8* %700
  %701 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 12
  store i8 114, i8* %701
  %702 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 13
  store i8 101, i8* %702
  %703 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 14
  store i8 97, i8* %703
  %704 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 15
  store i8 108, i8* %704
  %705 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 16
  store i8 39, i8* %705
  %706 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 17
  store i8 115, i8* %706
  %707 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 18
  store i8 32, i8* %707
  %708 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 19
  store i8 97, i8* %708
  %709 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 20
  store i8 114, i8* %709
  %710 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 21
  store i8 99, i8* %710
  %711 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 22
  store i8 116, i8* %711
  %712 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 23
  store i8 97, i8* %712
  %713 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 24
  store i8 110, i8* %713
  %714 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 25
  store i8 58, i8* %714
  %715 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 26
  store i8 32, i8* %715
  %716 = getelementptr [28 x i8], [28 x i8]* %688, i16 0, i16 27
  store i8 0, i8* %716
  %717 = getelementptr inbounds [28 x i8], [28 x i8]* %688, i16 0, i16 0
  %718 = alloca i8*
  store i8* %717, i8** %718
  call void @writeString(i8** %718)
  %719 = load double, double* %9
  %720 = call double @arctan(double %719)
  call void @writeReal(double %720)
  %721 = alloca [2 x i8]
  %722 = getelementptr [2 x i8], [2 x i8]* %721, i16 0, i16 0
  store i8 10, i8* %722
  %723 = getelementptr [2 x i8], [2 x i8]* %721, i16 0, i16 1
  store i8 0, i8* %723
  %724 = getelementptr inbounds [2 x i8], [2 x i8]* %721, i16 0, i16 0
  %725 = alloca i8*
  store i8* %724, i8** %725
  call void @writeString(i8** %725)
  %726 = alloca [31 x i8]
  %727 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 0
  store i8 72, i8* %727
  %728 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 1
  store i8 101, i8* %728
  %729 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 2
  store i8 114, i8* %729
  %730 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 3
  store i8 101, i8* %730
  %731 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 4
  store i8 39, i8* %731
  %732 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 5
  store i8 115, i8* %732
  %733 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 6
  store i8 32, i8* %733
  %734 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 7
  store i8 101, i8* %734
  %735 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 8
  store i8 32, i8* %735
  %736 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 9
  store i8 114, i8* %736
  %737 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 10
  store i8 97, i8* %737
  %738 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 11
  store i8 105, i8* %738
  %739 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 12
  store i8 115, i8* %739
  %740 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 13
  store i8 101, i8* %740
  %741 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 14
  store i8 100, i8* %741
  %742 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 15
  store i8 32, i8* %742
  %743 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 16
  store i8 116, i8* %743
  %744 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 17
  store i8 111, i8* %744
  %745 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 18
  store i8 32, i8* %745
  %746 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 19
  store i8 121, i8* %746
  %747 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 20
  store i8 111, i8* %747
  %748 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 21
  store i8 117, i8* %748
  %749 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 22
  store i8 114, i8* %749
  %750 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 23
  store i8 32, i8* %750
  %751 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 24
  store i8 114, i8* %751
  %752 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 25
  store i8 101, i8* %752
  %753 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 26
  store i8 97, i8* %753
  %754 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 27
  store i8 108, i8* %754
  %755 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 28
  store i8 58, i8* %755
  %756 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 29
  store i8 32, i8* %756
  %757 = getelementptr [31 x i8], [31 x i8]* %726, i16 0, i16 30
  store i8 0, i8* %757
  %758 = getelementptr inbounds [31 x i8], [31 x i8]* %726, i16 0, i16 0
  %759 = alloca i8*
  store i8* %758, i8** %759
  call void @writeString(i8** %759)
  %760 = load double, double* %9
  %761 = call double @exp(double %760)
  call void @writeReal(double %761)
  %762 = alloca [2 x i8]
  %763 = getelementptr [2 x i8], [2 x i8]* %762, i16 0, i16 0
  store i8 10, i8* %763
  %764 = getelementptr [2 x i8], [2 x i8]* %762, i16 0, i16 1
  store i8 0, i8* %764
  %765 = getelementptr inbounds [2 x i8], [2 x i8]* %762, i16 0, i16 0
  %766 = alloca i8*
  store i8* %765, i8** %766
  call void @writeString(i8** %766)
  %767 = alloca [39 x i8]
  %768 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 0
  store i8 72, i8* %768
  %769 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 1
  store i8 101, i8* %769
  %770 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 2
  store i8 114, i8* %770
  %771 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 3
  store i8 101, i8* %771
  %772 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 4
  store i8 39, i8* %772
  %773 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 5
  store i8 115, i8* %773
  %774 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 6
  store i8 32, i8* %774
  %775 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 7
  store i8 121, i8* %775
  %776 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 8
  store i8 111, i8* %776
  %777 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 9
  store i8 117, i8* %777
  %778 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 10
  store i8 114, i8* %778
  %779 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 11
  store i8 32, i8* %779
  %780 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 12
  store i8 114, i8* %780
  %781 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 13
  store i8 101, i8* %781
  %782 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 14
  store i8 97, i8* %782
  %783 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 15
  store i8 108, i8* %783
  %784 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 16
  store i8 39, i8* %784
  %785 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 17
  store i8 115, i8* %785
  %786 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 18
  store i8 32, i8* %786
  %787 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 19
  store i8 110, i8* %787
  %788 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 20
  store i8 97, i8* %788
  %789 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 21
  store i8 116, i8* %789
  %790 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 22
  store i8 117, i8* %790
  %791 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 23
  store i8 114, i8* %791
  %792 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 24
  store i8 97, i8* %792
  %793 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 25
  store i8 108, i8* %793
  %794 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 26
  store i8 32, i8* %794
  %795 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 27
  store i8 108, i8* %795
  %796 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 28
  store i8 111, i8* %796
  %797 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 29
  store i8 103, i8* %797
  %798 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 30
  store i8 97, i8* %798
  %799 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 31
  store i8 114, i8* %799
  %800 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 32
  store i8 105, i8* %800
  %801 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 33
  store i8 116, i8* %801
  %802 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 34
  store i8 104, i8* %802
  %803 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 35
  store i8 109, i8* %803
  %804 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 36
  store i8 58, i8* %804
  %805 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 37
  store i8 32, i8* %805
  %806 = getelementptr [39 x i8], [39 x i8]* %767, i16 0, i16 38
  store i8 0, i8* %806
  %807 = getelementptr inbounds [39 x i8], [39 x i8]* %767, i16 0, i16 0
  %808 = alloca i8*
  store i8* %807, i8** %808
  call void @writeString(i8** %808)
  %809 = load double, double* %9
  %810 = call double @ln(double %809)
  call void @writeReal(double %810)
  %811 = alloca [2 x i8]
  %812 = getelementptr [2 x i8], [2 x i8]* %811, i16 0, i16 0
  store i8 10, i8* %812
  %813 = getelementptr [2 x i8], [2 x i8]* %811, i16 0, i16 1
  store i8 0, i8* %813
  %814 = getelementptr inbounds [2 x i8], [2 x i8]* %811, i16 0, i16 0
  %815 = alloca i8*
  store i8* %814, i8** %815
  call void @writeString(i8** %815)
  %816 = alloca [17 x i8]
  %817 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 0
  store i8 65, i8* %817
  %818 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 1
  store i8 110, i8* %818
  %819 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 2
  store i8 100, i8* %819
  %820 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 3
  store i8 32, i8* %820
  %821 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 4
  store i8 104, i8* %821
  %822 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 5
  store i8 101, i8* %822
  %823 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 6
  store i8 114, i8* %823
  %824 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 7
  store i8 101, i8* %824
  %825 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 8
  store i8 39, i8* %825
  %826 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 9
  store i8 115, i8* %826
  %827 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 10
  store i8 32, i8* %827
  %828 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 11
  store i8 112, i8* %828
  %829 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 12
  store i8 105, i8* %829
  %830 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 13
  store i8 33, i8* %830
  %831 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 14
  store i8 58, i8* %831
  %832 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 15
  store i8 32, i8* %832
  %833 = getelementptr [17 x i8], [17 x i8]* %816, i16 0, i16 16
  store i8 0, i8* %833
  %834 = getelementptr inbounds [17 x i8], [17 x i8]* %816, i16 0, i16 0
  %835 = alloca i8*
  store i8* %834, i8** %835
  call void @writeString(i8** %835)
  %836 = call double @pi()
  call void @writeReal(double %836)
  %837 = alloca [2 x i8]
  %838 = getelementptr [2 x i8], [2 x i8]* %837, i16 0, i16 0
  store i8 10, i8* %838
  %839 = getelementptr [2 x i8], [2 x i8]* %837, i16 0, i16 1
  store i8 0, i8* %839
  %840 = getelementptr inbounds [2 x i8], [2 x i8]* %837, i16 0, i16 0
  %841 = alloca i8*
  store i8* %840, i8** %841
  call void @writeString(i8** %841)
  %842 = alloca [29 x i8]
  %843 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 0
  store i8 72, i8* %843
  %844 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 1
  store i8 101, i8* %844
  %845 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 2
  store i8 114, i8* %845
  %846 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 3
  store i8 101, i8* %846
  %847 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 4
  store i8 39, i8* %847
  %848 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 5
  store i8 115, i8* %848
  %849 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 6
  store i8 32, i8* %849
  %850 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 7
  store i8 121, i8* %850
  %851 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 8
  store i8 111, i8* %851
  %852 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 9
  store i8 117, i8* %852
  %853 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 10
  store i8 114, i8* %853
  %854 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 11
  store i8 32, i8* %854
  %855 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 12
  store i8 114, i8* %855
  %856 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 13
  store i8 101, i8* %856
  %857 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 14
  store i8 97, i8* %857
  %858 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 15
  store i8 108, i8* %858
  %859 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 16
  store i8 32, i8* %859
  %860 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 17
  store i8 116, i8* %860
  %861 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 18
  store i8 114, i8* %861
  %862 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 19
  store i8 117, i8* %862
  %863 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 20
  store i8 110, i8* %863
  %864 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 21
  store i8 99, i8* %864
  %865 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 22
  store i8 97, i8* %865
  %866 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 23
  store i8 116, i8* %866
  %867 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 24
  store i8 101, i8* %867
  %868 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 25
  store i8 100, i8* %868
  %869 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 26
  store i8 58, i8* %869
  %870 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 27
  store i8 32, i8* %870
  %871 = getelementptr [29 x i8], [29 x i8]* %842, i16 0, i16 28
  store i8 0, i8* %871
  %872 = getelementptr inbounds [29 x i8], [29 x i8]* %842, i16 0, i16 0
  %873 = alloca i8*
  store i8* %872, i8** %873
  call void @writeString(i8** %873)
  %874 = load double, double* %9
  %875 = call i16 @trunc(double %874)
  call void @writeInteger(i16 %875)
  %876 = alloca [2 x i8]
  %877 = getelementptr [2 x i8], [2 x i8]* %876, i16 0, i16 0
  store i8 10, i8* %877
  %878 = getelementptr [2 x i8], [2 x i8]* %876, i16 0, i16 1
  store i8 0, i8* %878
  %879 = getelementptr inbounds [2 x i8], [2 x i8]* %876, i16 0, i16 0
  %880 = alloca i8*
  store i8* %879, i8** %880
  call void @writeString(i8** %880)
  %881 = alloca [27 x i8]
  %882 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 0
  store i8 72, i8* %882
  %883 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 1
  store i8 101, i8* %883
  %884 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 2
  store i8 114, i8* %884
  %885 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 3
  store i8 101, i8* %885
  %886 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 4
  store i8 39, i8* %886
  %887 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 5
  store i8 115, i8* %887
  %888 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 6
  store i8 32, i8* %888
  %889 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 7
  store i8 121, i8* %889
  %890 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 8
  store i8 111, i8* %890
  %891 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 9
  store i8 117, i8* %891
  %892 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 10
  store i8 114, i8* %892
  %893 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 11
  store i8 32, i8* %893
  %894 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 12
  store i8 114, i8* %894
  %895 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 13
  store i8 101, i8* %895
  %896 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 14
  store i8 97, i8* %896
  %897 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 15
  store i8 108, i8* %897
  %898 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 16
  store i8 32, i8* %898
  %899 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 17
  store i8 114, i8* %899
  %900 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 18
  store i8 111, i8* %900
  %901 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 19
  store i8 117, i8* %901
  %902 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 20
  store i8 110, i8* %902
  %903 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 21
  store i8 100, i8* %903
  %904 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 22
  store i8 101, i8* %904
  %905 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 23
  store i8 100, i8* %905
  %906 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 24
  store i8 58, i8* %906
  %907 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 25
  store i8 32, i8* %907
  %908 = getelementptr [27 x i8], [27 x i8]* %881, i16 0, i16 26
  store i8 0, i8* %908
  %909 = getelementptr inbounds [27 x i8], [27 x i8]* %881, i16 0, i16 0
  %910 = alloca i8*
  store i8* %909, i8** %910
  call void @writeString(i8** %910)
  %911 = load double, double* %9
  %912 = call i16 @round(double %911)
  call void @writeInteger(i16 %912)
  %913 = alloca [2 x i8]
  %914 = getelementptr [2 x i8], [2 x i8]* %913, i16 0, i16 0
  store i8 10, i8* %914
  %915 = getelementptr [2 x i8], [2 x i8]* %913, i16 0, i16 1
  store i8 0, i8* %915
  %916 = getelementptr inbounds [2 x i8], [2 x i8]* %913, i16 0, i16 0
  %917 = alloca i8*
  store i8* %916, i8** %917
  call void @writeString(i8** %917)
  %918 = alloca [17 x i8]
  %919 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 0
  store i8 71, i8* %919
  %920 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 1
  store i8 105, i8* %920
  %921 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 2
  store i8 118, i8* %921
  %922 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 3
  store i8 101, i8* %922
  %923 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 4
  store i8 32, i8* %923
  %924 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 5
  store i8 109, i8* %924
  %925 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 6
  store i8 101, i8* %925
  %926 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 7
  store i8 32, i8* %926
  %927 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 8
  store i8 97, i8* %927
  %928 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 9
  store i8 32, i8* %928
  %929 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 10
  store i8 99, i8* %929
  %930 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 11
  store i8 104, i8* %930
  %931 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 12
  store i8 97, i8* %931
  %932 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 13
  store i8 114, i8* %932
  %933 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 14
  store i8 58, i8* %933
  %934 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 15
  store i8 32, i8* %934
  %935 = getelementptr [17 x i8], [17 x i8]* %918, i16 0, i16 16
  store i8 0, i8* %935
  %936 = getelementptr inbounds [17 x i8], [17 x i8]* %918, i16 0, i16 0
  %937 = alloca i8*
  store i8* %936, i8** %937
  call void @writeString(i8** %937)
  %938 = call i8 @readChar()
  store i8 %938, i8* %6
  %939 = alloca [19 x i8]
  %940 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 0
  store i8 72, i8* %940
  %941 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 1
  store i8 101, i8* %941
  %942 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 2
  store i8 114, i8* %942
  %943 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 3
  store i8 101, i8* %943
  %944 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 4
  store i8 39, i8* %944
  %945 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 5
  store i8 115, i8* %945
  %946 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 6
  store i8 32, i8* %946
  %947 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 7
  store i8 121, i8* %947
  %948 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 8
  store i8 111, i8* %948
  %949 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 9
  store i8 117, i8* %949
  %950 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 10
  store i8 114, i8* %950
  %951 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 11
  store i8 32, i8* %951
  %952 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 12
  store i8 99, i8* %952
  %953 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 13
  store i8 104, i8* %953
  %954 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 14
  store i8 97, i8* %954
  %955 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 15
  store i8 114, i8* %955
  %956 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 16
  store i8 58, i8* %956
  %957 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 17
  store i8 32, i8* %957
  %958 = getelementptr [19 x i8], [19 x i8]* %939, i16 0, i16 18
  store i8 0, i8* %958
  %959 = getelementptr inbounds [19 x i8], [19 x i8]* %939, i16 0, i16 0
  %960 = alloca i8*
  store i8* %959, i8** %960
  call void @writeString(i8** %960)
  %961 = load i8, i8* %6
  call void @writeChar(i8 %961)
  %962 = alloca [2 x i8]
  %963 = getelementptr [2 x i8], [2 x i8]* %962, i16 0, i16 0
  store i8 10, i8* %963
  %964 = getelementptr [2 x i8], [2 x i8]* %962, i16 0, i16 1
  store i8 0, i8* %964
  %965 = getelementptr inbounds [2 x i8], [2 x i8]* %962, i16 0, i16 0
  %966 = alloca i8*
  store i8* %965, i8** %966
  call void @writeString(i8** %966)
  %967 = alloca [32 x i8]
  %968 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 0
  store i8 72, i8* %968
  %969 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 1
  store i8 101, i8* %969
  %970 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 2
  store i8 114, i8* %970
  %971 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 3
  store i8 101, i8* %971
  %972 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 4
  store i8 39, i8* %972
  %973 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 5
  store i8 115, i8* %973
  %974 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 6
  store i8 32, i8* %974
  %975 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 7
  store i8 121, i8* %975
  %976 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 8
  store i8 111, i8* %976
  %977 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 9
  store i8 117, i8* %977
  %978 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 10
  store i8 114, i8* %978
  %979 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 11
  store i8 32, i8* %979
  %980 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 12
  store i8 99, i8* %980
  %981 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 13
  store i8 104, i8* %981
  %982 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 14
  store i8 97, i8* %982
  %983 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 15
  store i8 114, i8* %983
  %984 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 16
  store i8 39, i8* %984
  %985 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 17
  store i8 115, i8* %985
  %986 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 18
  store i8 32, i8* %986
  %987 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 19
  store i8 65, i8* %987
  %988 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 20
  store i8 83, i8* %988
  %989 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 21
  store i8 67, i8* %989
  %990 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 22
  store i8 73, i8* %990
  %991 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 23
  store i8 73, i8* %991
  %992 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 24
  store i8 32, i8* %992
  %993 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 25
  store i8 99, i8* %993
  %994 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 26
  store i8 111, i8* %994
  %995 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 27
  store i8 100, i8* %995
  %996 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 28
  store i8 101, i8* %996
  %997 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 29
  store i8 58, i8* %997
  %998 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 30
  store i8 32, i8* %998
  %999 = getelementptr [32 x i8], [32 x i8]* %967, i16 0, i16 31
  store i8 0, i8* %999
  %1000 = getelementptr inbounds [32 x i8], [32 x i8]* %967, i16 0, i16 0
  %1001 = alloca i8*
  store i8* %1000, i8** %1001
  call void @writeString(i8** %1001)
  %1002 = load i8, i8* %6
  %1003 = call i16 @ord(i8 %1002)
  call void @writeInteger(i16 %1003)
  %1004 = alloca [2 x i8]
  %1005 = getelementptr [2 x i8], [2 x i8]* %1004, i16 0, i16 0
  store i8 10, i8* %1005
  %1006 = getelementptr [2 x i8], [2 x i8]* %1004, i16 0, i16 1
  store i8 0, i8* %1006
  %1007 = getelementptr inbounds [2 x i8], [2 x i8]* %1004, i16 0, i16 0
  %1008 = alloca i8*
  store i8* %1007, i8** %1008
  call void @writeString(i8** %1008)
  %1009 = alloca [21 x i8]
  %1010 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 0
  store i8 71, i8* %1010
  %1011 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 1
  store i8 105, i8* %1011
  %1012 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 2
  store i8 118, i8* %1012
  %1013 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 3
  store i8 101, i8* %1013
  %1014 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 4
  store i8 32, i8* %1014
  %1015 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 5
  store i8 109, i8* %1015
  %1016 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 6
  store i8 101, i8* %1016
  %1017 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 7
  store i8 32, i8* %1017
  %1018 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 8
  store i8 97, i8* %1018
  %1019 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 9
  store i8 110, i8* %1019
  %1020 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 10
  store i8 32, i8* %1020
  %1021 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 11
  store i8 105, i8* %1021
  %1022 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 12
  store i8 110, i8* %1022
  %1023 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 13
  store i8 116, i8* %1023
  %1024 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 14
  store i8 101, i8* %1024
  %1025 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 15
  store i8 103, i8* %1025
  %1026 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 16
  store i8 101, i8* %1026
  %1027 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 17
  store i8 114, i8* %1027
  %1028 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 18
  store i8 58, i8* %1028
  %1029 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 19
  store i8 32, i8* %1029
  %1030 = getelementptr [21 x i8], [21 x i8]* %1009, i16 0, i16 20
  store i8 0, i8* %1030
  %1031 = getelementptr inbounds [21 x i8], [21 x i8]* %1009, i16 0, i16 0
  %1032 = alloca i8*
  store i8* %1031, i8** %1032
  call void @writeString(i8** %1032)
  %1033 = call i16 @readInteger()
  store i16 %1033, i16* %1
  %1034 = alloca [26 x i8]
  %1035 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 0
  store i8 71, i8* %1035
  %1036 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 1
  store i8 105, i8* %1036
  %1037 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 2
  store i8 118, i8* %1037
  %1038 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 3
  store i8 101, i8* %1038
  %1039 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 4
  store i8 32, i8* %1039
  %1040 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 5
  store i8 109, i8* %1040
  %1041 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 6
  store i8 101, i8* %1041
  %1042 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 7
  store i8 32, i8* %1042
  %1043 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 8
  store i8 97, i8* %1043
  %1044 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 9
  store i8 110, i8* %1044
  %1045 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 10
  store i8 111, i8* %1045
  %1046 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 11
  store i8 116, i8* %1046
  %1047 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 12
  store i8 104, i8* %1047
  %1048 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 13
  store i8 101, i8* %1048
  %1049 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 14
  store i8 114, i8* %1049
  %1050 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 15
  store i8 32, i8* %1050
  %1051 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 16
  store i8 105, i8* %1051
  %1052 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 17
  store i8 110, i8* %1052
  %1053 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 18
  store i8 116, i8* %1053
  %1054 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 19
  store i8 101, i8* %1054
  %1055 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 20
  store i8 103, i8* %1055
  %1056 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 21
  store i8 101, i8* %1056
  %1057 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 22
  store i8 114, i8* %1057
  %1058 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 23
  store i8 58, i8* %1058
  %1059 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 24
  store i8 32, i8* %1059
  %1060 = getelementptr [26 x i8], [26 x i8]* %1034, i16 0, i16 25
  store i8 0, i8* %1060
  %1061 = getelementptr inbounds [26 x i8], [26 x i8]* %1034, i16 0, i16 0
  %1062 = alloca i8*
  store i8* %1061, i8** %1062
  call void @writeString(i8** %1062)
  %1063 = call i16 @readInteger()
  store i16 %1063, i16* %2
  %1064 = alloca [43 x i8]
  %1065 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 0
  store i8 72, i8* %1065
  %1066 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 1
  store i8 101, i8* %1066
  %1067 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 2
  store i8 114, i8* %1067
  %1068 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 3
  store i8 101, i8* %1068
  %1069 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 4
  store i8 39, i8* %1069
  %1070 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 5
  store i8 115, i8* %1070
  %1071 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 6
  store i8 32, i8* %1071
  %1072 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 7
  store i8 121, i8* %1072
  %1073 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 8
  store i8 111, i8* %1073
  %1074 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 9
  store i8 117, i8* %1074
  %1075 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 10
  store i8 114, i8* %1075
  %1076 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 11
  store i8 32, i8* %1076
  %1077 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 12
  store i8 105, i8* %1077
  %1078 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 13
  store i8 110, i8* %1078
  %1079 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 14
  store i8 116, i8* %1079
  %1080 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 15
  store i8 101, i8* %1080
  %1081 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 16
  store i8 103, i8* %1081
  %1082 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 17
  store i8 101, i8* %1082
  %1083 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 18
  store i8 114, i8* %1083
  %1084 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 19
  store i8 32, i8* %1084
  %1085 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 20
  store i8 43, i8* %1085
  %1086 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 21
  store i8 32, i8* %1086
  %1087 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 22
  store i8 121, i8* %1087
  %1088 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 23
  store i8 111, i8* %1088
  %1089 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 24
  store i8 117, i8* %1089
  %1090 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 25
  store i8 114, i8* %1090
  %1091 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 26
  store i8 32, i8* %1091
  %1092 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 27
  store i8 111, i8* %1092
  %1093 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 28
  store i8 116, i8* %1093
  %1094 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 29
  store i8 104, i8* %1094
  %1095 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 30
  store i8 101, i8* %1095
  %1096 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 31
  store i8 114, i8* %1096
  %1097 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 32
  store i8 32, i8* %1097
  %1098 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 33
  store i8 105, i8* %1098
  %1099 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 34
  store i8 110, i8* %1099
  %1100 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 35
  store i8 116, i8* %1100
  %1101 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 36
  store i8 101, i8* %1101
  %1102 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 37
  store i8 103, i8* %1102
  %1103 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 38
  store i8 101, i8* %1103
  %1104 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 39
  store i8 114, i8* %1104
  %1105 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 40
  store i8 58, i8* %1105
  %1106 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 41
  store i8 32, i8* %1106
  %1107 = getelementptr [43 x i8], [43 x i8]* %1064, i16 0, i16 42
  store i8 0, i8* %1107
  %1108 = getelementptr inbounds [43 x i8], [43 x i8]* %1064, i16 0, i16 0
  %1109 = alloca i8*
  store i8* %1108, i8** %1109
  call void @writeString(i8** %1109)
  %1110 = load i16, i16* %1
  %1111 = load i16, i16* %2
  %1112 = add i16 %1110, %1111
  call void @writeInteger(i16 %1112)
  %1113 = alloca [2 x i8]
  %1114 = getelementptr [2 x i8], [2 x i8]* %1113, i16 0, i16 0
  store i8 10, i8* %1114
  %1115 = getelementptr [2 x i8], [2 x i8]* %1113, i16 0, i16 1
  store i8 0, i8* %1115
  %1116 = getelementptr inbounds [2 x i8], [2 x i8]* %1113, i16 0, i16 0
  %1117 = alloca i8*
  store i8* %1116, i8** %1117
  call void @writeString(i8** %1117)
  %1118 = alloca [43 x i8]
  %1119 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 0
  store i8 72, i8* %1119
  %1120 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 1
  store i8 101, i8* %1120
  %1121 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 2
  store i8 114, i8* %1121
  %1122 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 3
  store i8 101, i8* %1122
  %1123 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 4
  store i8 39, i8* %1123
  %1124 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 5
  store i8 115, i8* %1124
  %1125 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 6
  store i8 32, i8* %1125
  %1126 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 7
  store i8 121, i8* %1126
  %1127 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 8
  store i8 111, i8* %1127
  %1128 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 9
  store i8 117, i8* %1128
  %1129 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 10
  store i8 114, i8* %1129
  %1130 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 11
  store i8 32, i8* %1130
  %1131 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 12
  store i8 105, i8* %1131
  %1132 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 13
  store i8 110, i8* %1132
  %1133 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 14
  store i8 116, i8* %1133
  %1134 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 15
  store i8 101, i8* %1134
  %1135 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 16
  store i8 103, i8* %1135
  %1136 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 17
  store i8 101, i8* %1136
  %1137 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 18
  store i8 114, i8* %1137
  %1138 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 19
  store i8 32, i8* %1138
  %1139 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 20
  store i8 42, i8* %1139
  %1140 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 21
  store i8 32, i8* %1140
  %1141 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 22
  store i8 121, i8* %1141
  %1142 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 23
  store i8 111, i8* %1142
  %1143 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 24
  store i8 117, i8* %1143
  %1144 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 25
  store i8 114, i8* %1144
  %1145 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 26
  store i8 32, i8* %1145
  %1146 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 27
  store i8 111, i8* %1146
  %1147 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 28
  store i8 116, i8* %1147
  %1148 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 29
  store i8 104, i8* %1148
  %1149 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 30
  store i8 101, i8* %1149
  %1150 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 31
  store i8 114, i8* %1150
  %1151 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 32
  store i8 32, i8* %1151
  %1152 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 33
  store i8 105, i8* %1152
  %1153 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 34
  store i8 110, i8* %1153
  %1154 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 35
  store i8 116, i8* %1154
  %1155 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 36
  store i8 101, i8* %1155
  %1156 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 37
  store i8 103, i8* %1156
  %1157 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 38
  store i8 101, i8* %1157
  %1158 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 39
  store i8 114, i8* %1158
  %1159 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 40
  store i8 58, i8* %1159
  %1160 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 41
  store i8 32, i8* %1160
  %1161 = getelementptr [43 x i8], [43 x i8]* %1118, i16 0, i16 42
  store i8 0, i8* %1161
  %1162 = getelementptr inbounds [43 x i8], [43 x i8]* %1118, i16 0, i16 0
  %1163 = alloca i8*
  store i8* %1162, i8** %1163
  call void @writeString(i8** %1163)
  %1164 = load i16, i16* %1
  %1165 = load i16, i16* %2
  %1166 = mul i16 %1164, %1165
  call void @writeInteger(i16 %1166)
  %1167 = alloca [2 x i8]
  %1168 = getelementptr [2 x i8], [2 x i8]* %1167, i16 0, i16 0
  store i8 10, i8* %1168
  %1169 = getelementptr [2 x i8], [2 x i8]* %1167, i16 0, i16 1
  store i8 0, i8* %1169
  %1170 = getelementptr inbounds [2 x i8], [2 x i8]* %1167, i16 0, i16 0
  %1171 = alloca i8*
  store i8* %1170, i8** %1171
  call void @writeString(i8** %1171)
  %1172 = alloca [43 x i8]
  %1173 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 0
  store i8 72, i8* %1173
  %1174 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 1
  store i8 101, i8* %1174
  %1175 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 2
  store i8 114, i8* %1175
  %1176 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 3
  store i8 101, i8* %1176
  %1177 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 4
  store i8 39, i8* %1177
  %1178 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 5
  store i8 115, i8* %1178
  %1179 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 6
  store i8 32, i8* %1179
  %1180 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 7
  store i8 121, i8* %1180
  %1181 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 8
  store i8 111, i8* %1181
  %1182 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 9
  store i8 117, i8* %1182
  %1183 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 10
  store i8 114, i8* %1183
  %1184 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 11
  store i8 32, i8* %1184
  %1185 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 12
  store i8 105, i8* %1185
  %1186 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 13
  store i8 110, i8* %1186
  %1187 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 14
  store i8 116, i8* %1187
  %1188 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 15
  store i8 101, i8* %1188
  %1189 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 16
  store i8 103, i8* %1189
  %1190 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 17
  store i8 101, i8* %1190
  %1191 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 18
  store i8 114, i8* %1191
  %1192 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 19
  store i8 32, i8* %1192
  %1193 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 20
  store i8 45, i8* %1193
  %1194 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 21
  store i8 32, i8* %1194
  %1195 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 22
  store i8 121, i8* %1195
  %1196 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 23
  store i8 111, i8* %1196
  %1197 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 24
  store i8 117, i8* %1197
  %1198 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 25
  store i8 114, i8* %1198
  %1199 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 26
  store i8 32, i8* %1199
  %1200 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 27
  store i8 111, i8* %1200
  %1201 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 28
  store i8 116, i8* %1201
  %1202 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 29
  store i8 104, i8* %1202
  %1203 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 30
  store i8 101, i8* %1203
  %1204 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 31
  store i8 114, i8* %1204
  %1205 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 32
  store i8 32, i8* %1205
  %1206 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 33
  store i8 105, i8* %1206
  %1207 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 34
  store i8 110, i8* %1207
  %1208 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 35
  store i8 116, i8* %1208
  %1209 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 36
  store i8 101, i8* %1209
  %1210 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 37
  store i8 103, i8* %1210
  %1211 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 38
  store i8 101, i8* %1211
  %1212 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 39
  store i8 114, i8* %1212
  %1213 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 40
  store i8 58, i8* %1213
  %1214 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 41
  store i8 32, i8* %1214
  %1215 = getelementptr [43 x i8], [43 x i8]* %1172, i16 0, i16 42
  store i8 0, i8* %1215
  %1216 = getelementptr inbounds [43 x i8], [43 x i8]* %1172, i16 0, i16 0
  %1217 = alloca i8*
  store i8* %1216, i8** %1217
  call void @writeString(i8** %1217)
  %1218 = load i16, i16* %1
  %1219 = load i16, i16* %2
  %1220 = sub i16 %1218, %1219
  call void @writeInteger(i16 %1220)
  %1221 = alloca [2 x i8]
  %1222 = getelementptr [2 x i8], [2 x i8]* %1221, i16 0, i16 0
  store i8 10, i8* %1222
  %1223 = getelementptr [2 x i8], [2 x i8]* %1221, i16 0, i16 1
  store i8 0, i8* %1223
  %1224 = getelementptr inbounds [2 x i8], [2 x i8]* %1221, i16 0, i16 0
  %1225 = alloca i8*
  store i8* %1224, i8** %1225
  call void @writeString(i8** %1225)
  %1226 = alloca [43 x i8]
  %1227 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 0
  store i8 72, i8* %1227
  %1228 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 1
  store i8 101, i8* %1228
  %1229 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 2
  store i8 114, i8* %1229
  %1230 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 3
  store i8 101, i8* %1230
  %1231 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 4
  store i8 39, i8* %1231
  %1232 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 5
  store i8 115, i8* %1232
  %1233 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 6
  store i8 32, i8* %1233
  %1234 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 7
  store i8 121, i8* %1234
  %1235 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 8
  store i8 111, i8* %1235
  %1236 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 9
  store i8 117, i8* %1236
  %1237 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 10
  store i8 114, i8* %1237
  %1238 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 11
  store i8 32, i8* %1238
  %1239 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 12
  store i8 105, i8* %1239
  %1240 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 13
  store i8 110, i8* %1240
  %1241 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 14
  store i8 116, i8* %1241
  %1242 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 15
  store i8 101, i8* %1242
  %1243 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 16
  store i8 103, i8* %1243
  %1244 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 17
  store i8 101, i8* %1244
  %1245 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 18
  store i8 114, i8* %1245
  %1246 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 19
  store i8 32, i8* %1246
  %1247 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 20
  store i8 47, i8* %1247
  %1248 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 21
  store i8 32, i8* %1248
  %1249 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 22
  store i8 121, i8* %1249
  %1250 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 23
  store i8 111, i8* %1250
  %1251 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 24
  store i8 117, i8* %1251
  %1252 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 25
  store i8 114, i8* %1252
  %1253 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 26
  store i8 32, i8* %1253
  %1254 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 27
  store i8 111, i8* %1254
  %1255 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 28
  store i8 116, i8* %1255
  %1256 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 29
  store i8 104, i8* %1256
  %1257 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 30
  store i8 101, i8* %1257
  %1258 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 31
  store i8 114, i8* %1258
  %1259 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 32
  store i8 32, i8* %1259
  %1260 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 33
  store i8 105, i8* %1260
  %1261 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 34
  store i8 110, i8* %1261
  %1262 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 35
  store i8 116, i8* %1262
  %1263 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 36
  store i8 101, i8* %1263
  %1264 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 37
  store i8 103, i8* %1264
  %1265 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 38
  store i8 101, i8* %1265
  %1266 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 39
  store i8 114, i8* %1266
  %1267 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 40
  store i8 58, i8* %1267
  %1268 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 41
  store i8 32, i8* %1268
  %1269 = getelementptr [43 x i8], [43 x i8]* %1226, i16 0, i16 42
  store i8 0, i8* %1269
  %1270 = getelementptr inbounds [43 x i8], [43 x i8]* %1226, i16 0, i16 0
  %1271 = alloca i8*
  store i8* %1270, i8** %1271
  call void @writeString(i8** %1271)
  %1272 = load i16, i16* %1
  %1273 = load i16, i16* %2
  %1274 = sitofp i16 %1272 to double
  %1275 = sitofp i16 %1273 to double
  %1276 = fdiv double %1274, %1275
  call void @writeReal(double %1276)
  %1277 = alloca [2 x i8]
  %1278 = getelementptr [2 x i8], [2 x i8]* %1277, i16 0, i16 0
  store i8 10, i8* %1278
  %1279 = getelementptr [2 x i8], [2 x i8]* %1277, i16 0, i16 1
  store i8 0, i8* %1279
  %1280 = getelementptr inbounds [2 x i8], [2 x i8]* %1277, i16 0, i16 0
  %1281 = alloca i8*
  store i8* %1280, i8** %1281
  call void @writeString(i8** %1281)
  %1282 = alloca [45 x i8]
  %1283 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 0
  store i8 72, i8* %1283
  %1284 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 1
  store i8 101, i8* %1284
  %1285 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 2
  store i8 114, i8* %1285
  %1286 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 3
  store i8 101, i8* %1286
  %1287 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 4
  store i8 39, i8* %1287
  %1288 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 5
  store i8 115, i8* %1288
  %1289 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 6
  store i8 32, i8* %1289
  %1290 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 7
  store i8 121, i8* %1290
  %1291 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 8
  store i8 111, i8* %1291
  %1292 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 9
  store i8 117, i8* %1292
  %1293 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 10
  store i8 114, i8* %1293
  %1294 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 11
  store i8 32, i8* %1294
  %1295 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 12
  store i8 105, i8* %1295
  %1296 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 13
  store i8 110, i8* %1296
  %1297 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 14
  store i8 116, i8* %1297
  %1298 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 15
  store i8 101, i8* %1298
  %1299 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 16
  store i8 103, i8* %1299
  %1300 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 17
  store i8 101, i8* %1300
  %1301 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 18
  store i8 114, i8* %1301
  %1302 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 19
  store i8 32, i8* %1302
  %1303 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 20
  store i8 100, i8* %1303
  %1304 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 21
  store i8 105, i8* %1304
  %1305 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 22
  store i8 118, i8* %1305
  %1306 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 23
  store i8 32, i8* %1306
  %1307 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 24
  store i8 121, i8* %1307
  %1308 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 25
  store i8 111, i8* %1308
  %1309 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 26
  store i8 117, i8* %1309
  %1310 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 27
  store i8 114, i8* %1310
  %1311 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 28
  store i8 32, i8* %1311
  %1312 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 29
  store i8 111, i8* %1312
  %1313 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 30
  store i8 116, i8* %1313
  %1314 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 31
  store i8 104, i8* %1314
  %1315 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 32
  store i8 101, i8* %1315
  %1316 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 33
  store i8 114, i8* %1316
  %1317 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 34
  store i8 32, i8* %1317
  %1318 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 35
  store i8 105, i8* %1318
  %1319 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 36
  store i8 110, i8* %1319
  %1320 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 37
  store i8 116, i8* %1320
  %1321 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 38
  store i8 101, i8* %1321
  %1322 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 39
  store i8 103, i8* %1322
  %1323 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 40
  store i8 101, i8* %1323
  %1324 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 41
  store i8 114, i8* %1324
  %1325 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 42
  store i8 58, i8* %1325
  %1326 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 43
  store i8 32, i8* %1326
  %1327 = getelementptr [45 x i8], [45 x i8]* %1282, i16 0, i16 44
  store i8 0, i8* %1327
  %1328 = getelementptr inbounds [45 x i8], [45 x i8]* %1282, i16 0, i16 0
  %1329 = alloca i8*
  store i8* %1328, i8** %1329
  call void @writeString(i8** %1329)
  %1330 = load i16, i16* %1
  %1331 = load i16, i16* %2
  %1332 = sdiv i16 %1330, %1331
  call void @writeInteger(i16 %1332)
  %1333 = alloca [2 x i8]
  %1334 = getelementptr [2 x i8], [2 x i8]* %1333, i16 0, i16 0
  store i8 10, i8* %1334
  %1335 = getelementptr [2 x i8], [2 x i8]* %1333, i16 0, i16 1
  store i8 0, i8* %1335
  %1336 = getelementptr inbounds [2 x i8], [2 x i8]* %1333, i16 0, i16 0
  %1337 = alloca i8*
  store i8* %1336, i8** %1337
  call void @writeString(i8** %1337)
  %1338 = alloca [45 x i8]
  %1339 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 0
  store i8 72, i8* %1339
  %1340 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 1
  store i8 101, i8* %1340
  %1341 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 2
  store i8 114, i8* %1341
  %1342 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 3
  store i8 101, i8* %1342
  %1343 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 4
  store i8 39, i8* %1343
  %1344 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 5
  store i8 115, i8* %1344
  %1345 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 6
  store i8 32, i8* %1345
  %1346 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 7
  store i8 121, i8* %1346
  %1347 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 8
  store i8 111, i8* %1347
  %1348 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 9
  store i8 117, i8* %1348
  %1349 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 10
  store i8 114, i8* %1349
  %1350 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 11
  store i8 32, i8* %1350
  %1351 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 12
  store i8 105, i8* %1351
  %1352 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 13
  store i8 110, i8* %1352
  %1353 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 14
  store i8 116, i8* %1353
  %1354 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 15
  store i8 101, i8* %1354
  %1355 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 16
  store i8 103, i8* %1355
  %1356 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 17
  store i8 101, i8* %1356
  %1357 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 18
  store i8 114, i8* %1357
  %1358 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 19
  store i8 32, i8* %1358
  %1359 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 20
  store i8 109, i8* %1359
  %1360 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 21
  store i8 111, i8* %1360
  %1361 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 22
  store i8 100, i8* %1361
  %1362 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 23
  store i8 32, i8* %1362
  %1363 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 24
  store i8 121, i8* %1363
  %1364 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 25
  store i8 111, i8* %1364
  %1365 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 26
  store i8 117, i8* %1365
  %1366 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 27
  store i8 114, i8* %1366
  %1367 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 28
  store i8 32, i8* %1367
  %1368 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 29
  store i8 111, i8* %1368
  %1369 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 30
  store i8 116, i8* %1369
  %1370 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 31
  store i8 104, i8* %1370
  %1371 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 32
  store i8 101, i8* %1371
  %1372 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 33
  store i8 114, i8* %1372
  %1373 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 34
  store i8 32, i8* %1373
  %1374 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 35
  store i8 105, i8* %1374
  %1375 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 36
  store i8 110, i8* %1375
  %1376 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 37
  store i8 116, i8* %1376
  %1377 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 38
  store i8 101, i8* %1377
  %1378 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 39
  store i8 103, i8* %1378
  %1379 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 40
  store i8 101, i8* %1379
  %1380 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 41
  store i8 114, i8* %1380
  %1381 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 42
  store i8 58, i8* %1381
  %1382 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 43
  store i8 32, i8* %1382
  %1383 = getelementptr [45 x i8], [45 x i8]* %1338, i16 0, i16 44
  store i8 0, i8* %1383
  %1384 = getelementptr inbounds [45 x i8], [45 x i8]* %1338, i16 0, i16 0
  %1385 = alloca i8*
  store i8* %1384, i8** %1385
  call void @writeString(i8** %1385)
  %1386 = load i16, i16* %1
  %1387 = load i16, i16* %2
  %1388 = srem i16 %1386, %1387
  call void @writeInteger(i16 %1388)
  %1389 = alloca [2 x i8]
  %1390 = getelementptr [2 x i8], [2 x i8]* %1389, i16 0, i16 0
  store i8 10, i8* %1390
  %1391 = getelementptr [2 x i8], [2 x i8]* %1389, i16 0, i16 1
  store i8 0, i8* %1391
  %1392 = getelementptr inbounds [2 x i8], [2 x i8]* %1389, i16 0, i16 0
  %1393 = alloca i8*
  store i8* %1392, i8** %1393
  call void @writeString(i8** %1393)
  %1394 = alloca [43 x i8]
  %1395 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 0
  store i8 72, i8* %1395
  %1396 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 1
  store i8 101, i8* %1396
  %1397 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 2
  store i8 114, i8* %1397
  %1398 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 3
  store i8 101, i8* %1398
  %1399 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 4
  store i8 39, i8* %1399
  %1400 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 5
  store i8 115, i8* %1400
  %1401 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 6
  store i8 32, i8* %1401
  %1402 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 7
  store i8 121, i8* %1402
  %1403 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 8
  store i8 111, i8* %1403
  %1404 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 9
  store i8 117, i8* %1404
  %1405 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 10
  store i8 114, i8* %1405
  %1406 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 11
  store i8 32, i8* %1406
  %1407 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 12
  store i8 105, i8* %1407
  %1408 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 13
  store i8 110, i8* %1408
  %1409 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 14
  store i8 116, i8* %1409
  %1410 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 15
  store i8 101, i8* %1410
  %1411 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 16
  store i8 103, i8* %1411
  %1412 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 17
  store i8 101, i8* %1412
  %1413 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 18
  store i8 114, i8* %1413
  %1414 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 19
  store i8 32, i8* %1414
  %1415 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 20
  store i8 60, i8* %1415
  %1416 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 21
  store i8 32, i8* %1416
  %1417 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 22
  store i8 121, i8* %1417
  %1418 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 23
  store i8 111, i8* %1418
  %1419 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 24
  store i8 117, i8* %1419
  %1420 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 25
  store i8 114, i8* %1420
  %1421 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 26
  store i8 32, i8* %1421
  %1422 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 27
  store i8 111, i8* %1422
  %1423 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 28
  store i8 116, i8* %1423
  %1424 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 29
  store i8 104, i8* %1424
  %1425 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 30
  store i8 101, i8* %1425
  %1426 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 31
  store i8 114, i8* %1426
  %1427 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 32
  store i8 32, i8* %1427
  %1428 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 33
  store i8 105, i8* %1428
  %1429 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 34
  store i8 110, i8* %1429
  %1430 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 35
  store i8 116, i8* %1430
  %1431 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 36
  store i8 101, i8* %1431
  %1432 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 37
  store i8 103, i8* %1432
  %1433 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 38
  store i8 101, i8* %1433
  %1434 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 39
  store i8 114, i8* %1434
  %1435 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 40
  store i8 58, i8* %1435
  %1436 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 41
  store i8 32, i8* %1436
  %1437 = getelementptr [43 x i8], [43 x i8]* %1394, i16 0, i16 42
  store i8 0, i8* %1437
  %1438 = getelementptr inbounds [43 x i8], [43 x i8]* %1394, i16 0, i16 0
  %1439 = alloca i8*
  store i8* %1438, i8** %1439
  call void @writeString(i8** %1439)
  %1440 = load i16, i16* %1
  %1441 = load i16, i16* %2
  %1442 = icmp slt i16 %1440, %1441
  call void @writeBoolean(i1 %1442)
  %1443 = alloca [2 x i8]
  %1444 = getelementptr [2 x i8], [2 x i8]* %1443, i16 0, i16 0
  store i8 10, i8* %1444
  %1445 = getelementptr [2 x i8], [2 x i8]* %1443, i16 0, i16 1
  store i8 0, i8* %1445
  %1446 = getelementptr inbounds [2 x i8], [2 x i8]* %1443, i16 0, i16 0
  %1447 = alloca i8*
  store i8* %1446, i8** %1447
  call void @writeString(i8** %1447)
  %1448 = alloca [43 x i8]
  %1449 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 0
  store i8 72, i8* %1449
  %1450 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 1
  store i8 101, i8* %1450
  %1451 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 2
  store i8 114, i8* %1451
  %1452 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 3
  store i8 101, i8* %1452
  %1453 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 4
  store i8 39, i8* %1453
  %1454 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 5
  store i8 115, i8* %1454
  %1455 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 6
  store i8 32, i8* %1455
  %1456 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 7
  store i8 121, i8* %1456
  %1457 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 8
  store i8 111, i8* %1457
  %1458 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 9
  store i8 117, i8* %1458
  %1459 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 10
  store i8 114, i8* %1459
  %1460 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 11
  store i8 32, i8* %1460
  %1461 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 12
  store i8 105, i8* %1461
  %1462 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 13
  store i8 110, i8* %1462
  %1463 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 14
  store i8 116, i8* %1463
  %1464 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 15
  store i8 101, i8* %1464
  %1465 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 16
  store i8 103, i8* %1465
  %1466 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 17
  store i8 101, i8* %1466
  %1467 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 18
  store i8 114, i8* %1467
  %1468 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 19
  store i8 32, i8* %1468
  %1469 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 20
  store i8 62, i8* %1469
  %1470 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 21
  store i8 32, i8* %1470
  %1471 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 22
  store i8 121, i8* %1471
  %1472 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 23
  store i8 111, i8* %1472
  %1473 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 24
  store i8 117, i8* %1473
  %1474 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 25
  store i8 114, i8* %1474
  %1475 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 26
  store i8 32, i8* %1475
  %1476 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 27
  store i8 111, i8* %1476
  %1477 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 28
  store i8 116, i8* %1477
  %1478 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 29
  store i8 104, i8* %1478
  %1479 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 30
  store i8 101, i8* %1479
  %1480 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 31
  store i8 114, i8* %1480
  %1481 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 32
  store i8 32, i8* %1481
  %1482 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 33
  store i8 105, i8* %1482
  %1483 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 34
  store i8 110, i8* %1483
  %1484 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 35
  store i8 116, i8* %1484
  %1485 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 36
  store i8 101, i8* %1485
  %1486 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 37
  store i8 103, i8* %1486
  %1487 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 38
  store i8 101, i8* %1487
  %1488 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 39
  store i8 114, i8* %1488
  %1489 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 40
  store i8 58, i8* %1489
  %1490 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 41
  store i8 32, i8* %1490
  %1491 = getelementptr [43 x i8], [43 x i8]* %1448, i16 0, i16 42
  store i8 0, i8* %1491
  %1492 = getelementptr inbounds [43 x i8], [43 x i8]* %1448, i16 0, i16 0
  %1493 = alloca i8*
  store i8* %1492, i8** %1493
  call void @writeString(i8** %1493)
  %1494 = load i16, i16* %1
  %1495 = load i16, i16* %2
  %1496 = icmp sgt i16 %1494, %1495
  call void @writeBoolean(i1 %1496)
  %1497 = alloca [2 x i8]
  %1498 = getelementptr [2 x i8], [2 x i8]* %1497, i16 0, i16 0
  store i8 10, i8* %1498
  %1499 = getelementptr [2 x i8], [2 x i8]* %1497, i16 0, i16 1
  store i8 0, i8* %1499
  %1500 = getelementptr inbounds [2 x i8], [2 x i8]* %1497, i16 0, i16 0
  %1501 = alloca i8*
  store i8* %1500, i8** %1501
  call void @writeString(i8** %1501)
  %1502 = alloca [44 x i8]
  %1503 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 0
  store i8 72, i8* %1503
  %1504 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 1
  store i8 101, i8* %1504
  %1505 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 2
  store i8 114, i8* %1505
  %1506 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 3
  store i8 101, i8* %1506
  %1507 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 4
  store i8 39, i8* %1507
  %1508 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 5
  store i8 115, i8* %1508
  %1509 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 6
  store i8 32, i8* %1509
  %1510 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 7
  store i8 121, i8* %1510
  %1511 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 8
  store i8 111, i8* %1511
  %1512 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 9
  store i8 117, i8* %1512
  %1513 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 10
  store i8 114, i8* %1513
  %1514 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 11
  store i8 32, i8* %1514
  %1515 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 12
  store i8 105, i8* %1515
  %1516 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 13
  store i8 110, i8* %1516
  %1517 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 14
  store i8 116, i8* %1517
  %1518 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 15
  store i8 101, i8* %1518
  %1519 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 16
  store i8 103, i8* %1519
  %1520 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 17
  store i8 101, i8* %1520
  %1521 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 18
  store i8 114, i8* %1521
  %1522 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 19
  store i8 32, i8* %1522
  %1523 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 20
  store i8 60, i8* %1523
  %1524 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 21
  store i8 61, i8* %1524
  %1525 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 22
  store i8 32, i8* %1525
  %1526 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 23
  store i8 121, i8* %1526
  %1527 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 24
  store i8 111, i8* %1527
  %1528 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 25
  store i8 117, i8* %1528
  %1529 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 26
  store i8 114, i8* %1529
  %1530 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 27
  store i8 32, i8* %1530
  %1531 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 28
  store i8 111, i8* %1531
  %1532 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 29
  store i8 116, i8* %1532
  %1533 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 30
  store i8 104, i8* %1533
  %1534 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 31
  store i8 101, i8* %1534
  %1535 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 32
  store i8 114, i8* %1535
  %1536 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 33
  store i8 32, i8* %1536
  %1537 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 34
  store i8 105, i8* %1537
  %1538 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 35
  store i8 110, i8* %1538
  %1539 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 36
  store i8 116, i8* %1539
  %1540 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 37
  store i8 101, i8* %1540
  %1541 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 38
  store i8 103, i8* %1541
  %1542 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 39
  store i8 101, i8* %1542
  %1543 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 40
  store i8 114, i8* %1543
  %1544 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 41
  store i8 58, i8* %1544
  %1545 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 42
  store i8 32, i8* %1545
  %1546 = getelementptr [44 x i8], [44 x i8]* %1502, i16 0, i16 43
  store i8 0, i8* %1546
  %1547 = getelementptr inbounds [44 x i8], [44 x i8]* %1502, i16 0, i16 0
  %1548 = alloca i8*
  store i8* %1547, i8** %1548
  call void @writeString(i8** %1548)
  %1549 = load i16, i16* %1
  %1550 = load i16, i16* %2
  %1551 = icmp sle i16 %1549, %1550
  call void @writeBoolean(i1 %1551)
  %1552 = alloca [2 x i8]
  %1553 = getelementptr [2 x i8], [2 x i8]* %1552, i16 0, i16 0
  store i8 10, i8* %1553
  %1554 = getelementptr [2 x i8], [2 x i8]* %1552, i16 0, i16 1
  store i8 0, i8* %1554
  %1555 = getelementptr inbounds [2 x i8], [2 x i8]* %1552, i16 0, i16 0
  %1556 = alloca i8*
  store i8* %1555, i8** %1556
  call void @writeString(i8** %1556)
  %1557 = alloca [44 x i8]
  %1558 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 0
  store i8 72, i8* %1558
  %1559 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 1
  store i8 101, i8* %1559
  %1560 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 2
  store i8 114, i8* %1560
  %1561 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 3
  store i8 101, i8* %1561
  %1562 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 4
  store i8 39, i8* %1562
  %1563 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 5
  store i8 115, i8* %1563
  %1564 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 6
  store i8 32, i8* %1564
  %1565 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 7
  store i8 121, i8* %1565
  %1566 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 8
  store i8 111, i8* %1566
  %1567 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 9
  store i8 117, i8* %1567
  %1568 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 10
  store i8 114, i8* %1568
  %1569 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 11
  store i8 32, i8* %1569
  %1570 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 12
  store i8 105, i8* %1570
  %1571 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 13
  store i8 110, i8* %1571
  %1572 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 14
  store i8 116, i8* %1572
  %1573 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 15
  store i8 101, i8* %1573
  %1574 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 16
  store i8 103, i8* %1574
  %1575 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 17
  store i8 101, i8* %1575
  %1576 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 18
  store i8 114, i8* %1576
  %1577 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 19
  store i8 32, i8* %1577
  %1578 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 20
  store i8 62, i8* %1578
  %1579 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 21
  store i8 61, i8* %1579
  %1580 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 22
  store i8 32, i8* %1580
  %1581 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 23
  store i8 121, i8* %1581
  %1582 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 24
  store i8 111, i8* %1582
  %1583 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 25
  store i8 117, i8* %1583
  %1584 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 26
  store i8 114, i8* %1584
  %1585 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 27
  store i8 32, i8* %1585
  %1586 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 28
  store i8 111, i8* %1586
  %1587 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 29
  store i8 116, i8* %1587
  %1588 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 30
  store i8 104, i8* %1588
  %1589 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 31
  store i8 101, i8* %1589
  %1590 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 32
  store i8 114, i8* %1590
  %1591 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 33
  store i8 32, i8* %1591
  %1592 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 34
  store i8 105, i8* %1592
  %1593 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 35
  store i8 110, i8* %1593
  %1594 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 36
  store i8 116, i8* %1594
  %1595 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 37
  store i8 101, i8* %1595
  %1596 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 38
  store i8 103, i8* %1596
  %1597 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 39
  store i8 101, i8* %1597
  %1598 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 40
  store i8 114, i8* %1598
  %1599 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 41
  store i8 58, i8* %1599
  %1600 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 42
  store i8 32, i8* %1600
  %1601 = getelementptr [44 x i8], [44 x i8]* %1557, i16 0, i16 43
  store i8 0, i8* %1601
  %1602 = getelementptr inbounds [44 x i8], [44 x i8]* %1557, i16 0, i16 0
  %1603 = alloca i8*
  store i8* %1602, i8** %1603
  call void @writeString(i8** %1603)
  %1604 = load i16, i16* %1
  %1605 = load i16, i16* %2
  %1606 = icmp sge i16 %1604, %1605
  call void @writeBoolean(i1 %1606)
  %1607 = alloca [2 x i8]
  %1608 = getelementptr [2 x i8], [2 x i8]* %1607, i16 0, i16 0
  store i8 10, i8* %1608
  %1609 = getelementptr [2 x i8], [2 x i8]* %1607, i16 0, i16 1
  store i8 0, i8* %1609
  %1610 = getelementptr inbounds [2 x i8], [2 x i8]* %1607, i16 0, i16 0
  %1611 = alloca i8*
  store i8* %1610, i8** %1611
  call void @writeString(i8** %1611)
  %1612 = alloca [43 x i8]
  %1613 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 0
  store i8 72, i8* %1613
  %1614 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 1
  store i8 101, i8* %1614
  %1615 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 2
  store i8 114, i8* %1615
  %1616 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 3
  store i8 101, i8* %1616
  %1617 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 4
  store i8 39, i8* %1617
  %1618 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 5
  store i8 115, i8* %1618
  %1619 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 6
  store i8 32, i8* %1619
  %1620 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 7
  store i8 121, i8* %1620
  %1621 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 8
  store i8 111, i8* %1621
  %1622 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 9
  store i8 117, i8* %1622
  %1623 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 10
  store i8 114, i8* %1623
  %1624 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 11
  store i8 32, i8* %1624
  %1625 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 12
  store i8 105, i8* %1625
  %1626 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 13
  store i8 110, i8* %1626
  %1627 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 14
  store i8 116, i8* %1627
  %1628 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 15
  store i8 101, i8* %1628
  %1629 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 16
  store i8 103, i8* %1629
  %1630 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 17
  store i8 101, i8* %1630
  %1631 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 18
  store i8 114, i8* %1631
  %1632 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 19
  store i8 32, i8* %1632
  %1633 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 20
  store i8 61, i8* %1633
  %1634 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 21
  store i8 32, i8* %1634
  %1635 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 22
  store i8 121, i8* %1635
  %1636 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 23
  store i8 111, i8* %1636
  %1637 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 24
  store i8 117, i8* %1637
  %1638 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 25
  store i8 114, i8* %1638
  %1639 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 26
  store i8 32, i8* %1639
  %1640 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 27
  store i8 111, i8* %1640
  %1641 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 28
  store i8 116, i8* %1641
  %1642 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 29
  store i8 104, i8* %1642
  %1643 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 30
  store i8 101, i8* %1643
  %1644 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 31
  store i8 114, i8* %1644
  %1645 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 32
  store i8 32, i8* %1645
  %1646 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 33
  store i8 105, i8* %1646
  %1647 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 34
  store i8 110, i8* %1647
  %1648 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 35
  store i8 116, i8* %1648
  %1649 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 36
  store i8 101, i8* %1649
  %1650 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 37
  store i8 103, i8* %1650
  %1651 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 38
  store i8 101, i8* %1651
  %1652 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 39
  store i8 114, i8* %1652
  %1653 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 40
  store i8 58, i8* %1653
  %1654 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 41
  store i8 32, i8* %1654
  %1655 = getelementptr [43 x i8], [43 x i8]* %1612, i16 0, i16 42
  store i8 0, i8* %1655
  %1656 = getelementptr inbounds [43 x i8], [43 x i8]* %1612, i16 0, i16 0
  %1657 = alloca i8*
  store i8* %1656, i8** %1657
  call void @writeString(i8** %1657)
  %1658 = load i16, i16* %1
  %1659 = load i16, i16* %2
  %1660 = icmp eq i16 %1658, %1659
  call void @writeBoolean(i1 %1660)
  %1661 = alloca [2 x i8]
  %1662 = getelementptr [2 x i8], [2 x i8]* %1661, i16 0, i16 0
  store i8 10, i8* %1662
  %1663 = getelementptr [2 x i8], [2 x i8]* %1661, i16 0, i16 1
  store i8 0, i8* %1663
  %1664 = getelementptr inbounds [2 x i8], [2 x i8]* %1661, i16 0, i16 0
  %1665 = alloca i8*
  store i8* %1664, i8** %1665
  call void @writeString(i8** %1665)
  %1666 = alloca [44 x i8]
  %1667 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 0
  store i8 72, i8* %1667
  %1668 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 1
  store i8 101, i8* %1668
  %1669 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 2
  store i8 114, i8* %1669
  %1670 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 3
  store i8 101, i8* %1670
  %1671 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 4
  store i8 39, i8* %1671
  %1672 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 5
  store i8 115, i8* %1672
  %1673 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 6
  store i8 32, i8* %1673
  %1674 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 7
  store i8 121, i8* %1674
  %1675 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 8
  store i8 111, i8* %1675
  %1676 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 9
  store i8 117, i8* %1676
  %1677 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 10
  store i8 114, i8* %1677
  %1678 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 11
  store i8 32, i8* %1678
  %1679 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 12
  store i8 105, i8* %1679
  %1680 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 13
  store i8 110, i8* %1680
  %1681 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 14
  store i8 116, i8* %1681
  %1682 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 15
  store i8 101, i8* %1682
  %1683 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 16
  store i8 103, i8* %1683
  %1684 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 17
  store i8 101, i8* %1684
  %1685 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 18
  store i8 114, i8* %1685
  %1686 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 19
  store i8 32, i8* %1686
  %1687 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 20
  store i8 60, i8* %1687
  %1688 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 21
  store i8 62, i8* %1688
  %1689 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 22
  store i8 32, i8* %1689
  %1690 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 23
  store i8 121, i8* %1690
  %1691 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 24
  store i8 111, i8* %1691
  %1692 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 25
  store i8 117, i8* %1692
  %1693 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 26
  store i8 114, i8* %1693
  %1694 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 27
  store i8 32, i8* %1694
  %1695 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 28
  store i8 111, i8* %1695
  %1696 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 29
  store i8 116, i8* %1696
  %1697 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 30
  store i8 104, i8* %1697
  %1698 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 31
  store i8 101, i8* %1698
  %1699 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 32
  store i8 114, i8* %1699
  %1700 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 33
  store i8 32, i8* %1700
  %1701 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 34
  store i8 105, i8* %1701
  %1702 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 35
  store i8 110, i8* %1702
  %1703 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 36
  store i8 116, i8* %1703
  %1704 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 37
  store i8 101, i8* %1704
  %1705 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 38
  store i8 103, i8* %1705
  %1706 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 39
  store i8 101, i8* %1706
  %1707 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 40
  store i8 114, i8* %1707
  %1708 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 41
  store i8 58, i8* %1708
  %1709 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 42
  store i8 32, i8* %1709
  %1710 = getelementptr [44 x i8], [44 x i8]* %1666, i16 0, i16 43
  store i8 0, i8* %1710
  %1711 = getelementptr inbounds [44 x i8], [44 x i8]* %1666, i16 0, i16 0
  %1712 = alloca i8*
  store i8* %1711, i8** %1712
  call void @writeString(i8** %1712)
  %1713 = load i16, i16* %1
  %1714 = load i16, i16* %2
  %1715 = icmp ne i16 %1713, %1714
  call void @writeBoolean(i1 %1715)
  %1716 = alloca [2 x i8]
  %1717 = getelementptr [2 x i8], [2 x i8]* %1716, i16 0, i16 0
  store i8 10, i8* %1717
  %1718 = getelementptr [2 x i8], [2 x i8]* %1716, i16 0, i16 1
  store i8 0, i8* %1718
  %1719 = getelementptr inbounds [2 x i8], [2 x i8]* %1716, i16 0, i16 0
  %1720 = alloca i8*
  store i8* %1719, i8** %1720
  call void @writeString(i8** %1720)
  %1721 = alloca [21 x i8]
  %1722 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 0
  store i8 71, i8* %1722
  %1723 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 1
  store i8 105, i8* %1723
  %1724 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 2
  store i8 118, i8* %1724
  %1725 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 3
  store i8 101, i8* %1725
  %1726 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 4
  store i8 32, i8* %1726
  %1727 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 5
  store i8 109, i8* %1727
  %1728 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 6
  store i8 101, i8* %1728
  %1729 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 7
  store i8 32, i8* %1729
  %1730 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 8
  store i8 97, i8* %1730
  %1731 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 9
  store i8 110, i8* %1731
  %1732 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 10
  store i8 32, i8* %1732
  %1733 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 11
  store i8 105, i8* %1733
  %1734 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 12
  store i8 110, i8* %1734
  %1735 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 13
  store i8 116, i8* %1735
  %1736 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 14
  store i8 101, i8* %1736
  %1737 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 15
  store i8 103, i8* %1737
  %1738 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 16
  store i8 101, i8* %1738
  %1739 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 17
  store i8 114, i8* %1739
  %1740 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 18
  store i8 58, i8* %1740
  %1741 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 19
  store i8 32, i8* %1741
  %1742 = getelementptr [21 x i8], [21 x i8]* %1721, i16 0, i16 20
  store i8 0, i8* %1742
  %1743 = getelementptr inbounds [21 x i8], [21 x i8]* %1721, i16 0, i16 0
  %1744 = alloca i8*
  store i8* %1743, i8** %1744
  call void @writeString(i8** %1744)
  %1745 = call i16 @readInteger()
  store i16 %1745, i16* %1
  %1746 = alloca [17 x i8]
  %1747 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 0
  store i8 71, i8* %1747
  %1748 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 1
  store i8 105, i8* %1748
  %1749 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 2
  store i8 118, i8* %1749
  %1750 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 3
  store i8 101, i8* %1750
  %1751 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 4
  store i8 32, i8* %1751
  %1752 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 5
  store i8 109, i8* %1752
  %1753 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 6
  store i8 101, i8* %1753
  %1754 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 7
  store i8 32, i8* %1754
  %1755 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 8
  store i8 97, i8* %1755
  %1756 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 9
  store i8 32, i8* %1756
  %1757 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 10
  store i8 114, i8* %1757
  %1758 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 11
  store i8 101, i8* %1758
  %1759 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 12
  store i8 97, i8* %1759
  %1760 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 13
  store i8 108, i8* %1760
  %1761 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 14
  store i8 58, i8* %1761
  %1762 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 15
  store i8 32, i8* %1762
  %1763 = getelementptr [17 x i8], [17 x i8]* %1746, i16 0, i16 16
  store i8 0, i8* %1763
  %1764 = getelementptr inbounds [17 x i8], [17 x i8]* %1746, i16 0, i16 0
  %1765 = alloca i8*
  store i8* %1764, i8** %1765
  call void @writeString(i8** %1765)
  %1766 = call double @readReal()
  store double %1766, double* %9
  %1767 = alloca [34 x i8]
  %1768 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 0
  store i8 72, i8* %1768
  %1769 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 1
  store i8 101, i8* %1769
  %1770 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 2
  store i8 114, i8* %1770
  %1771 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 3
  store i8 101, i8* %1771
  %1772 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 4
  store i8 39, i8* %1772
  %1773 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 5
  store i8 115, i8* %1773
  %1774 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 6
  store i8 32, i8* %1774
  %1775 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 7
  store i8 121, i8* %1775
  %1776 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 8
  store i8 111, i8* %1776
  %1777 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 9
  store i8 117, i8* %1777
  %1778 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 10
  store i8 114, i8* %1778
  %1779 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 11
  store i8 32, i8* %1779
  %1780 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 12
  store i8 105, i8* %1780
  %1781 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 13
  store i8 110, i8* %1781
  %1782 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 14
  store i8 116, i8* %1782
  %1783 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 15
  store i8 101, i8* %1783
  %1784 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 16
  store i8 103, i8* %1784
  %1785 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 17
  store i8 101, i8* %1785
  %1786 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 18
  store i8 114, i8* %1786
  %1787 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 19
  store i8 32, i8* %1787
  %1788 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 20
  store i8 43, i8* %1788
  %1789 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 21
  store i8 32, i8* %1789
  %1790 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 22
  store i8 121, i8* %1790
  %1791 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 23
  store i8 111, i8* %1791
  %1792 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 24
  store i8 117, i8* %1792
  %1793 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 25
  store i8 114, i8* %1793
  %1794 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 26
  store i8 32, i8* %1794
  %1795 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 27
  store i8 114, i8* %1795
  %1796 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 28
  store i8 101, i8* %1796
  %1797 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 29
  store i8 97, i8* %1797
  %1798 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 30
  store i8 108, i8* %1798
  %1799 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 31
  store i8 58, i8* %1799
  %1800 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 32
  store i8 32, i8* %1800
  %1801 = getelementptr [34 x i8], [34 x i8]* %1767, i16 0, i16 33
  store i8 0, i8* %1801
  %1802 = getelementptr inbounds [34 x i8], [34 x i8]* %1767, i16 0, i16 0
  %1803 = alloca i8*
  store i8* %1802, i8** %1803
  call void @writeString(i8** %1803)
  %1804 = load i16, i16* %1
  %1805 = load double, double* %9
  %1806 = sitofp i16 %1804 to double
  %1807 = fadd double %1806, %1805
  call void @writeReal(double %1807)
  %1808 = alloca [2 x i8]
  %1809 = getelementptr [2 x i8], [2 x i8]* %1808, i16 0, i16 0
  store i8 10, i8* %1809
  %1810 = getelementptr [2 x i8], [2 x i8]* %1808, i16 0, i16 1
  store i8 0, i8* %1810
  %1811 = getelementptr inbounds [2 x i8], [2 x i8]* %1808, i16 0, i16 0
  %1812 = alloca i8*
  store i8* %1811, i8** %1812
  call void @writeString(i8** %1812)
  %1813 = alloca [34 x i8]
  %1814 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 0
  store i8 72, i8* %1814
  %1815 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 1
  store i8 101, i8* %1815
  %1816 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 2
  store i8 114, i8* %1816
  %1817 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 3
  store i8 101, i8* %1817
  %1818 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 4
  store i8 39, i8* %1818
  %1819 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 5
  store i8 115, i8* %1819
  %1820 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 6
  store i8 32, i8* %1820
  %1821 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 7
  store i8 121, i8* %1821
  %1822 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 8
  store i8 111, i8* %1822
  %1823 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 9
  store i8 117, i8* %1823
  %1824 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 10
  store i8 114, i8* %1824
  %1825 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 11
  store i8 32, i8* %1825
  %1826 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 12
  store i8 105, i8* %1826
  %1827 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 13
  store i8 110, i8* %1827
  %1828 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 14
  store i8 116, i8* %1828
  %1829 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 15
  store i8 101, i8* %1829
  %1830 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 16
  store i8 103, i8* %1830
  %1831 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 17
  store i8 101, i8* %1831
  %1832 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 18
  store i8 114, i8* %1832
  %1833 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 19
  store i8 32, i8* %1833
  %1834 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 20
  store i8 42, i8* %1834
  %1835 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 21
  store i8 32, i8* %1835
  %1836 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 22
  store i8 121, i8* %1836
  %1837 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 23
  store i8 111, i8* %1837
  %1838 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 24
  store i8 117, i8* %1838
  %1839 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 25
  store i8 114, i8* %1839
  %1840 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 26
  store i8 32, i8* %1840
  %1841 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 27
  store i8 114, i8* %1841
  %1842 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 28
  store i8 101, i8* %1842
  %1843 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 29
  store i8 97, i8* %1843
  %1844 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 30
  store i8 108, i8* %1844
  %1845 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 31
  store i8 58, i8* %1845
  %1846 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 32
  store i8 32, i8* %1846
  %1847 = getelementptr [34 x i8], [34 x i8]* %1813, i16 0, i16 33
  store i8 0, i8* %1847
  %1848 = getelementptr inbounds [34 x i8], [34 x i8]* %1813, i16 0, i16 0
  %1849 = alloca i8*
  store i8* %1848, i8** %1849
  call void @writeString(i8** %1849)
  %1850 = load i16, i16* %1
  %1851 = load double, double* %9
  %1852 = sitofp i16 %1850 to double
  %1853 = fmul double %1852, %1851
  call void @writeReal(double %1853)
  %1854 = alloca [2 x i8]
  %1855 = getelementptr [2 x i8], [2 x i8]* %1854, i16 0, i16 0
  store i8 10, i8* %1855
  %1856 = getelementptr [2 x i8], [2 x i8]* %1854, i16 0, i16 1
  store i8 0, i8* %1856
  %1857 = getelementptr inbounds [2 x i8], [2 x i8]* %1854, i16 0, i16 0
  %1858 = alloca i8*
  store i8* %1857, i8** %1858
  call void @writeString(i8** %1858)
  %1859 = alloca [34 x i8]
  %1860 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 0
  store i8 72, i8* %1860
  %1861 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 1
  store i8 101, i8* %1861
  %1862 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 2
  store i8 114, i8* %1862
  %1863 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 3
  store i8 101, i8* %1863
  %1864 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 4
  store i8 39, i8* %1864
  %1865 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 5
  store i8 115, i8* %1865
  %1866 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 6
  store i8 32, i8* %1866
  %1867 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 7
  store i8 121, i8* %1867
  %1868 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 8
  store i8 111, i8* %1868
  %1869 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 9
  store i8 117, i8* %1869
  %1870 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 10
  store i8 114, i8* %1870
  %1871 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 11
  store i8 32, i8* %1871
  %1872 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 12
  store i8 105, i8* %1872
  %1873 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 13
  store i8 110, i8* %1873
  %1874 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 14
  store i8 116, i8* %1874
  %1875 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 15
  store i8 101, i8* %1875
  %1876 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 16
  store i8 103, i8* %1876
  %1877 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 17
  store i8 101, i8* %1877
  %1878 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 18
  store i8 114, i8* %1878
  %1879 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 19
  store i8 32, i8* %1879
  %1880 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 20
  store i8 45, i8* %1880
  %1881 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 21
  store i8 32, i8* %1881
  %1882 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 22
  store i8 121, i8* %1882
  %1883 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 23
  store i8 111, i8* %1883
  %1884 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 24
  store i8 117, i8* %1884
  %1885 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 25
  store i8 114, i8* %1885
  %1886 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 26
  store i8 32, i8* %1886
  %1887 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 27
  store i8 114, i8* %1887
  %1888 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 28
  store i8 101, i8* %1888
  %1889 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 29
  store i8 97, i8* %1889
  %1890 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 30
  store i8 108, i8* %1890
  %1891 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 31
  store i8 58, i8* %1891
  %1892 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 32
  store i8 32, i8* %1892
  %1893 = getelementptr [34 x i8], [34 x i8]* %1859, i16 0, i16 33
  store i8 0, i8* %1893
  %1894 = getelementptr inbounds [34 x i8], [34 x i8]* %1859, i16 0, i16 0
  %1895 = alloca i8*
  store i8* %1894, i8** %1895
  call void @writeString(i8** %1895)
  %1896 = load i16, i16* %1
  %1897 = load double, double* %9
  %1898 = sitofp i16 %1896 to double
  %1899 = fsub double %1898, %1897
  call void @writeReal(double %1899)
  %1900 = alloca [2 x i8]
  %1901 = getelementptr [2 x i8], [2 x i8]* %1900, i16 0, i16 0
  store i8 10, i8* %1901
  %1902 = getelementptr [2 x i8], [2 x i8]* %1900, i16 0, i16 1
  store i8 0, i8* %1902
  %1903 = getelementptr inbounds [2 x i8], [2 x i8]* %1900, i16 0, i16 0
  %1904 = alloca i8*
  store i8* %1903, i8** %1904
  call void @writeString(i8** %1904)
  %1905 = alloca [34 x i8]
  %1906 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 0
  store i8 72, i8* %1906
  %1907 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 1
  store i8 101, i8* %1907
  %1908 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 2
  store i8 114, i8* %1908
  %1909 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 3
  store i8 101, i8* %1909
  %1910 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 4
  store i8 39, i8* %1910
  %1911 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 5
  store i8 115, i8* %1911
  %1912 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 6
  store i8 32, i8* %1912
  %1913 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 7
  store i8 121, i8* %1913
  %1914 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 8
  store i8 111, i8* %1914
  %1915 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 9
  store i8 117, i8* %1915
  %1916 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 10
  store i8 114, i8* %1916
  %1917 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 11
  store i8 32, i8* %1917
  %1918 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 12
  store i8 105, i8* %1918
  %1919 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 13
  store i8 110, i8* %1919
  %1920 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 14
  store i8 116, i8* %1920
  %1921 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 15
  store i8 101, i8* %1921
  %1922 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 16
  store i8 103, i8* %1922
  %1923 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 17
  store i8 101, i8* %1923
  %1924 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 18
  store i8 114, i8* %1924
  %1925 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 19
  store i8 32, i8* %1925
  %1926 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 20
  store i8 47, i8* %1926
  %1927 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 21
  store i8 32, i8* %1927
  %1928 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 22
  store i8 121, i8* %1928
  %1929 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 23
  store i8 111, i8* %1929
  %1930 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 24
  store i8 117, i8* %1930
  %1931 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 25
  store i8 114, i8* %1931
  %1932 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 26
  store i8 32, i8* %1932
  %1933 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 27
  store i8 114, i8* %1933
  %1934 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 28
  store i8 101, i8* %1934
  %1935 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 29
  store i8 97, i8* %1935
  %1936 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 30
  store i8 108, i8* %1936
  %1937 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 31
  store i8 58, i8* %1937
  %1938 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 32
  store i8 32, i8* %1938
  %1939 = getelementptr [34 x i8], [34 x i8]* %1905, i16 0, i16 33
  store i8 0, i8* %1939
  %1940 = getelementptr inbounds [34 x i8], [34 x i8]* %1905, i16 0, i16 0
  %1941 = alloca i8*
  store i8* %1940, i8** %1941
  call void @writeString(i8** %1941)
  %1942 = load i16, i16* %1
  %1943 = load double, double* %9
  %1944 = sitofp i16 %1942 to double
  %1945 = fdiv double %1944, %1943
  call void @writeReal(double %1945)
  %1946 = alloca [2 x i8]
  %1947 = getelementptr [2 x i8], [2 x i8]* %1946, i16 0, i16 0
  store i8 10, i8* %1947
  %1948 = getelementptr [2 x i8], [2 x i8]* %1946, i16 0, i16 1
  store i8 0, i8* %1948
  %1949 = getelementptr inbounds [2 x i8], [2 x i8]* %1946, i16 0, i16 0
  %1950 = alloca i8*
  store i8* %1949, i8** %1950
  call void @writeString(i8** %1950)
  %1951 = alloca [34 x i8]
  %1952 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 0
  store i8 72, i8* %1952
  %1953 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 1
  store i8 101, i8* %1953
  %1954 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 2
  store i8 114, i8* %1954
  %1955 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 3
  store i8 101, i8* %1955
  %1956 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 4
  store i8 39, i8* %1956
  %1957 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 5
  store i8 115, i8* %1957
  %1958 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 6
  store i8 32, i8* %1958
  %1959 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 7
  store i8 121, i8* %1959
  %1960 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 8
  store i8 111, i8* %1960
  %1961 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 9
  store i8 117, i8* %1961
  %1962 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 10
  store i8 114, i8* %1962
  %1963 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 11
  store i8 32, i8* %1963
  %1964 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 12
  store i8 105, i8* %1964
  %1965 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 13
  store i8 110, i8* %1965
  %1966 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 14
  store i8 116, i8* %1966
  %1967 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 15
  store i8 101, i8* %1967
  %1968 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 16
  store i8 103, i8* %1968
  %1969 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 17
  store i8 101, i8* %1969
  %1970 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 18
  store i8 114, i8* %1970
  %1971 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 19
  store i8 32, i8* %1971
  %1972 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 20
  store i8 60, i8* %1972
  %1973 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 21
  store i8 32, i8* %1973
  %1974 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 22
  store i8 121, i8* %1974
  %1975 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 23
  store i8 111, i8* %1975
  %1976 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 24
  store i8 117, i8* %1976
  %1977 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 25
  store i8 114, i8* %1977
  %1978 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 26
  store i8 32, i8* %1978
  %1979 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 27
  store i8 114, i8* %1979
  %1980 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 28
  store i8 101, i8* %1980
  %1981 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 29
  store i8 97, i8* %1981
  %1982 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 30
  store i8 108, i8* %1982
  %1983 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 31
  store i8 58, i8* %1983
  %1984 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 32
  store i8 32, i8* %1984
  %1985 = getelementptr [34 x i8], [34 x i8]* %1951, i16 0, i16 33
  store i8 0, i8* %1985
  %1986 = getelementptr inbounds [34 x i8], [34 x i8]* %1951, i16 0, i16 0
  %1987 = alloca i8*
  store i8* %1986, i8** %1987
  call void @writeString(i8** %1987)
  %1988 = load i16, i16* %1
  %1989 = load double, double* %9
  %1990 = sitofp i16 %1988 to double
  %1991 = fcmp olt double %1990, %1989
  call void @writeBoolean(i1 %1991)
  %1992 = alloca [2 x i8]
  %1993 = getelementptr [2 x i8], [2 x i8]* %1992, i16 0, i16 0
  store i8 10, i8* %1993
  %1994 = getelementptr [2 x i8], [2 x i8]* %1992, i16 0, i16 1
  store i8 0, i8* %1994
  %1995 = getelementptr inbounds [2 x i8], [2 x i8]* %1992, i16 0, i16 0
  %1996 = alloca i8*
  store i8* %1995, i8** %1996
  call void @writeString(i8** %1996)
  %1997 = alloca [34 x i8]
  %1998 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 0
  store i8 72, i8* %1998
  %1999 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 1
  store i8 101, i8* %1999
  %2000 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 2
  store i8 114, i8* %2000
  %2001 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 3
  store i8 101, i8* %2001
  %2002 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 4
  store i8 39, i8* %2002
  %2003 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 5
  store i8 115, i8* %2003
  %2004 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 6
  store i8 32, i8* %2004
  %2005 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 7
  store i8 121, i8* %2005
  %2006 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 8
  store i8 111, i8* %2006
  %2007 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 9
  store i8 117, i8* %2007
  %2008 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 10
  store i8 114, i8* %2008
  %2009 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 11
  store i8 32, i8* %2009
  %2010 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 12
  store i8 105, i8* %2010
  %2011 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 13
  store i8 110, i8* %2011
  %2012 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 14
  store i8 116, i8* %2012
  %2013 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 15
  store i8 101, i8* %2013
  %2014 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 16
  store i8 103, i8* %2014
  %2015 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 17
  store i8 101, i8* %2015
  %2016 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 18
  store i8 114, i8* %2016
  %2017 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 19
  store i8 32, i8* %2017
  %2018 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 20
  store i8 62, i8* %2018
  %2019 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 21
  store i8 32, i8* %2019
  %2020 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 22
  store i8 121, i8* %2020
  %2021 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 23
  store i8 111, i8* %2021
  %2022 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 24
  store i8 117, i8* %2022
  %2023 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 25
  store i8 114, i8* %2023
  %2024 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 26
  store i8 32, i8* %2024
  %2025 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 27
  store i8 114, i8* %2025
  %2026 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 28
  store i8 101, i8* %2026
  %2027 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 29
  store i8 97, i8* %2027
  %2028 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 30
  store i8 108, i8* %2028
  %2029 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 31
  store i8 58, i8* %2029
  %2030 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 32
  store i8 32, i8* %2030
  %2031 = getelementptr [34 x i8], [34 x i8]* %1997, i16 0, i16 33
  store i8 0, i8* %2031
  %2032 = getelementptr inbounds [34 x i8], [34 x i8]* %1997, i16 0, i16 0
  %2033 = alloca i8*
  store i8* %2032, i8** %2033
  call void @writeString(i8** %2033)
  %2034 = load i16, i16* %1
  %2035 = load double, double* %9
  %2036 = sitofp i16 %2034 to double
  %2037 = fcmp ogt double %2036, %2035
  call void @writeBoolean(i1 %2037)
  %2038 = alloca [2 x i8]
  %2039 = getelementptr [2 x i8], [2 x i8]* %2038, i16 0, i16 0
  store i8 10, i8* %2039
  %2040 = getelementptr [2 x i8], [2 x i8]* %2038, i16 0, i16 1
  store i8 0, i8* %2040
  %2041 = getelementptr inbounds [2 x i8], [2 x i8]* %2038, i16 0, i16 0
  %2042 = alloca i8*
  store i8* %2041, i8** %2042
  call void @writeString(i8** %2042)
  %2043 = alloca [35 x i8]
  %2044 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 0
  store i8 72, i8* %2044
  %2045 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 1
  store i8 101, i8* %2045
  %2046 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 2
  store i8 114, i8* %2046
  %2047 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 3
  store i8 101, i8* %2047
  %2048 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 4
  store i8 39, i8* %2048
  %2049 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 5
  store i8 115, i8* %2049
  %2050 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 6
  store i8 32, i8* %2050
  %2051 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 7
  store i8 121, i8* %2051
  %2052 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 8
  store i8 111, i8* %2052
  %2053 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 9
  store i8 117, i8* %2053
  %2054 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 10
  store i8 114, i8* %2054
  %2055 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 11
  store i8 32, i8* %2055
  %2056 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 12
  store i8 105, i8* %2056
  %2057 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 13
  store i8 110, i8* %2057
  %2058 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 14
  store i8 116, i8* %2058
  %2059 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 15
  store i8 101, i8* %2059
  %2060 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 16
  store i8 103, i8* %2060
  %2061 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 17
  store i8 101, i8* %2061
  %2062 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 18
  store i8 114, i8* %2062
  %2063 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 19
  store i8 32, i8* %2063
  %2064 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 20
  store i8 60, i8* %2064
  %2065 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 21
  store i8 61, i8* %2065
  %2066 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 22
  store i8 32, i8* %2066
  %2067 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 23
  store i8 121, i8* %2067
  %2068 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 24
  store i8 111, i8* %2068
  %2069 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 25
  store i8 117, i8* %2069
  %2070 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 26
  store i8 114, i8* %2070
  %2071 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 27
  store i8 32, i8* %2071
  %2072 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 28
  store i8 114, i8* %2072
  %2073 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 29
  store i8 101, i8* %2073
  %2074 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 30
  store i8 97, i8* %2074
  %2075 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 31
  store i8 108, i8* %2075
  %2076 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 32
  store i8 58, i8* %2076
  %2077 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 33
  store i8 32, i8* %2077
  %2078 = getelementptr [35 x i8], [35 x i8]* %2043, i16 0, i16 34
  store i8 0, i8* %2078
  %2079 = getelementptr inbounds [35 x i8], [35 x i8]* %2043, i16 0, i16 0
  %2080 = alloca i8*
  store i8* %2079, i8** %2080
  call void @writeString(i8** %2080)
  %2081 = load i16, i16* %1
  %2082 = load double, double* %9
  %2083 = sitofp i16 %2081 to double
  %2084 = fcmp ole double %2083, %2082
  call void @writeBoolean(i1 %2084)
  %2085 = alloca [2 x i8]
  %2086 = getelementptr [2 x i8], [2 x i8]* %2085, i16 0, i16 0
  store i8 10, i8* %2086
  %2087 = getelementptr [2 x i8], [2 x i8]* %2085, i16 0, i16 1
  store i8 0, i8* %2087
  %2088 = getelementptr inbounds [2 x i8], [2 x i8]* %2085, i16 0, i16 0
  %2089 = alloca i8*
  store i8* %2088, i8** %2089
  call void @writeString(i8** %2089)
  %2090 = alloca [35 x i8]
  %2091 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 0
  store i8 72, i8* %2091
  %2092 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 1
  store i8 101, i8* %2092
  %2093 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 2
  store i8 114, i8* %2093
  %2094 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 3
  store i8 101, i8* %2094
  %2095 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 4
  store i8 39, i8* %2095
  %2096 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 5
  store i8 115, i8* %2096
  %2097 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 6
  store i8 32, i8* %2097
  %2098 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 7
  store i8 121, i8* %2098
  %2099 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 8
  store i8 111, i8* %2099
  %2100 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 9
  store i8 117, i8* %2100
  %2101 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 10
  store i8 114, i8* %2101
  %2102 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 11
  store i8 32, i8* %2102
  %2103 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 12
  store i8 105, i8* %2103
  %2104 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 13
  store i8 110, i8* %2104
  %2105 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 14
  store i8 116, i8* %2105
  %2106 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 15
  store i8 101, i8* %2106
  %2107 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 16
  store i8 103, i8* %2107
  %2108 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 17
  store i8 101, i8* %2108
  %2109 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 18
  store i8 114, i8* %2109
  %2110 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 19
  store i8 32, i8* %2110
  %2111 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 20
  store i8 62, i8* %2111
  %2112 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 21
  store i8 61, i8* %2112
  %2113 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 22
  store i8 32, i8* %2113
  %2114 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 23
  store i8 121, i8* %2114
  %2115 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 24
  store i8 111, i8* %2115
  %2116 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 25
  store i8 117, i8* %2116
  %2117 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 26
  store i8 114, i8* %2117
  %2118 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 27
  store i8 32, i8* %2118
  %2119 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 28
  store i8 114, i8* %2119
  %2120 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 29
  store i8 101, i8* %2120
  %2121 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 30
  store i8 97, i8* %2121
  %2122 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 31
  store i8 108, i8* %2122
  %2123 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 32
  store i8 58, i8* %2123
  %2124 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 33
  store i8 32, i8* %2124
  %2125 = getelementptr [35 x i8], [35 x i8]* %2090, i16 0, i16 34
  store i8 0, i8* %2125
  %2126 = getelementptr inbounds [35 x i8], [35 x i8]* %2090, i16 0, i16 0
  %2127 = alloca i8*
  store i8* %2126, i8** %2127
  call void @writeString(i8** %2127)
  %2128 = load i16, i16* %1
  %2129 = load double, double* %9
  %2130 = sitofp i16 %2128 to double
  %2131 = fcmp oge double %2130, %2129
  call void @writeBoolean(i1 %2131)
  %2132 = alloca [2 x i8]
  %2133 = getelementptr [2 x i8], [2 x i8]* %2132, i16 0, i16 0
  store i8 10, i8* %2133
  %2134 = getelementptr [2 x i8], [2 x i8]* %2132, i16 0, i16 1
  store i8 0, i8* %2134
  %2135 = getelementptr inbounds [2 x i8], [2 x i8]* %2132, i16 0, i16 0
  %2136 = alloca i8*
  store i8* %2135, i8** %2136
  call void @writeString(i8** %2136)
  %2137 = alloca [34 x i8]
  %2138 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 0
  store i8 72, i8* %2138
  %2139 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 1
  store i8 101, i8* %2139
  %2140 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 2
  store i8 114, i8* %2140
  %2141 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 3
  store i8 101, i8* %2141
  %2142 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 4
  store i8 39, i8* %2142
  %2143 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 5
  store i8 115, i8* %2143
  %2144 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 6
  store i8 32, i8* %2144
  %2145 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 7
  store i8 121, i8* %2145
  %2146 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 8
  store i8 111, i8* %2146
  %2147 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 9
  store i8 117, i8* %2147
  %2148 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 10
  store i8 114, i8* %2148
  %2149 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 11
  store i8 32, i8* %2149
  %2150 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 12
  store i8 105, i8* %2150
  %2151 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 13
  store i8 110, i8* %2151
  %2152 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 14
  store i8 116, i8* %2152
  %2153 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 15
  store i8 101, i8* %2153
  %2154 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 16
  store i8 103, i8* %2154
  %2155 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 17
  store i8 101, i8* %2155
  %2156 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 18
  store i8 114, i8* %2156
  %2157 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 19
  store i8 32, i8* %2157
  %2158 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 20
  store i8 61, i8* %2158
  %2159 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 21
  store i8 32, i8* %2159
  %2160 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 22
  store i8 121, i8* %2160
  %2161 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 23
  store i8 111, i8* %2161
  %2162 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 24
  store i8 117, i8* %2162
  %2163 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 25
  store i8 114, i8* %2163
  %2164 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 26
  store i8 32, i8* %2164
  %2165 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 27
  store i8 114, i8* %2165
  %2166 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 28
  store i8 101, i8* %2166
  %2167 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 29
  store i8 97, i8* %2167
  %2168 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 30
  store i8 108, i8* %2168
  %2169 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 31
  store i8 58, i8* %2169
  %2170 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 32
  store i8 32, i8* %2170
  %2171 = getelementptr [34 x i8], [34 x i8]* %2137, i16 0, i16 33
  store i8 0, i8* %2171
  %2172 = getelementptr inbounds [34 x i8], [34 x i8]* %2137, i16 0, i16 0
  %2173 = alloca i8*
  store i8* %2172, i8** %2173
  call void @writeString(i8** %2173)
  %2174 = load i16, i16* %1
  %2175 = load double, double* %9
  %2176 = sitofp i16 %2174 to double
  %2177 = fcmp oeq double %2176, %2175
  call void @writeBoolean(i1 %2177)
  %2178 = alloca [2 x i8]
  %2179 = getelementptr [2 x i8], [2 x i8]* %2178, i16 0, i16 0
  store i8 10, i8* %2179
  %2180 = getelementptr [2 x i8], [2 x i8]* %2178, i16 0, i16 1
  store i8 0, i8* %2180
  %2181 = getelementptr inbounds [2 x i8], [2 x i8]* %2178, i16 0, i16 0
  %2182 = alloca i8*
  store i8* %2181, i8** %2182
  call void @writeString(i8** %2182)
  %2183 = alloca [35 x i8]
  %2184 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 0
  store i8 72, i8* %2184
  %2185 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 1
  store i8 101, i8* %2185
  %2186 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 2
  store i8 114, i8* %2186
  %2187 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 3
  store i8 101, i8* %2187
  %2188 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 4
  store i8 39, i8* %2188
  %2189 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 5
  store i8 115, i8* %2189
  %2190 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 6
  store i8 32, i8* %2190
  %2191 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 7
  store i8 121, i8* %2191
  %2192 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 8
  store i8 111, i8* %2192
  %2193 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 9
  store i8 117, i8* %2193
  %2194 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 10
  store i8 114, i8* %2194
  %2195 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 11
  store i8 32, i8* %2195
  %2196 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 12
  store i8 105, i8* %2196
  %2197 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 13
  store i8 110, i8* %2197
  %2198 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 14
  store i8 116, i8* %2198
  %2199 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 15
  store i8 101, i8* %2199
  %2200 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 16
  store i8 103, i8* %2200
  %2201 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 17
  store i8 101, i8* %2201
  %2202 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 18
  store i8 114, i8* %2202
  %2203 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 19
  store i8 32, i8* %2203
  %2204 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 20
  store i8 60, i8* %2204
  %2205 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 21
  store i8 62, i8* %2205
  %2206 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 22
  store i8 32, i8* %2206
  %2207 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 23
  store i8 121, i8* %2207
  %2208 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 24
  store i8 111, i8* %2208
  %2209 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 25
  store i8 117, i8* %2209
  %2210 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 26
  store i8 114, i8* %2210
  %2211 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 27
  store i8 32, i8* %2211
  %2212 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 28
  store i8 114, i8* %2212
  %2213 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 29
  store i8 101, i8* %2213
  %2214 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 30
  store i8 97, i8* %2214
  %2215 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 31
  store i8 108, i8* %2215
  %2216 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 32
  store i8 58, i8* %2216
  %2217 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 33
  store i8 32, i8* %2217
  %2218 = getelementptr [35 x i8], [35 x i8]* %2183, i16 0, i16 34
  store i8 0, i8* %2218
  %2219 = getelementptr inbounds [35 x i8], [35 x i8]* %2183, i16 0, i16 0
  %2220 = alloca i8*
  store i8* %2219, i8** %2220
  call void @writeString(i8** %2220)
  %2221 = load i16, i16* %1
  %2222 = load double, double* %9
  %2223 = sitofp i16 %2221 to double
  %2224 = fcmp one double %2223, %2222
  call void @writeBoolean(i1 %2224)
  %2225 = alloca [2 x i8]
  %2226 = getelementptr [2 x i8], [2 x i8]* %2225, i16 0, i16 0
  store i8 10, i8* %2226
  %2227 = getelementptr [2 x i8], [2 x i8]* %2225, i16 0, i16 1
  store i8 0, i8* %2227
  %2228 = getelementptr inbounds [2 x i8], [2 x i8]* %2225, i16 0, i16 0
  %2229 = alloca i8*
  store i8* %2228, i8** %2229
  call void @writeString(i8** %2229)
  %2230 = alloca [17 x i8]
  %2231 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 0
  store i8 71, i8* %2231
  %2232 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 1
  store i8 105, i8* %2232
  %2233 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 2
  store i8 118, i8* %2233
  %2234 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 3
  store i8 101, i8* %2234
  %2235 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 4
  store i8 32, i8* %2235
  %2236 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 5
  store i8 109, i8* %2236
  %2237 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 6
  store i8 101, i8* %2237
  %2238 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 7
  store i8 32, i8* %2238
  %2239 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 8
  store i8 97, i8* %2239
  %2240 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 9
  store i8 32, i8* %2240
  %2241 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 10
  store i8 114, i8* %2241
  %2242 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 11
  store i8 101, i8* %2242
  %2243 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 12
  store i8 97, i8* %2243
  %2244 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 13
  store i8 108, i8* %2244
  %2245 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 14
  store i8 58, i8* %2245
  %2246 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 15
  store i8 32, i8* %2246
  %2247 = getelementptr [17 x i8], [17 x i8]* %2230, i16 0, i16 16
  store i8 0, i8* %2247
  %2248 = getelementptr inbounds [17 x i8], [17 x i8]* %2230, i16 0, i16 0
  %2249 = alloca i8*
  store i8* %2248, i8** %2249
  call void @writeString(i8** %2249)
  %2250 = call double @readReal()
  store double %2250, double* %9
  %2251 = alloca [21 x i8]
  %2252 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 0
  store i8 71, i8* %2252
  %2253 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 1
  store i8 105, i8* %2253
  %2254 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 2
  store i8 118, i8* %2254
  %2255 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 3
  store i8 101, i8* %2255
  %2256 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 4
  store i8 32, i8* %2256
  %2257 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 5
  store i8 109, i8* %2257
  %2258 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 6
  store i8 101, i8* %2258
  %2259 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 7
  store i8 32, i8* %2259
  %2260 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 8
  store i8 97, i8* %2260
  %2261 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 9
  store i8 110, i8* %2261
  %2262 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 10
  store i8 32, i8* %2262
  %2263 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 11
  store i8 105, i8* %2263
  %2264 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 12
  store i8 110, i8* %2264
  %2265 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 13
  store i8 116, i8* %2265
  %2266 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 14
  store i8 101, i8* %2266
  %2267 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 15
  store i8 103, i8* %2267
  %2268 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 16
  store i8 101, i8* %2268
  %2269 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 17
  store i8 114, i8* %2269
  %2270 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 18
  store i8 58, i8* %2270
  %2271 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 19
  store i8 32, i8* %2271
  %2272 = getelementptr [21 x i8], [21 x i8]* %2251, i16 0, i16 20
  store i8 0, i8* %2272
  %2273 = getelementptr inbounds [21 x i8], [21 x i8]* %2251, i16 0, i16 0
  %2274 = alloca i8*
  store i8* %2273, i8** %2274
  call void @writeString(i8** %2274)
  %2275 = call i16 @readInteger()
  store i16 %2275, i16* %1
  %2276 = alloca [34 x i8]
  %2277 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 0
  store i8 72, i8* %2277
  %2278 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 1
  store i8 101, i8* %2278
  %2279 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 2
  store i8 114, i8* %2279
  %2280 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 3
  store i8 101, i8* %2280
  %2281 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 4
  store i8 39, i8* %2281
  %2282 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 5
  store i8 115, i8* %2282
  %2283 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 6
  store i8 32, i8* %2283
  %2284 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 7
  store i8 121, i8* %2284
  %2285 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 8
  store i8 111, i8* %2285
  %2286 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 9
  store i8 117, i8* %2286
  %2287 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 10
  store i8 114, i8* %2287
  %2288 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 11
  store i8 32, i8* %2288
  %2289 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 12
  store i8 114, i8* %2289
  %2290 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 13
  store i8 101, i8* %2290
  %2291 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 14
  store i8 97, i8* %2291
  %2292 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 15
  store i8 108, i8* %2292
  %2293 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 16
  store i8 32, i8* %2293
  %2294 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 17
  store i8 43, i8* %2294
  %2295 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 18
  store i8 32, i8* %2295
  %2296 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 19
  store i8 121, i8* %2296
  %2297 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 20
  store i8 111, i8* %2297
  %2298 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 21
  store i8 117, i8* %2298
  %2299 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 22
  store i8 114, i8* %2299
  %2300 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 23
  store i8 32, i8* %2300
  %2301 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 24
  store i8 105, i8* %2301
  %2302 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 25
  store i8 110, i8* %2302
  %2303 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 26
  store i8 116, i8* %2303
  %2304 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 27
  store i8 101, i8* %2304
  %2305 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 28
  store i8 103, i8* %2305
  %2306 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 29
  store i8 101, i8* %2306
  %2307 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 30
  store i8 114, i8* %2307
  %2308 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 31
  store i8 58, i8* %2308
  %2309 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 32
  store i8 32, i8* %2309
  %2310 = getelementptr [34 x i8], [34 x i8]* %2276, i16 0, i16 33
  store i8 0, i8* %2310
  %2311 = getelementptr inbounds [34 x i8], [34 x i8]* %2276, i16 0, i16 0
  %2312 = alloca i8*
  store i8* %2311, i8** %2312
  call void @writeString(i8** %2312)
  %2313 = load double, double* %9
  %2314 = load i16, i16* %1
  %2315 = sitofp i16 %2314 to double
  %2316 = fadd double %2313, %2315
  call void @writeReal(double %2316)
  %2317 = alloca [2 x i8]
  %2318 = getelementptr [2 x i8], [2 x i8]* %2317, i16 0, i16 0
  store i8 10, i8* %2318
  %2319 = getelementptr [2 x i8], [2 x i8]* %2317, i16 0, i16 1
  store i8 0, i8* %2319
  %2320 = getelementptr inbounds [2 x i8], [2 x i8]* %2317, i16 0, i16 0
  %2321 = alloca i8*
  store i8* %2320, i8** %2321
  call void @writeString(i8** %2321)
  %2322 = alloca [34 x i8]
  %2323 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 0
  store i8 72, i8* %2323
  %2324 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 1
  store i8 101, i8* %2324
  %2325 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 2
  store i8 114, i8* %2325
  %2326 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 3
  store i8 101, i8* %2326
  %2327 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 4
  store i8 39, i8* %2327
  %2328 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 5
  store i8 115, i8* %2328
  %2329 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 6
  store i8 32, i8* %2329
  %2330 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 7
  store i8 121, i8* %2330
  %2331 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 8
  store i8 111, i8* %2331
  %2332 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 9
  store i8 117, i8* %2332
  %2333 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 10
  store i8 114, i8* %2333
  %2334 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 11
  store i8 32, i8* %2334
  %2335 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 12
  store i8 114, i8* %2335
  %2336 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 13
  store i8 101, i8* %2336
  %2337 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 14
  store i8 97, i8* %2337
  %2338 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 15
  store i8 108, i8* %2338
  %2339 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 16
  store i8 32, i8* %2339
  %2340 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 17
  store i8 42, i8* %2340
  %2341 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 18
  store i8 32, i8* %2341
  %2342 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 19
  store i8 121, i8* %2342
  %2343 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 20
  store i8 111, i8* %2343
  %2344 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 21
  store i8 117, i8* %2344
  %2345 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 22
  store i8 114, i8* %2345
  %2346 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 23
  store i8 32, i8* %2346
  %2347 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 24
  store i8 105, i8* %2347
  %2348 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 25
  store i8 110, i8* %2348
  %2349 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 26
  store i8 116, i8* %2349
  %2350 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 27
  store i8 101, i8* %2350
  %2351 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 28
  store i8 103, i8* %2351
  %2352 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 29
  store i8 101, i8* %2352
  %2353 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 30
  store i8 114, i8* %2353
  %2354 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 31
  store i8 58, i8* %2354
  %2355 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 32
  store i8 32, i8* %2355
  %2356 = getelementptr [34 x i8], [34 x i8]* %2322, i16 0, i16 33
  store i8 0, i8* %2356
  %2357 = getelementptr inbounds [34 x i8], [34 x i8]* %2322, i16 0, i16 0
  %2358 = alloca i8*
  store i8* %2357, i8** %2358
  call void @writeString(i8** %2358)
  %2359 = load double, double* %9
  %2360 = load i16, i16* %1
  %2361 = sitofp i16 %2360 to double
  %2362 = fmul double %2359, %2361
  call void @writeReal(double %2362)
  %2363 = alloca [2 x i8]
  %2364 = getelementptr [2 x i8], [2 x i8]* %2363, i16 0, i16 0
  store i8 10, i8* %2364
  %2365 = getelementptr [2 x i8], [2 x i8]* %2363, i16 0, i16 1
  store i8 0, i8* %2365
  %2366 = getelementptr inbounds [2 x i8], [2 x i8]* %2363, i16 0, i16 0
  %2367 = alloca i8*
  store i8* %2366, i8** %2367
  call void @writeString(i8** %2367)
  %2368 = alloca [34 x i8]
  %2369 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 0
  store i8 72, i8* %2369
  %2370 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 1
  store i8 101, i8* %2370
  %2371 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 2
  store i8 114, i8* %2371
  %2372 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 3
  store i8 101, i8* %2372
  %2373 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 4
  store i8 39, i8* %2373
  %2374 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 5
  store i8 115, i8* %2374
  %2375 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 6
  store i8 32, i8* %2375
  %2376 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 7
  store i8 121, i8* %2376
  %2377 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 8
  store i8 111, i8* %2377
  %2378 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 9
  store i8 117, i8* %2378
  %2379 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 10
  store i8 114, i8* %2379
  %2380 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 11
  store i8 32, i8* %2380
  %2381 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 12
  store i8 114, i8* %2381
  %2382 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 13
  store i8 101, i8* %2382
  %2383 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 14
  store i8 97, i8* %2383
  %2384 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 15
  store i8 108, i8* %2384
  %2385 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 16
  store i8 32, i8* %2385
  %2386 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 17
  store i8 45, i8* %2386
  %2387 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 18
  store i8 32, i8* %2387
  %2388 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 19
  store i8 121, i8* %2388
  %2389 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 20
  store i8 111, i8* %2389
  %2390 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 21
  store i8 117, i8* %2390
  %2391 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 22
  store i8 114, i8* %2391
  %2392 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 23
  store i8 32, i8* %2392
  %2393 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 24
  store i8 105, i8* %2393
  %2394 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 25
  store i8 110, i8* %2394
  %2395 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 26
  store i8 116, i8* %2395
  %2396 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 27
  store i8 101, i8* %2396
  %2397 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 28
  store i8 103, i8* %2397
  %2398 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 29
  store i8 101, i8* %2398
  %2399 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 30
  store i8 114, i8* %2399
  %2400 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 31
  store i8 58, i8* %2400
  %2401 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 32
  store i8 32, i8* %2401
  %2402 = getelementptr [34 x i8], [34 x i8]* %2368, i16 0, i16 33
  store i8 0, i8* %2402
  %2403 = getelementptr inbounds [34 x i8], [34 x i8]* %2368, i16 0, i16 0
  %2404 = alloca i8*
  store i8* %2403, i8** %2404
  call void @writeString(i8** %2404)
  %2405 = load double, double* %9
  %2406 = load i16, i16* %1
  %2407 = sitofp i16 %2406 to double
  %2408 = fsub double %2405, %2407
  call void @writeReal(double %2408)
  %2409 = alloca [2 x i8]
  %2410 = getelementptr [2 x i8], [2 x i8]* %2409, i16 0, i16 0
  store i8 10, i8* %2410
  %2411 = getelementptr [2 x i8], [2 x i8]* %2409, i16 0, i16 1
  store i8 0, i8* %2411
  %2412 = getelementptr inbounds [2 x i8], [2 x i8]* %2409, i16 0, i16 0
  %2413 = alloca i8*
  store i8* %2412, i8** %2413
  call void @writeString(i8** %2413)
  %2414 = alloca [34 x i8]
  %2415 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 0
  store i8 72, i8* %2415
  %2416 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 1
  store i8 101, i8* %2416
  %2417 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 2
  store i8 114, i8* %2417
  %2418 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 3
  store i8 101, i8* %2418
  %2419 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 4
  store i8 39, i8* %2419
  %2420 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 5
  store i8 115, i8* %2420
  %2421 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 6
  store i8 32, i8* %2421
  %2422 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 7
  store i8 121, i8* %2422
  %2423 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 8
  store i8 111, i8* %2423
  %2424 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 9
  store i8 117, i8* %2424
  %2425 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 10
  store i8 114, i8* %2425
  %2426 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 11
  store i8 32, i8* %2426
  %2427 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 12
  store i8 114, i8* %2427
  %2428 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 13
  store i8 101, i8* %2428
  %2429 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 14
  store i8 97, i8* %2429
  %2430 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 15
  store i8 108, i8* %2430
  %2431 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 16
  store i8 32, i8* %2431
  %2432 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 17
  store i8 47, i8* %2432
  %2433 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 18
  store i8 32, i8* %2433
  %2434 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 19
  store i8 121, i8* %2434
  %2435 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 20
  store i8 111, i8* %2435
  %2436 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 21
  store i8 117, i8* %2436
  %2437 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 22
  store i8 114, i8* %2437
  %2438 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 23
  store i8 32, i8* %2438
  %2439 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 24
  store i8 105, i8* %2439
  %2440 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 25
  store i8 110, i8* %2440
  %2441 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 26
  store i8 116, i8* %2441
  %2442 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 27
  store i8 101, i8* %2442
  %2443 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 28
  store i8 103, i8* %2443
  %2444 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 29
  store i8 101, i8* %2444
  %2445 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 30
  store i8 114, i8* %2445
  %2446 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 31
  store i8 58, i8* %2446
  %2447 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 32
  store i8 32, i8* %2447
  %2448 = getelementptr [34 x i8], [34 x i8]* %2414, i16 0, i16 33
  store i8 0, i8* %2448
  %2449 = getelementptr inbounds [34 x i8], [34 x i8]* %2414, i16 0, i16 0
  %2450 = alloca i8*
  store i8* %2449, i8** %2450
  call void @writeString(i8** %2450)
  %2451 = load double, double* %9
  %2452 = load i16, i16* %1
  %2453 = sitofp i16 %2452 to double
  %2454 = fdiv double %2451, %2453
  call void @writeReal(double %2454)
  %2455 = alloca [2 x i8]
  %2456 = getelementptr [2 x i8], [2 x i8]* %2455, i16 0, i16 0
  store i8 10, i8* %2456
  %2457 = getelementptr [2 x i8], [2 x i8]* %2455, i16 0, i16 1
  store i8 0, i8* %2457
  %2458 = getelementptr inbounds [2 x i8], [2 x i8]* %2455, i16 0, i16 0
  %2459 = alloca i8*
  store i8* %2458, i8** %2459
  call void @writeString(i8** %2459)
  %2460 = alloca [34 x i8]
  %2461 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 0
  store i8 72, i8* %2461
  %2462 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 1
  store i8 101, i8* %2462
  %2463 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 2
  store i8 114, i8* %2463
  %2464 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 3
  store i8 101, i8* %2464
  %2465 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 4
  store i8 39, i8* %2465
  %2466 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 5
  store i8 115, i8* %2466
  %2467 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 6
  store i8 32, i8* %2467
  %2468 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 7
  store i8 121, i8* %2468
  %2469 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 8
  store i8 111, i8* %2469
  %2470 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 9
  store i8 117, i8* %2470
  %2471 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 10
  store i8 114, i8* %2471
  %2472 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 11
  store i8 32, i8* %2472
  %2473 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 12
  store i8 114, i8* %2473
  %2474 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 13
  store i8 101, i8* %2474
  %2475 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 14
  store i8 97, i8* %2475
  %2476 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 15
  store i8 108, i8* %2476
  %2477 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 16
  store i8 32, i8* %2477
  %2478 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 17
  store i8 60, i8* %2478
  %2479 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 18
  store i8 32, i8* %2479
  %2480 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 19
  store i8 121, i8* %2480
  %2481 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 20
  store i8 111, i8* %2481
  %2482 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 21
  store i8 117, i8* %2482
  %2483 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 22
  store i8 114, i8* %2483
  %2484 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 23
  store i8 32, i8* %2484
  %2485 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 24
  store i8 105, i8* %2485
  %2486 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 25
  store i8 110, i8* %2486
  %2487 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 26
  store i8 116, i8* %2487
  %2488 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 27
  store i8 101, i8* %2488
  %2489 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 28
  store i8 103, i8* %2489
  %2490 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 29
  store i8 101, i8* %2490
  %2491 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 30
  store i8 114, i8* %2491
  %2492 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 31
  store i8 58, i8* %2492
  %2493 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 32
  store i8 32, i8* %2493
  %2494 = getelementptr [34 x i8], [34 x i8]* %2460, i16 0, i16 33
  store i8 0, i8* %2494
  %2495 = getelementptr inbounds [34 x i8], [34 x i8]* %2460, i16 0, i16 0
  %2496 = alloca i8*
  store i8* %2495, i8** %2496
  call void @writeString(i8** %2496)
  %2497 = load double, double* %9
  %2498 = load i16, i16* %1
  %2499 = sitofp i16 %2498 to double
  %2500 = fcmp olt double %2497, %2499
  call void @writeBoolean(i1 %2500)
  %2501 = alloca [2 x i8]
  %2502 = getelementptr [2 x i8], [2 x i8]* %2501, i16 0, i16 0
  store i8 10, i8* %2502
  %2503 = getelementptr [2 x i8], [2 x i8]* %2501, i16 0, i16 1
  store i8 0, i8* %2503
  %2504 = getelementptr inbounds [2 x i8], [2 x i8]* %2501, i16 0, i16 0
  %2505 = alloca i8*
  store i8* %2504, i8** %2505
  call void @writeString(i8** %2505)
  %2506 = alloca [34 x i8]
  %2507 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 0
  store i8 72, i8* %2507
  %2508 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 1
  store i8 101, i8* %2508
  %2509 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 2
  store i8 114, i8* %2509
  %2510 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 3
  store i8 101, i8* %2510
  %2511 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 4
  store i8 39, i8* %2511
  %2512 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 5
  store i8 115, i8* %2512
  %2513 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 6
  store i8 32, i8* %2513
  %2514 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 7
  store i8 121, i8* %2514
  %2515 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 8
  store i8 111, i8* %2515
  %2516 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 9
  store i8 117, i8* %2516
  %2517 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 10
  store i8 114, i8* %2517
  %2518 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 11
  store i8 32, i8* %2518
  %2519 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 12
  store i8 114, i8* %2519
  %2520 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 13
  store i8 101, i8* %2520
  %2521 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 14
  store i8 97, i8* %2521
  %2522 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 15
  store i8 108, i8* %2522
  %2523 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 16
  store i8 32, i8* %2523
  %2524 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 17
  store i8 62, i8* %2524
  %2525 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 18
  store i8 32, i8* %2525
  %2526 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 19
  store i8 121, i8* %2526
  %2527 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 20
  store i8 111, i8* %2527
  %2528 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 21
  store i8 117, i8* %2528
  %2529 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 22
  store i8 114, i8* %2529
  %2530 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 23
  store i8 32, i8* %2530
  %2531 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 24
  store i8 105, i8* %2531
  %2532 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 25
  store i8 110, i8* %2532
  %2533 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 26
  store i8 116, i8* %2533
  %2534 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 27
  store i8 101, i8* %2534
  %2535 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 28
  store i8 103, i8* %2535
  %2536 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 29
  store i8 101, i8* %2536
  %2537 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 30
  store i8 114, i8* %2537
  %2538 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 31
  store i8 58, i8* %2538
  %2539 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 32
  store i8 32, i8* %2539
  %2540 = getelementptr [34 x i8], [34 x i8]* %2506, i16 0, i16 33
  store i8 0, i8* %2540
  %2541 = getelementptr inbounds [34 x i8], [34 x i8]* %2506, i16 0, i16 0
  %2542 = alloca i8*
  store i8* %2541, i8** %2542
  call void @writeString(i8** %2542)
  %2543 = load double, double* %9
  %2544 = load i16, i16* %1
  %2545 = sitofp i16 %2544 to double
  %2546 = fcmp ogt double %2543, %2545
  call void @writeBoolean(i1 %2546)
  %2547 = alloca [2 x i8]
  %2548 = getelementptr [2 x i8], [2 x i8]* %2547, i16 0, i16 0
  store i8 10, i8* %2548
  %2549 = getelementptr [2 x i8], [2 x i8]* %2547, i16 0, i16 1
  store i8 0, i8* %2549
  %2550 = getelementptr inbounds [2 x i8], [2 x i8]* %2547, i16 0, i16 0
  %2551 = alloca i8*
  store i8* %2550, i8** %2551
  call void @writeString(i8** %2551)
  %2552 = alloca [35 x i8]
  %2553 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 0
  store i8 72, i8* %2553
  %2554 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 1
  store i8 101, i8* %2554
  %2555 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 2
  store i8 114, i8* %2555
  %2556 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 3
  store i8 101, i8* %2556
  %2557 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 4
  store i8 39, i8* %2557
  %2558 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 5
  store i8 115, i8* %2558
  %2559 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 6
  store i8 32, i8* %2559
  %2560 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 7
  store i8 121, i8* %2560
  %2561 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 8
  store i8 111, i8* %2561
  %2562 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 9
  store i8 117, i8* %2562
  %2563 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 10
  store i8 114, i8* %2563
  %2564 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 11
  store i8 32, i8* %2564
  %2565 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 12
  store i8 114, i8* %2565
  %2566 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 13
  store i8 101, i8* %2566
  %2567 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 14
  store i8 97, i8* %2567
  %2568 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 15
  store i8 108, i8* %2568
  %2569 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 16
  store i8 32, i8* %2569
  %2570 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 17
  store i8 60, i8* %2570
  %2571 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 18
  store i8 61, i8* %2571
  %2572 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 19
  store i8 32, i8* %2572
  %2573 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 20
  store i8 121, i8* %2573
  %2574 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 21
  store i8 111, i8* %2574
  %2575 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 22
  store i8 117, i8* %2575
  %2576 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 23
  store i8 114, i8* %2576
  %2577 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 24
  store i8 32, i8* %2577
  %2578 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 25
  store i8 105, i8* %2578
  %2579 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 26
  store i8 110, i8* %2579
  %2580 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 27
  store i8 116, i8* %2580
  %2581 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 28
  store i8 101, i8* %2581
  %2582 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 29
  store i8 103, i8* %2582
  %2583 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 30
  store i8 101, i8* %2583
  %2584 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 31
  store i8 114, i8* %2584
  %2585 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 32
  store i8 58, i8* %2585
  %2586 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 33
  store i8 32, i8* %2586
  %2587 = getelementptr [35 x i8], [35 x i8]* %2552, i16 0, i16 34
  store i8 0, i8* %2587
  %2588 = getelementptr inbounds [35 x i8], [35 x i8]* %2552, i16 0, i16 0
  %2589 = alloca i8*
  store i8* %2588, i8** %2589
  call void @writeString(i8** %2589)
  %2590 = load double, double* %9
  %2591 = load i16, i16* %1
  %2592 = sitofp i16 %2591 to double
  %2593 = fcmp ole double %2590, %2592
  call void @writeBoolean(i1 %2593)
  %2594 = alloca [2 x i8]
  %2595 = getelementptr [2 x i8], [2 x i8]* %2594, i16 0, i16 0
  store i8 10, i8* %2595
  %2596 = getelementptr [2 x i8], [2 x i8]* %2594, i16 0, i16 1
  store i8 0, i8* %2596
  %2597 = getelementptr inbounds [2 x i8], [2 x i8]* %2594, i16 0, i16 0
  %2598 = alloca i8*
  store i8* %2597, i8** %2598
  call void @writeString(i8** %2598)
  %2599 = alloca [35 x i8]
  %2600 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 0
  store i8 72, i8* %2600
  %2601 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 1
  store i8 101, i8* %2601
  %2602 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 2
  store i8 114, i8* %2602
  %2603 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 3
  store i8 101, i8* %2603
  %2604 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 4
  store i8 39, i8* %2604
  %2605 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 5
  store i8 115, i8* %2605
  %2606 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 6
  store i8 32, i8* %2606
  %2607 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 7
  store i8 121, i8* %2607
  %2608 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 8
  store i8 111, i8* %2608
  %2609 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 9
  store i8 117, i8* %2609
  %2610 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 10
  store i8 114, i8* %2610
  %2611 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 11
  store i8 32, i8* %2611
  %2612 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 12
  store i8 114, i8* %2612
  %2613 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 13
  store i8 101, i8* %2613
  %2614 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 14
  store i8 97, i8* %2614
  %2615 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 15
  store i8 108, i8* %2615
  %2616 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 16
  store i8 32, i8* %2616
  %2617 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 17
  store i8 62, i8* %2617
  %2618 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 18
  store i8 61, i8* %2618
  %2619 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 19
  store i8 32, i8* %2619
  %2620 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 20
  store i8 121, i8* %2620
  %2621 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 21
  store i8 111, i8* %2621
  %2622 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 22
  store i8 117, i8* %2622
  %2623 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 23
  store i8 114, i8* %2623
  %2624 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 24
  store i8 32, i8* %2624
  %2625 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 25
  store i8 105, i8* %2625
  %2626 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 26
  store i8 110, i8* %2626
  %2627 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 27
  store i8 116, i8* %2627
  %2628 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 28
  store i8 101, i8* %2628
  %2629 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 29
  store i8 103, i8* %2629
  %2630 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 30
  store i8 101, i8* %2630
  %2631 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 31
  store i8 114, i8* %2631
  %2632 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 32
  store i8 58, i8* %2632
  %2633 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 33
  store i8 32, i8* %2633
  %2634 = getelementptr [35 x i8], [35 x i8]* %2599, i16 0, i16 34
  store i8 0, i8* %2634
  %2635 = getelementptr inbounds [35 x i8], [35 x i8]* %2599, i16 0, i16 0
  %2636 = alloca i8*
  store i8* %2635, i8** %2636
  call void @writeString(i8** %2636)
  %2637 = load double, double* %9
  %2638 = load i16, i16* %1
  %2639 = sitofp i16 %2638 to double
  %2640 = fcmp oge double %2637, %2639
  call void @writeBoolean(i1 %2640)
  %2641 = alloca [2 x i8]
  %2642 = getelementptr [2 x i8], [2 x i8]* %2641, i16 0, i16 0
  store i8 10, i8* %2642
  %2643 = getelementptr [2 x i8], [2 x i8]* %2641, i16 0, i16 1
  store i8 0, i8* %2643
  %2644 = getelementptr inbounds [2 x i8], [2 x i8]* %2641, i16 0, i16 0
  %2645 = alloca i8*
  store i8* %2644, i8** %2645
  call void @writeString(i8** %2645)
  %2646 = alloca [34 x i8]
  %2647 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 0
  store i8 72, i8* %2647
  %2648 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 1
  store i8 101, i8* %2648
  %2649 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 2
  store i8 114, i8* %2649
  %2650 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 3
  store i8 101, i8* %2650
  %2651 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 4
  store i8 39, i8* %2651
  %2652 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 5
  store i8 115, i8* %2652
  %2653 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 6
  store i8 32, i8* %2653
  %2654 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 7
  store i8 121, i8* %2654
  %2655 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 8
  store i8 111, i8* %2655
  %2656 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 9
  store i8 117, i8* %2656
  %2657 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 10
  store i8 114, i8* %2657
  %2658 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 11
  store i8 32, i8* %2658
  %2659 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 12
  store i8 114, i8* %2659
  %2660 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 13
  store i8 101, i8* %2660
  %2661 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 14
  store i8 97, i8* %2661
  %2662 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 15
  store i8 108, i8* %2662
  %2663 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 16
  store i8 32, i8* %2663
  %2664 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 17
  store i8 61, i8* %2664
  %2665 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 18
  store i8 32, i8* %2665
  %2666 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 19
  store i8 121, i8* %2666
  %2667 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 20
  store i8 111, i8* %2667
  %2668 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 21
  store i8 117, i8* %2668
  %2669 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 22
  store i8 114, i8* %2669
  %2670 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 23
  store i8 32, i8* %2670
  %2671 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 24
  store i8 105, i8* %2671
  %2672 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 25
  store i8 110, i8* %2672
  %2673 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 26
  store i8 116, i8* %2673
  %2674 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 27
  store i8 101, i8* %2674
  %2675 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 28
  store i8 103, i8* %2675
  %2676 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 29
  store i8 101, i8* %2676
  %2677 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 30
  store i8 114, i8* %2677
  %2678 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 31
  store i8 58, i8* %2678
  %2679 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 32
  store i8 32, i8* %2679
  %2680 = getelementptr [34 x i8], [34 x i8]* %2646, i16 0, i16 33
  store i8 0, i8* %2680
  %2681 = getelementptr inbounds [34 x i8], [34 x i8]* %2646, i16 0, i16 0
  %2682 = alloca i8*
  store i8* %2681, i8** %2682
  call void @writeString(i8** %2682)
  %2683 = load double, double* %9
  %2684 = load i16, i16* %1
  %2685 = sitofp i16 %2684 to double
  %2686 = fcmp oeq double %2683, %2685
  call void @writeBoolean(i1 %2686)
  %2687 = alloca [2 x i8]
  %2688 = getelementptr [2 x i8], [2 x i8]* %2687, i16 0, i16 0
  store i8 10, i8* %2688
  %2689 = getelementptr [2 x i8], [2 x i8]* %2687, i16 0, i16 1
  store i8 0, i8* %2689
  %2690 = getelementptr inbounds [2 x i8], [2 x i8]* %2687, i16 0, i16 0
  %2691 = alloca i8*
  store i8* %2690, i8** %2691
  call void @writeString(i8** %2691)
  %2692 = alloca [35 x i8]
  %2693 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 0
  store i8 72, i8* %2693
  %2694 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 1
  store i8 101, i8* %2694
  %2695 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 2
  store i8 114, i8* %2695
  %2696 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 3
  store i8 101, i8* %2696
  %2697 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 4
  store i8 39, i8* %2697
  %2698 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 5
  store i8 115, i8* %2698
  %2699 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 6
  store i8 32, i8* %2699
  %2700 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 7
  store i8 121, i8* %2700
  %2701 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 8
  store i8 111, i8* %2701
  %2702 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 9
  store i8 117, i8* %2702
  %2703 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 10
  store i8 114, i8* %2703
  %2704 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 11
  store i8 32, i8* %2704
  %2705 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 12
  store i8 114, i8* %2705
  %2706 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 13
  store i8 101, i8* %2706
  %2707 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 14
  store i8 97, i8* %2707
  %2708 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 15
  store i8 108, i8* %2708
  %2709 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 16
  store i8 32, i8* %2709
  %2710 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 17
  store i8 60, i8* %2710
  %2711 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 18
  store i8 62, i8* %2711
  %2712 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 19
  store i8 32, i8* %2712
  %2713 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 20
  store i8 121, i8* %2713
  %2714 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 21
  store i8 111, i8* %2714
  %2715 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 22
  store i8 117, i8* %2715
  %2716 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 23
  store i8 114, i8* %2716
  %2717 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 24
  store i8 32, i8* %2717
  %2718 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 25
  store i8 105, i8* %2718
  %2719 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 26
  store i8 110, i8* %2719
  %2720 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 27
  store i8 116, i8* %2720
  %2721 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 28
  store i8 101, i8* %2721
  %2722 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 29
  store i8 103, i8* %2722
  %2723 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 30
  store i8 101, i8* %2723
  %2724 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 31
  store i8 114, i8* %2724
  %2725 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 32
  store i8 58, i8* %2725
  %2726 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 33
  store i8 32, i8* %2726
  %2727 = getelementptr [35 x i8], [35 x i8]* %2692, i16 0, i16 34
  store i8 0, i8* %2727
  %2728 = getelementptr inbounds [35 x i8], [35 x i8]* %2692, i16 0, i16 0
  %2729 = alloca i8*
  store i8* %2728, i8** %2729
  call void @writeString(i8** %2729)
  %2730 = load double, double* %9
  %2731 = load i16, i16* %1
  %2732 = sitofp i16 %2731 to double
  %2733 = fcmp one double %2730, %2732
  call void @writeBoolean(i1 %2733)
  %2734 = alloca [2 x i8]
  %2735 = getelementptr [2 x i8], [2 x i8]* %2734, i16 0, i16 0
  store i8 10, i8* %2735
  %2736 = getelementptr [2 x i8], [2 x i8]* %2734, i16 0, i16 1
  store i8 0, i8* %2736
  %2737 = getelementptr inbounds [2 x i8], [2 x i8]* %2734, i16 0, i16 0
  %2738 = alloca i8*
  store i8* %2737, i8** %2738
  call void @writeString(i8** %2738)
  %2739 = alloca [17 x i8]
  %2740 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 0
  store i8 71, i8* %2740
  %2741 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 1
  store i8 105, i8* %2741
  %2742 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 2
  store i8 118, i8* %2742
  %2743 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 3
  store i8 101, i8* %2743
  %2744 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 4
  store i8 32, i8* %2744
  %2745 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 5
  store i8 109, i8* %2745
  %2746 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 6
  store i8 101, i8* %2746
  %2747 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 7
  store i8 32, i8* %2747
  %2748 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 8
  store i8 97, i8* %2748
  %2749 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 9
  store i8 32, i8* %2749
  %2750 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 10
  store i8 114, i8* %2750
  %2751 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 11
  store i8 101, i8* %2751
  %2752 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 12
  store i8 97, i8* %2752
  %2753 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 13
  store i8 108, i8* %2753
  %2754 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 14
  store i8 58, i8* %2754
  %2755 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 15
  store i8 32, i8* %2755
  %2756 = getelementptr [17 x i8], [17 x i8]* %2739, i16 0, i16 16
  store i8 0, i8* %2756
  %2757 = getelementptr inbounds [17 x i8], [17 x i8]* %2739, i16 0, i16 0
  %2758 = alloca i8*
  store i8* %2757, i8** %2758
  call void @writeString(i8** %2758)
  %2759 = call double @readReal()
  store double %2759, double* %10
  %2760 = alloca [23 x i8]
  %2761 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 0
  store i8 71, i8* %2761
  %2762 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 1
  store i8 105, i8* %2762
  %2763 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 2
  store i8 118, i8* %2763
  %2764 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 3
  store i8 101, i8* %2764
  %2765 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 4
  store i8 32, i8* %2765
  %2766 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 5
  store i8 109, i8* %2766
  %2767 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 6
  store i8 101, i8* %2767
  %2768 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 7
  store i8 32, i8* %2768
  %2769 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 8
  store i8 97, i8* %2769
  %2770 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 9
  store i8 110, i8* %2770
  %2771 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 10
  store i8 111, i8* %2771
  %2772 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 11
  store i8 116, i8* %2772
  %2773 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 12
  store i8 104, i8* %2773
  %2774 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 13
  store i8 101, i8* %2774
  %2775 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 14
  store i8 114, i8* %2775
  %2776 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 15
  store i8 32, i8* %2776
  %2777 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 16
  store i8 114, i8* %2777
  %2778 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 17
  store i8 101, i8* %2778
  %2779 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 18
  store i8 97, i8* %2779
  %2780 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 19
  store i8 108, i8* %2780
  %2781 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 20
  store i8 58, i8* %2781
  %2782 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 21
  store i8 32, i8* %2782
  %2783 = getelementptr [23 x i8], [23 x i8]* %2760, i16 0, i16 22
  store i8 0, i8* %2783
  %2784 = getelementptr inbounds [23 x i8], [23 x i8]* %2760, i16 0, i16 0
  %2785 = alloca i8*
  store i8* %2784, i8** %2785
  call void @writeString(i8** %2785)
  %2786 = call double @readReal()
  store double %2786, double* %11
  %2787 = alloca [37 x i8]
  %2788 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 0
  store i8 72, i8* %2788
  %2789 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 1
  store i8 101, i8* %2789
  %2790 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 2
  store i8 114, i8* %2790
  %2791 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 3
  store i8 101, i8* %2791
  %2792 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 4
  store i8 39, i8* %2792
  %2793 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 5
  store i8 115, i8* %2793
  %2794 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 6
  store i8 32, i8* %2794
  %2795 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 7
  store i8 121, i8* %2795
  %2796 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 8
  store i8 111, i8* %2796
  %2797 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 9
  store i8 117, i8* %2797
  %2798 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 10
  store i8 114, i8* %2798
  %2799 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 11
  store i8 32, i8* %2799
  %2800 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 12
  store i8 114, i8* %2800
  %2801 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 13
  store i8 101, i8* %2801
  %2802 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 14
  store i8 97, i8* %2802
  %2803 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 15
  store i8 108, i8* %2803
  %2804 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 16
  store i8 32, i8* %2804
  %2805 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 17
  store i8 43, i8* %2805
  %2806 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 18
  store i8 32, i8* %2806
  %2807 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 19
  store i8 121, i8* %2807
  %2808 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 20
  store i8 111, i8* %2808
  %2809 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 21
  store i8 117, i8* %2809
  %2810 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 22
  store i8 114, i8* %2810
  %2811 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 23
  store i8 32, i8* %2811
  %2812 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 24
  store i8 111, i8* %2812
  %2813 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 25
  store i8 116, i8* %2813
  %2814 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 26
  store i8 104, i8* %2814
  %2815 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 27
  store i8 101, i8* %2815
  %2816 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 28
  store i8 114, i8* %2816
  %2817 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 29
  store i8 32, i8* %2817
  %2818 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 30
  store i8 114, i8* %2818
  %2819 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 31
  store i8 101, i8* %2819
  %2820 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 32
  store i8 97, i8* %2820
  %2821 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 33
  store i8 108, i8* %2821
  %2822 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 34
  store i8 58, i8* %2822
  %2823 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 35
  store i8 32, i8* %2823
  %2824 = getelementptr [37 x i8], [37 x i8]* %2787, i16 0, i16 36
  store i8 0, i8* %2824
  %2825 = getelementptr inbounds [37 x i8], [37 x i8]* %2787, i16 0, i16 0
  %2826 = alloca i8*
  store i8* %2825, i8** %2826
  call void @writeString(i8** %2826)
  %2827 = load double, double* %10
  %2828 = load double, double* %11
  %2829 = fadd double %2827, %2828
  call void @writeReal(double %2829)
  %2830 = alloca [2 x i8]
  %2831 = getelementptr [2 x i8], [2 x i8]* %2830, i16 0, i16 0
  store i8 10, i8* %2831
  %2832 = getelementptr [2 x i8], [2 x i8]* %2830, i16 0, i16 1
  store i8 0, i8* %2832
  %2833 = getelementptr inbounds [2 x i8], [2 x i8]* %2830, i16 0, i16 0
  %2834 = alloca i8*
  store i8* %2833, i8** %2834
  call void @writeString(i8** %2834)
  %2835 = alloca [37 x i8]
  %2836 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 0
  store i8 72, i8* %2836
  %2837 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 1
  store i8 101, i8* %2837
  %2838 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 2
  store i8 114, i8* %2838
  %2839 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 3
  store i8 101, i8* %2839
  %2840 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 4
  store i8 39, i8* %2840
  %2841 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 5
  store i8 115, i8* %2841
  %2842 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 6
  store i8 32, i8* %2842
  %2843 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 7
  store i8 121, i8* %2843
  %2844 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 8
  store i8 111, i8* %2844
  %2845 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 9
  store i8 117, i8* %2845
  %2846 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 10
  store i8 114, i8* %2846
  %2847 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 11
  store i8 32, i8* %2847
  %2848 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 12
  store i8 114, i8* %2848
  %2849 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 13
  store i8 101, i8* %2849
  %2850 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 14
  store i8 97, i8* %2850
  %2851 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 15
  store i8 108, i8* %2851
  %2852 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 16
  store i8 32, i8* %2852
  %2853 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 17
  store i8 42, i8* %2853
  %2854 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 18
  store i8 32, i8* %2854
  %2855 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 19
  store i8 121, i8* %2855
  %2856 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 20
  store i8 111, i8* %2856
  %2857 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 21
  store i8 117, i8* %2857
  %2858 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 22
  store i8 114, i8* %2858
  %2859 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 23
  store i8 32, i8* %2859
  %2860 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 24
  store i8 111, i8* %2860
  %2861 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 25
  store i8 116, i8* %2861
  %2862 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 26
  store i8 104, i8* %2862
  %2863 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 27
  store i8 101, i8* %2863
  %2864 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 28
  store i8 114, i8* %2864
  %2865 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 29
  store i8 32, i8* %2865
  %2866 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 30
  store i8 114, i8* %2866
  %2867 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 31
  store i8 101, i8* %2867
  %2868 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 32
  store i8 97, i8* %2868
  %2869 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 33
  store i8 108, i8* %2869
  %2870 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 34
  store i8 58, i8* %2870
  %2871 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 35
  store i8 32, i8* %2871
  %2872 = getelementptr [37 x i8], [37 x i8]* %2835, i16 0, i16 36
  store i8 0, i8* %2872
  %2873 = getelementptr inbounds [37 x i8], [37 x i8]* %2835, i16 0, i16 0
  %2874 = alloca i8*
  store i8* %2873, i8** %2874
  call void @writeString(i8** %2874)
  %2875 = load double, double* %10
  %2876 = load double, double* %11
  %2877 = fmul double %2875, %2876
  call void @writeReal(double %2877)
  %2878 = alloca [2 x i8]
  %2879 = getelementptr [2 x i8], [2 x i8]* %2878, i16 0, i16 0
  store i8 10, i8* %2879
  %2880 = getelementptr [2 x i8], [2 x i8]* %2878, i16 0, i16 1
  store i8 0, i8* %2880
  %2881 = getelementptr inbounds [2 x i8], [2 x i8]* %2878, i16 0, i16 0
  %2882 = alloca i8*
  store i8* %2881, i8** %2882
  call void @writeString(i8** %2882)
  %2883 = alloca [37 x i8]
  %2884 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 0
  store i8 72, i8* %2884
  %2885 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 1
  store i8 101, i8* %2885
  %2886 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 2
  store i8 114, i8* %2886
  %2887 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 3
  store i8 101, i8* %2887
  %2888 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 4
  store i8 39, i8* %2888
  %2889 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 5
  store i8 115, i8* %2889
  %2890 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 6
  store i8 32, i8* %2890
  %2891 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 7
  store i8 121, i8* %2891
  %2892 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 8
  store i8 111, i8* %2892
  %2893 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 9
  store i8 117, i8* %2893
  %2894 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 10
  store i8 114, i8* %2894
  %2895 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 11
  store i8 32, i8* %2895
  %2896 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 12
  store i8 114, i8* %2896
  %2897 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 13
  store i8 101, i8* %2897
  %2898 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 14
  store i8 97, i8* %2898
  %2899 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 15
  store i8 108, i8* %2899
  %2900 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 16
  store i8 32, i8* %2900
  %2901 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 17
  store i8 45, i8* %2901
  %2902 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 18
  store i8 32, i8* %2902
  %2903 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 19
  store i8 121, i8* %2903
  %2904 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 20
  store i8 111, i8* %2904
  %2905 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 21
  store i8 117, i8* %2905
  %2906 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 22
  store i8 114, i8* %2906
  %2907 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 23
  store i8 32, i8* %2907
  %2908 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 24
  store i8 111, i8* %2908
  %2909 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 25
  store i8 116, i8* %2909
  %2910 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 26
  store i8 104, i8* %2910
  %2911 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 27
  store i8 101, i8* %2911
  %2912 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 28
  store i8 114, i8* %2912
  %2913 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 29
  store i8 32, i8* %2913
  %2914 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 30
  store i8 114, i8* %2914
  %2915 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 31
  store i8 101, i8* %2915
  %2916 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 32
  store i8 97, i8* %2916
  %2917 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 33
  store i8 108, i8* %2917
  %2918 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 34
  store i8 58, i8* %2918
  %2919 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 35
  store i8 32, i8* %2919
  %2920 = getelementptr [37 x i8], [37 x i8]* %2883, i16 0, i16 36
  store i8 0, i8* %2920
  %2921 = getelementptr inbounds [37 x i8], [37 x i8]* %2883, i16 0, i16 0
  %2922 = alloca i8*
  store i8* %2921, i8** %2922
  call void @writeString(i8** %2922)
  %2923 = load double, double* %10
  %2924 = load double, double* %11
  %2925 = fsub double %2923, %2924
  call void @writeReal(double %2925)
  %2926 = alloca [2 x i8]
  %2927 = getelementptr [2 x i8], [2 x i8]* %2926, i16 0, i16 0
  store i8 10, i8* %2927
  %2928 = getelementptr [2 x i8], [2 x i8]* %2926, i16 0, i16 1
  store i8 0, i8* %2928
  %2929 = getelementptr inbounds [2 x i8], [2 x i8]* %2926, i16 0, i16 0
  %2930 = alloca i8*
  store i8* %2929, i8** %2930
  call void @writeString(i8** %2930)
  %2931 = alloca [37 x i8]
  %2932 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 0
  store i8 72, i8* %2932
  %2933 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 1
  store i8 101, i8* %2933
  %2934 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 2
  store i8 114, i8* %2934
  %2935 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 3
  store i8 101, i8* %2935
  %2936 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 4
  store i8 39, i8* %2936
  %2937 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 5
  store i8 115, i8* %2937
  %2938 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 6
  store i8 32, i8* %2938
  %2939 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 7
  store i8 121, i8* %2939
  %2940 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 8
  store i8 111, i8* %2940
  %2941 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 9
  store i8 117, i8* %2941
  %2942 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 10
  store i8 114, i8* %2942
  %2943 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 11
  store i8 32, i8* %2943
  %2944 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 12
  store i8 114, i8* %2944
  %2945 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 13
  store i8 101, i8* %2945
  %2946 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 14
  store i8 97, i8* %2946
  %2947 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 15
  store i8 108, i8* %2947
  %2948 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 16
  store i8 32, i8* %2948
  %2949 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 17
  store i8 47, i8* %2949
  %2950 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 18
  store i8 32, i8* %2950
  %2951 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 19
  store i8 121, i8* %2951
  %2952 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 20
  store i8 111, i8* %2952
  %2953 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 21
  store i8 117, i8* %2953
  %2954 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 22
  store i8 114, i8* %2954
  %2955 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 23
  store i8 32, i8* %2955
  %2956 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 24
  store i8 111, i8* %2956
  %2957 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 25
  store i8 116, i8* %2957
  %2958 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 26
  store i8 104, i8* %2958
  %2959 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 27
  store i8 101, i8* %2959
  %2960 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 28
  store i8 114, i8* %2960
  %2961 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 29
  store i8 32, i8* %2961
  %2962 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 30
  store i8 114, i8* %2962
  %2963 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 31
  store i8 101, i8* %2963
  %2964 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 32
  store i8 97, i8* %2964
  %2965 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 33
  store i8 108, i8* %2965
  %2966 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 34
  store i8 58, i8* %2966
  %2967 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 35
  store i8 32, i8* %2967
  %2968 = getelementptr [37 x i8], [37 x i8]* %2931, i16 0, i16 36
  store i8 0, i8* %2968
  %2969 = getelementptr inbounds [37 x i8], [37 x i8]* %2931, i16 0, i16 0
  %2970 = alloca i8*
  store i8* %2969, i8** %2970
  call void @writeString(i8** %2970)
  %2971 = load double, double* %10
  %2972 = load double, double* %11
  %2973 = fdiv double %2971, %2972
  call void @writeReal(double %2973)
  %2974 = alloca [2 x i8]
  %2975 = getelementptr [2 x i8], [2 x i8]* %2974, i16 0, i16 0
  store i8 10, i8* %2975
  %2976 = getelementptr [2 x i8], [2 x i8]* %2974, i16 0, i16 1
  store i8 0, i8* %2976
  %2977 = getelementptr inbounds [2 x i8], [2 x i8]* %2974, i16 0, i16 0
  %2978 = alloca i8*
  store i8* %2977, i8** %2978
  call void @writeString(i8** %2978)
  %2979 = alloca [37 x i8]
  %2980 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 0
  store i8 72, i8* %2980
  %2981 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 1
  store i8 101, i8* %2981
  %2982 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 2
  store i8 114, i8* %2982
  %2983 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 3
  store i8 101, i8* %2983
  %2984 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 4
  store i8 39, i8* %2984
  %2985 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 5
  store i8 115, i8* %2985
  %2986 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 6
  store i8 32, i8* %2986
  %2987 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 7
  store i8 121, i8* %2987
  %2988 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 8
  store i8 111, i8* %2988
  %2989 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 9
  store i8 117, i8* %2989
  %2990 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 10
  store i8 114, i8* %2990
  %2991 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 11
  store i8 32, i8* %2991
  %2992 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 12
  store i8 114, i8* %2992
  %2993 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 13
  store i8 101, i8* %2993
  %2994 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 14
  store i8 97, i8* %2994
  %2995 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 15
  store i8 108, i8* %2995
  %2996 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 16
  store i8 32, i8* %2996
  %2997 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 17
  store i8 60, i8* %2997
  %2998 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 18
  store i8 32, i8* %2998
  %2999 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 19
  store i8 121, i8* %2999
  %3000 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 20
  store i8 111, i8* %3000
  %3001 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 21
  store i8 117, i8* %3001
  %3002 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 22
  store i8 114, i8* %3002
  %3003 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 23
  store i8 32, i8* %3003
  %3004 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 24
  store i8 111, i8* %3004
  %3005 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 25
  store i8 116, i8* %3005
  %3006 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 26
  store i8 104, i8* %3006
  %3007 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 27
  store i8 101, i8* %3007
  %3008 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 28
  store i8 114, i8* %3008
  %3009 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 29
  store i8 32, i8* %3009
  %3010 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 30
  store i8 114, i8* %3010
  %3011 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 31
  store i8 101, i8* %3011
  %3012 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 32
  store i8 97, i8* %3012
  %3013 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 33
  store i8 108, i8* %3013
  %3014 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 34
  store i8 58, i8* %3014
  %3015 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 35
  store i8 32, i8* %3015
  %3016 = getelementptr [37 x i8], [37 x i8]* %2979, i16 0, i16 36
  store i8 0, i8* %3016
  %3017 = getelementptr inbounds [37 x i8], [37 x i8]* %2979, i16 0, i16 0
  %3018 = alloca i8*
  store i8* %3017, i8** %3018
  call void @writeString(i8** %3018)
  %3019 = load double, double* %10
  %3020 = load double, double* %11
  %3021 = fcmp olt double %3019, %3020
  call void @writeBoolean(i1 %3021)
  %3022 = alloca [2 x i8]
  %3023 = getelementptr [2 x i8], [2 x i8]* %3022, i16 0, i16 0
  store i8 10, i8* %3023
  %3024 = getelementptr [2 x i8], [2 x i8]* %3022, i16 0, i16 1
  store i8 0, i8* %3024
  %3025 = getelementptr inbounds [2 x i8], [2 x i8]* %3022, i16 0, i16 0
  %3026 = alloca i8*
  store i8* %3025, i8** %3026
  call void @writeString(i8** %3026)
  %3027 = alloca [37 x i8]
  %3028 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 0
  store i8 72, i8* %3028
  %3029 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 1
  store i8 101, i8* %3029
  %3030 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 2
  store i8 114, i8* %3030
  %3031 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 3
  store i8 101, i8* %3031
  %3032 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 4
  store i8 39, i8* %3032
  %3033 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 5
  store i8 115, i8* %3033
  %3034 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 6
  store i8 32, i8* %3034
  %3035 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 7
  store i8 121, i8* %3035
  %3036 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 8
  store i8 111, i8* %3036
  %3037 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 9
  store i8 117, i8* %3037
  %3038 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 10
  store i8 114, i8* %3038
  %3039 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 11
  store i8 32, i8* %3039
  %3040 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 12
  store i8 114, i8* %3040
  %3041 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 13
  store i8 101, i8* %3041
  %3042 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 14
  store i8 97, i8* %3042
  %3043 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 15
  store i8 108, i8* %3043
  %3044 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 16
  store i8 32, i8* %3044
  %3045 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 17
  store i8 62, i8* %3045
  %3046 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 18
  store i8 32, i8* %3046
  %3047 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 19
  store i8 121, i8* %3047
  %3048 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 20
  store i8 111, i8* %3048
  %3049 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 21
  store i8 117, i8* %3049
  %3050 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 22
  store i8 114, i8* %3050
  %3051 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 23
  store i8 32, i8* %3051
  %3052 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 24
  store i8 111, i8* %3052
  %3053 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 25
  store i8 116, i8* %3053
  %3054 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 26
  store i8 104, i8* %3054
  %3055 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 27
  store i8 101, i8* %3055
  %3056 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 28
  store i8 114, i8* %3056
  %3057 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 29
  store i8 32, i8* %3057
  %3058 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 30
  store i8 114, i8* %3058
  %3059 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 31
  store i8 101, i8* %3059
  %3060 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 32
  store i8 97, i8* %3060
  %3061 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 33
  store i8 108, i8* %3061
  %3062 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 34
  store i8 58, i8* %3062
  %3063 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 35
  store i8 32, i8* %3063
  %3064 = getelementptr [37 x i8], [37 x i8]* %3027, i16 0, i16 36
  store i8 0, i8* %3064
  %3065 = getelementptr inbounds [37 x i8], [37 x i8]* %3027, i16 0, i16 0
  %3066 = alloca i8*
  store i8* %3065, i8** %3066
  call void @writeString(i8** %3066)
  %3067 = load double, double* %10
  %3068 = load double, double* %11
  %3069 = fcmp ogt double %3067, %3068
  call void @writeBoolean(i1 %3069)
  %3070 = alloca [2 x i8]
  %3071 = getelementptr [2 x i8], [2 x i8]* %3070, i16 0, i16 0
  store i8 10, i8* %3071
  %3072 = getelementptr [2 x i8], [2 x i8]* %3070, i16 0, i16 1
  store i8 0, i8* %3072
  %3073 = getelementptr inbounds [2 x i8], [2 x i8]* %3070, i16 0, i16 0
  %3074 = alloca i8*
  store i8* %3073, i8** %3074
  call void @writeString(i8** %3074)
  %3075 = alloca [38 x i8]
  %3076 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 0
  store i8 72, i8* %3076
  %3077 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 1
  store i8 101, i8* %3077
  %3078 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 2
  store i8 114, i8* %3078
  %3079 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 3
  store i8 101, i8* %3079
  %3080 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 4
  store i8 39, i8* %3080
  %3081 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 5
  store i8 115, i8* %3081
  %3082 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 6
  store i8 32, i8* %3082
  %3083 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 7
  store i8 121, i8* %3083
  %3084 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 8
  store i8 111, i8* %3084
  %3085 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 9
  store i8 117, i8* %3085
  %3086 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 10
  store i8 114, i8* %3086
  %3087 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 11
  store i8 32, i8* %3087
  %3088 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 12
  store i8 114, i8* %3088
  %3089 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 13
  store i8 101, i8* %3089
  %3090 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 14
  store i8 97, i8* %3090
  %3091 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 15
  store i8 108, i8* %3091
  %3092 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 16
  store i8 32, i8* %3092
  %3093 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 17
  store i8 60, i8* %3093
  %3094 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 18
  store i8 61, i8* %3094
  %3095 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 19
  store i8 32, i8* %3095
  %3096 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 20
  store i8 121, i8* %3096
  %3097 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 21
  store i8 111, i8* %3097
  %3098 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 22
  store i8 117, i8* %3098
  %3099 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 23
  store i8 114, i8* %3099
  %3100 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 24
  store i8 32, i8* %3100
  %3101 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 25
  store i8 111, i8* %3101
  %3102 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 26
  store i8 116, i8* %3102
  %3103 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 27
  store i8 104, i8* %3103
  %3104 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 28
  store i8 101, i8* %3104
  %3105 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 29
  store i8 114, i8* %3105
  %3106 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 30
  store i8 32, i8* %3106
  %3107 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 31
  store i8 114, i8* %3107
  %3108 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 32
  store i8 101, i8* %3108
  %3109 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 33
  store i8 97, i8* %3109
  %3110 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 34
  store i8 108, i8* %3110
  %3111 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 35
  store i8 58, i8* %3111
  %3112 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 36
  store i8 32, i8* %3112
  %3113 = getelementptr [38 x i8], [38 x i8]* %3075, i16 0, i16 37
  store i8 0, i8* %3113
  %3114 = getelementptr inbounds [38 x i8], [38 x i8]* %3075, i16 0, i16 0
  %3115 = alloca i8*
  store i8* %3114, i8** %3115
  call void @writeString(i8** %3115)
  %3116 = load double, double* %10
  %3117 = load double, double* %11
  %3118 = fcmp ole double %3116, %3117
  call void @writeBoolean(i1 %3118)
  %3119 = alloca [2 x i8]
  %3120 = getelementptr [2 x i8], [2 x i8]* %3119, i16 0, i16 0
  store i8 10, i8* %3120
  %3121 = getelementptr [2 x i8], [2 x i8]* %3119, i16 0, i16 1
  store i8 0, i8* %3121
  %3122 = getelementptr inbounds [2 x i8], [2 x i8]* %3119, i16 0, i16 0
  %3123 = alloca i8*
  store i8* %3122, i8** %3123
  call void @writeString(i8** %3123)
  %3124 = alloca [38 x i8]
  %3125 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 0
  store i8 72, i8* %3125
  %3126 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 1
  store i8 101, i8* %3126
  %3127 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 2
  store i8 114, i8* %3127
  %3128 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 3
  store i8 101, i8* %3128
  %3129 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 4
  store i8 39, i8* %3129
  %3130 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 5
  store i8 115, i8* %3130
  %3131 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 6
  store i8 32, i8* %3131
  %3132 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 7
  store i8 121, i8* %3132
  %3133 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 8
  store i8 111, i8* %3133
  %3134 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 9
  store i8 117, i8* %3134
  %3135 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 10
  store i8 114, i8* %3135
  %3136 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 11
  store i8 32, i8* %3136
  %3137 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 12
  store i8 114, i8* %3137
  %3138 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 13
  store i8 101, i8* %3138
  %3139 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 14
  store i8 97, i8* %3139
  %3140 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 15
  store i8 108, i8* %3140
  %3141 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 16
  store i8 32, i8* %3141
  %3142 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 17
  store i8 62, i8* %3142
  %3143 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 18
  store i8 61, i8* %3143
  %3144 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 19
  store i8 32, i8* %3144
  %3145 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 20
  store i8 121, i8* %3145
  %3146 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 21
  store i8 111, i8* %3146
  %3147 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 22
  store i8 117, i8* %3147
  %3148 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 23
  store i8 114, i8* %3148
  %3149 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 24
  store i8 32, i8* %3149
  %3150 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 25
  store i8 111, i8* %3150
  %3151 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 26
  store i8 116, i8* %3151
  %3152 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 27
  store i8 104, i8* %3152
  %3153 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 28
  store i8 101, i8* %3153
  %3154 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 29
  store i8 114, i8* %3154
  %3155 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 30
  store i8 32, i8* %3155
  %3156 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 31
  store i8 114, i8* %3156
  %3157 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 32
  store i8 101, i8* %3157
  %3158 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 33
  store i8 97, i8* %3158
  %3159 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 34
  store i8 108, i8* %3159
  %3160 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 35
  store i8 58, i8* %3160
  %3161 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 36
  store i8 32, i8* %3161
  %3162 = getelementptr [38 x i8], [38 x i8]* %3124, i16 0, i16 37
  store i8 0, i8* %3162
  %3163 = getelementptr inbounds [38 x i8], [38 x i8]* %3124, i16 0, i16 0
  %3164 = alloca i8*
  store i8* %3163, i8** %3164
  call void @writeString(i8** %3164)
  %3165 = load double, double* %10
  %3166 = load double, double* %11
  %3167 = fcmp oge double %3165, %3166
  call void @writeBoolean(i1 %3167)
  %3168 = alloca [2 x i8]
  %3169 = getelementptr [2 x i8], [2 x i8]* %3168, i16 0, i16 0
  store i8 10, i8* %3169
  %3170 = getelementptr [2 x i8], [2 x i8]* %3168, i16 0, i16 1
  store i8 0, i8* %3170
  %3171 = getelementptr inbounds [2 x i8], [2 x i8]* %3168, i16 0, i16 0
  %3172 = alloca i8*
  store i8* %3171, i8** %3172
  call void @writeString(i8** %3172)
  %3173 = alloca [37 x i8]
  %3174 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 0
  store i8 72, i8* %3174
  %3175 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 1
  store i8 101, i8* %3175
  %3176 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 2
  store i8 114, i8* %3176
  %3177 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 3
  store i8 101, i8* %3177
  %3178 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 4
  store i8 39, i8* %3178
  %3179 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 5
  store i8 115, i8* %3179
  %3180 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 6
  store i8 32, i8* %3180
  %3181 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 7
  store i8 121, i8* %3181
  %3182 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 8
  store i8 111, i8* %3182
  %3183 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 9
  store i8 117, i8* %3183
  %3184 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 10
  store i8 114, i8* %3184
  %3185 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 11
  store i8 32, i8* %3185
  %3186 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 12
  store i8 114, i8* %3186
  %3187 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 13
  store i8 101, i8* %3187
  %3188 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 14
  store i8 97, i8* %3188
  %3189 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 15
  store i8 108, i8* %3189
  %3190 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 16
  store i8 32, i8* %3190
  %3191 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 17
  store i8 61, i8* %3191
  %3192 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 18
  store i8 32, i8* %3192
  %3193 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 19
  store i8 121, i8* %3193
  %3194 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 20
  store i8 111, i8* %3194
  %3195 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 21
  store i8 117, i8* %3195
  %3196 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 22
  store i8 114, i8* %3196
  %3197 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 23
  store i8 32, i8* %3197
  %3198 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 24
  store i8 111, i8* %3198
  %3199 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 25
  store i8 116, i8* %3199
  %3200 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 26
  store i8 104, i8* %3200
  %3201 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 27
  store i8 101, i8* %3201
  %3202 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 28
  store i8 114, i8* %3202
  %3203 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 29
  store i8 32, i8* %3203
  %3204 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 30
  store i8 114, i8* %3204
  %3205 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 31
  store i8 101, i8* %3205
  %3206 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 32
  store i8 97, i8* %3206
  %3207 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 33
  store i8 108, i8* %3207
  %3208 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 34
  store i8 58, i8* %3208
  %3209 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 35
  store i8 32, i8* %3209
  %3210 = getelementptr [37 x i8], [37 x i8]* %3173, i16 0, i16 36
  store i8 0, i8* %3210
  %3211 = getelementptr inbounds [37 x i8], [37 x i8]* %3173, i16 0, i16 0
  %3212 = alloca i8*
  store i8* %3211, i8** %3212
  call void @writeString(i8** %3212)
  %3213 = load double, double* %10
  %3214 = load double, double* %11
  %3215 = fcmp oeq double %3213, %3214
  call void @writeBoolean(i1 %3215)
  %3216 = alloca [2 x i8]
  %3217 = getelementptr [2 x i8], [2 x i8]* %3216, i16 0, i16 0
  store i8 10, i8* %3217
  %3218 = getelementptr [2 x i8], [2 x i8]* %3216, i16 0, i16 1
  store i8 0, i8* %3218
  %3219 = getelementptr inbounds [2 x i8], [2 x i8]* %3216, i16 0, i16 0
  %3220 = alloca i8*
  store i8* %3219, i8** %3220
  call void @writeString(i8** %3220)
  %3221 = alloca [38 x i8]
  %3222 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 0
  store i8 72, i8* %3222
  %3223 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 1
  store i8 101, i8* %3223
  %3224 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 2
  store i8 114, i8* %3224
  %3225 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 3
  store i8 101, i8* %3225
  %3226 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 4
  store i8 39, i8* %3226
  %3227 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 5
  store i8 115, i8* %3227
  %3228 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 6
  store i8 32, i8* %3228
  %3229 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 7
  store i8 121, i8* %3229
  %3230 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 8
  store i8 111, i8* %3230
  %3231 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 9
  store i8 117, i8* %3231
  %3232 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 10
  store i8 114, i8* %3232
  %3233 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 11
  store i8 32, i8* %3233
  %3234 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 12
  store i8 114, i8* %3234
  %3235 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 13
  store i8 101, i8* %3235
  %3236 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 14
  store i8 97, i8* %3236
  %3237 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 15
  store i8 108, i8* %3237
  %3238 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 16
  store i8 32, i8* %3238
  %3239 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 17
  store i8 60, i8* %3239
  %3240 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 18
  store i8 62, i8* %3240
  %3241 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 19
  store i8 32, i8* %3241
  %3242 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 20
  store i8 121, i8* %3242
  %3243 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 21
  store i8 111, i8* %3243
  %3244 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 22
  store i8 117, i8* %3244
  %3245 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 23
  store i8 114, i8* %3245
  %3246 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 24
  store i8 32, i8* %3246
  %3247 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 25
  store i8 111, i8* %3247
  %3248 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 26
  store i8 116, i8* %3248
  %3249 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 27
  store i8 104, i8* %3249
  %3250 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 28
  store i8 101, i8* %3250
  %3251 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 29
  store i8 114, i8* %3251
  %3252 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 30
  store i8 32, i8* %3252
  %3253 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 31
  store i8 114, i8* %3253
  %3254 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 32
  store i8 101, i8* %3254
  %3255 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 33
  store i8 97, i8* %3255
  %3256 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 34
  store i8 108, i8* %3256
  %3257 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 35
  store i8 58, i8* %3257
  %3258 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 36
  store i8 32, i8* %3258
  %3259 = getelementptr [38 x i8], [38 x i8]* %3221, i16 0, i16 37
  store i8 0, i8* %3259
  %3260 = getelementptr inbounds [38 x i8], [38 x i8]* %3221, i16 0, i16 0
  %3261 = alloca i8*
  store i8* %3260, i8** %3261
  call void @writeString(i8** %3261)
  %3262 = load double, double* %10
  %3263 = load double, double* %11
  %3264 = fcmp one double %3262, %3263
  call void @writeBoolean(i1 %3264)
  %3265 = alloca [2 x i8]
  %3266 = getelementptr [2 x i8], [2 x i8]* %3265, i16 0, i16 0
  store i8 10, i8* %3266
  %3267 = getelementptr [2 x i8], [2 x i8]* %3265, i16 0, i16 1
  store i8 0, i8* %3267
  %3268 = getelementptr inbounds [2 x i8], [2 x i8]* %3265, i16 0, i16 0
  %3269 = alloca i8*
  store i8* %3268, i8** %3269
  call void @writeString(i8** %3269)
  %3270 = alloca [20 x i8]
  %3271 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 0
  store i8 71, i8* %3271
  %3272 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 1
  store i8 105, i8* %3272
  %3273 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 2
  store i8 118, i8* %3273
  %3274 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 3
  store i8 101, i8* %3274
  %3275 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 4
  store i8 32, i8* %3275
  %3276 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 5
  store i8 109, i8* %3276
  %3277 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 6
  store i8 101, i8* %3277
  %3278 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 7
  store i8 32, i8* %3278
  %3279 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 8
  store i8 97, i8* %3279
  %3280 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 9
  store i8 32, i8* %3280
  %3281 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 10
  store i8 98, i8* %3281
  %3282 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 11
  store i8 111, i8* %3282
  %3283 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 12
  store i8 111, i8* %3283
  %3284 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 13
  store i8 108, i8* %3284
  %3285 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 14
  store i8 101, i8* %3285
  %3286 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 15
  store i8 97, i8* %3286
  %3287 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 16
  store i8 110, i8* %3287
  %3288 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 17
  store i8 58, i8* %3288
  %3289 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 18
  store i8 32, i8* %3289
  %3290 = getelementptr [20 x i8], [20 x i8]* %3270, i16 0, i16 19
  store i8 0, i8* %3290
  %3291 = getelementptr inbounds [20 x i8], [20 x i8]* %3270, i16 0, i16 0
  %3292 = alloca i8*
  store i8* %3291, i8** %3292
  call void @writeString(i8** %3292)
  %3293 = call i1 @readBoolean()
  store i1 %3293, i1* %4
  %3294 = alloca [26 x i8]
  %3295 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 0
  store i8 71, i8* %3295
  %3296 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 1
  store i8 105, i8* %3296
  %3297 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 2
  store i8 118, i8* %3297
  %3298 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 3
  store i8 101, i8* %3298
  %3299 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 4
  store i8 32, i8* %3299
  %3300 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 5
  store i8 109, i8* %3300
  %3301 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 6
  store i8 101, i8* %3301
  %3302 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 7
  store i8 32, i8* %3302
  %3303 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 8
  store i8 97, i8* %3303
  %3304 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 9
  store i8 110, i8* %3304
  %3305 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 10
  store i8 111, i8* %3305
  %3306 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 11
  store i8 116, i8* %3306
  %3307 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 12
  store i8 104, i8* %3307
  %3308 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 13
  store i8 101, i8* %3308
  %3309 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 14
  store i8 114, i8* %3309
  %3310 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 15
  store i8 32, i8* %3310
  %3311 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 16
  store i8 98, i8* %3311
  %3312 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 17
  store i8 111, i8* %3312
  %3313 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 18
  store i8 111, i8* %3313
  %3314 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 19
  store i8 108, i8* %3314
  %3315 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 20
  store i8 101, i8* %3315
  %3316 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 21
  store i8 97, i8* %3316
  %3317 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 22
  store i8 110, i8* %3317
  %3318 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 23
  store i8 58, i8* %3318
  %3319 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 24
  store i8 32, i8* %3319
  %3320 = getelementptr [26 x i8], [26 x i8]* %3294, i16 0, i16 25
  store i8 0, i8* %3320
  %3321 = getelementptr inbounds [26 x i8], [26 x i8]* %3294, i16 0, i16 0
  %3322 = alloca i8*
  store i8* %3321, i8** %3322
  call void @writeString(i8** %3322)
  %3323 = call i1 @readBoolean()
  store i1 %3323, i1* %5
  %3324 = alloca [45 x i8]
  %3325 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 0
  store i8 72, i8* %3325
  %3326 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 1
  store i8 101, i8* %3326
  %3327 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 2
  store i8 114, i8* %3327
  %3328 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 3
  store i8 101, i8* %3328
  %3329 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 4
  store i8 39, i8* %3329
  %3330 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 5
  store i8 115, i8* %3330
  %3331 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 6
  store i8 32, i8* %3331
  %3332 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 7
  store i8 121, i8* %3332
  %3333 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 8
  store i8 111, i8* %3333
  %3334 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 9
  store i8 117, i8* %3334
  %3335 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 10
  store i8 114, i8* %3335
  %3336 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 11
  store i8 32, i8* %3336
  %3337 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 12
  store i8 98, i8* %3337
  %3338 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 13
  store i8 111, i8* %3338
  %3339 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 14
  store i8 111, i8* %3339
  %3340 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 15
  store i8 108, i8* %3340
  %3341 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 16
  store i8 101, i8* %3341
  %3342 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 17
  store i8 97, i8* %3342
  %3343 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 18
  store i8 110, i8* %3343
  %3344 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 19
  store i8 32, i8* %3344
  %3345 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 20
  store i8 97, i8* %3345
  %3346 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 21
  store i8 110, i8* %3346
  %3347 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 22
  store i8 100, i8* %3347
  %3348 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 23
  store i8 32, i8* %3348
  %3349 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 24
  store i8 121, i8* %3349
  %3350 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 25
  store i8 111, i8* %3350
  %3351 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 26
  store i8 117, i8* %3351
  %3352 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 27
  store i8 114, i8* %3352
  %3353 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 28
  store i8 32, i8* %3353
  %3354 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 29
  store i8 111, i8* %3354
  %3355 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 30
  store i8 116, i8* %3355
  %3356 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 31
  store i8 104, i8* %3356
  %3357 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 32
  store i8 101, i8* %3357
  %3358 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 33
  store i8 114, i8* %3358
  %3359 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 34
  store i8 32, i8* %3359
  %3360 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 35
  store i8 98, i8* %3360
  %3361 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 36
  store i8 111, i8* %3361
  %3362 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 37
  store i8 111, i8* %3362
  %3363 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 38
  store i8 108, i8* %3363
  %3364 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 39
  store i8 101, i8* %3364
  %3365 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 40
  store i8 97, i8* %3365
  %3366 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 41
  store i8 110, i8* %3366
  %3367 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 42
  store i8 58, i8* %3367
  %3368 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 43
  store i8 32, i8* %3368
  %3369 = getelementptr [45 x i8], [45 x i8]* %3324, i16 0, i16 44
  store i8 0, i8* %3369
  %3370 = getelementptr inbounds [45 x i8], [45 x i8]* %3324, i16 0, i16 0
  %3371 = alloca i8*
  store i8* %3370, i8** %3371
  call void @writeString(i8** %3371)
  %3372 = load i1, i1* %4
  %3373 = load i1, i1* %5
  %3374 = and i1 %3372, %3373
  call void @writeBoolean(i1 %3374)
  %3375 = alloca [2 x i8]
  %3376 = getelementptr [2 x i8], [2 x i8]* %3375, i16 0, i16 0
  store i8 10, i8* %3376
  %3377 = getelementptr [2 x i8], [2 x i8]* %3375, i16 0, i16 1
  store i8 0, i8* %3377
  %3378 = getelementptr inbounds [2 x i8], [2 x i8]* %3375, i16 0, i16 0
  %3379 = alloca i8*
  store i8* %3378, i8** %3379
  call void @writeString(i8** %3379)
  %3380 = alloca [44 x i8]
  %3381 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 0
  store i8 72, i8* %3381
  %3382 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 1
  store i8 101, i8* %3382
  %3383 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 2
  store i8 114, i8* %3383
  %3384 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 3
  store i8 101, i8* %3384
  %3385 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 4
  store i8 39, i8* %3385
  %3386 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 5
  store i8 115, i8* %3386
  %3387 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 6
  store i8 32, i8* %3387
  %3388 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 7
  store i8 121, i8* %3388
  %3389 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 8
  store i8 111, i8* %3389
  %3390 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 9
  store i8 117, i8* %3390
  %3391 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 10
  store i8 114, i8* %3391
  %3392 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 11
  store i8 32, i8* %3392
  %3393 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 12
  store i8 98, i8* %3393
  %3394 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 13
  store i8 111, i8* %3394
  %3395 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 14
  store i8 111, i8* %3395
  %3396 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 15
  store i8 108, i8* %3396
  %3397 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 16
  store i8 101, i8* %3397
  %3398 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 17
  store i8 97, i8* %3398
  %3399 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 18
  store i8 110, i8* %3399
  %3400 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 19
  store i8 32, i8* %3400
  %3401 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 20
  store i8 111, i8* %3401
  %3402 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 21
  store i8 114, i8* %3402
  %3403 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 22
  store i8 32, i8* %3403
  %3404 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 23
  store i8 121, i8* %3404
  %3405 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 24
  store i8 111, i8* %3405
  %3406 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 25
  store i8 117, i8* %3406
  %3407 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 26
  store i8 114, i8* %3407
  %3408 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 27
  store i8 32, i8* %3408
  %3409 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 28
  store i8 111, i8* %3409
  %3410 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 29
  store i8 116, i8* %3410
  %3411 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 30
  store i8 104, i8* %3411
  %3412 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 31
  store i8 101, i8* %3412
  %3413 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 32
  store i8 114, i8* %3413
  %3414 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 33
  store i8 32, i8* %3414
  %3415 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 34
  store i8 98, i8* %3415
  %3416 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 35
  store i8 111, i8* %3416
  %3417 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 36
  store i8 111, i8* %3417
  %3418 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 37
  store i8 108, i8* %3418
  %3419 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 38
  store i8 101, i8* %3419
  %3420 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 39
  store i8 97, i8* %3420
  %3421 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 40
  store i8 110, i8* %3421
  %3422 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 41
  store i8 58, i8* %3422
  %3423 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 42
  store i8 32, i8* %3423
  %3424 = getelementptr [44 x i8], [44 x i8]* %3380, i16 0, i16 43
  store i8 0, i8* %3424
  %3425 = getelementptr inbounds [44 x i8], [44 x i8]* %3380, i16 0, i16 0
  %3426 = alloca i8*
  store i8* %3425, i8** %3426
  call void @writeString(i8** %3426)
  %3427 = load i1, i1* %4
  %3428 = load i1, i1* %5
  %3429 = or i1 %3427, %3428
  call void @writeBoolean(i1 %3429)
  %3430 = alloca [2 x i8]
  %3431 = getelementptr [2 x i8], [2 x i8]* %3430, i16 0, i16 0
  store i8 10, i8* %3431
  %3432 = getelementptr [2 x i8], [2 x i8]* %3430, i16 0, i16 1
  store i8 0, i8* %3432
  %3433 = getelementptr inbounds [2 x i8], [2 x i8]* %3430, i16 0, i16 0
  %3434 = alloca i8*
  store i8* %3433, i8** %3434
  call void @writeString(i8** %3434)
  %3435 = alloca [43 x i8]
  %3436 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 0
  store i8 72, i8* %3436
  %3437 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 1
  store i8 101, i8* %3437
  %3438 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 2
  store i8 114, i8* %3438
  %3439 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 3
  store i8 101, i8* %3439
  %3440 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 4
  store i8 39, i8* %3440
  %3441 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 5
  store i8 115, i8* %3441
  %3442 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 6
  store i8 32, i8* %3442
  %3443 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 7
  store i8 121, i8* %3443
  %3444 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 8
  store i8 111, i8* %3444
  %3445 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 9
  store i8 117, i8* %3445
  %3446 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 10
  store i8 114, i8* %3446
  %3447 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 11
  store i8 32, i8* %3447
  %3448 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 12
  store i8 98, i8* %3448
  %3449 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 13
  store i8 111, i8* %3449
  %3450 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 14
  store i8 111, i8* %3450
  %3451 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 15
  store i8 108, i8* %3451
  %3452 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 16
  store i8 101, i8* %3452
  %3453 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 17
  store i8 97, i8* %3453
  %3454 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 18
  store i8 110, i8* %3454
  %3455 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 19
  store i8 32, i8* %3455
  %3456 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 20
  store i8 61, i8* %3456
  %3457 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 21
  store i8 32, i8* %3457
  %3458 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 22
  store i8 121, i8* %3458
  %3459 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 23
  store i8 111, i8* %3459
  %3460 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 24
  store i8 117, i8* %3460
  %3461 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 25
  store i8 114, i8* %3461
  %3462 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 26
  store i8 32, i8* %3462
  %3463 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 27
  store i8 111, i8* %3463
  %3464 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 28
  store i8 116, i8* %3464
  %3465 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 29
  store i8 104, i8* %3465
  %3466 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 30
  store i8 101, i8* %3466
  %3467 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 31
  store i8 114, i8* %3467
  %3468 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 32
  store i8 32, i8* %3468
  %3469 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 33
  store i8 98, i8* %3469
  %3470 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 34
  store i8 111, i8* %3470
  %3471 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 35
  store i8 111, i8* %3471
  %3472 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 36
  store i8 108, i8* %3472
  %3473 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 37
  store i8 101, i8* %3473
  %3474 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 38
  store i8 97, i8* %3474
  %3475 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 39
  store i8 110, i8* %3475
  %3476 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 40
  store i8 58, i8* %3476
  %3477 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 41
  store i8 32, i8* %3477
  %3478 = getelementptr [43 x i8], [43 x i8]* %3435, i16 0, i16 42
  store i8 0, i8* %3478
  %3479 = getelementptr inbounds [43 x i8], [43 x i8]* %3435, i16 0, i16 0
  %3480 = alloca i8*
  store i8* %3479, i8** %3480
  call void @writeString(i8** %3480)
  %3481 = load i1, i1* %4
  %3482 = load i1, i1* %5
  %3483 = icmp eq i1 %3481, %3482
  call void @writeBoolean(i1 %3483)
  %3484 = alloca [2 x i8]
  %3485 = getelementptr [2 x i8], [2 x i8]* %3484, i16 0, i16 0
  store i8 10, i8* %3485
  %3486 = getelementptr [2 x i8], [2 x i8]* %3484, i16 0, i16 1
  store i8 0, i8* %3486
  %3487 = getelementptr inbounds [2 x i8], [2 x i8]* %3484, i16 0, i16 0
  %3488 = alloca i8*
  store i8* %3487, i8** %3488
  call void @writeString(i8** %3488)
  %3489 = alloca [44 x i8]
  %3490 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 0
  store i8 72, i8* %3490
  %3491 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 1
  store i8 101, i8* %3491
  %3492 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 2
  store i8 114, i8* %3492
  %3493 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 3
  store i8 101, i8* %3493
  %3494 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 4
  store i8 39, i8* %3494
  %3495 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 5
  store i8 115, i8* %3495
  %3496 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 6
  store i8 32, i8* %3496
  %3497 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 7
  store i8 121, i8* %3497
  %3498 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 8
  store i8 111, i8* %3498
  %3499 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 9
  store i8 117, i8* %3499
  %3500 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 10
  store i8 114, i8* %3500
  %3501 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 11
  store i8 32, i8* %3501
  %3502 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 12
  store i8 98, i8* %3502
  %3503 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 13
  store i8 111, i8* %3503
  %3504 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 14
  store i8 111, i8* %3504
  %3505 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 15
  store i8 108, i8* %3505
  %3506 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 16
  store i8 101, i8* %3506
  %3507 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 17
  store i8 97, i8* %3507
  %3508 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 18
  store i8 110, i8* %3508
  %3509 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 19
  store i8 32, i8* %3509
  %3510 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 20
  store i8 60, i8* %3510
  %3511 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 21
  store i8 62, i8* %3511
  %3512 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 22
  store i8 32, i8* %3512
  %3513 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 23
  store i8 121, i8* %3513
  %3514 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 24
  store i8 111, i8* %3514
  %3515 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 25
  store i8 117, i8* %3515
  %3516 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 26
  store i8 114, i8* %3516
  %3517 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 27
  store i8 32, i8* %3517
  %3518 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 28
  store i8 111, i8* %3518
  %3519 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 29
  store i8 116, i8* %3519
  %3520 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 30
  store i8 104, i8* %3520
  %3521 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 31
  store i8 101, i8* %3521
  %3522 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 32
  store i8 114, i8* %3522
  %3523 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 33
  store i8 32, i8* %3523
  %3524 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 34
  store i8 98, i8* %3524
  %3525 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 35
  store i8 111, i8* %3525
  %3526 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 36
  store i8 111, i8* %3526
  %3527 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 37
  store i8 108, i8* %3527
  %3528 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 38
  store i8 101, i8* %3528
  %3529 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 39
  store i8 97, i8* %3529
  %3530 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 40
  store i8 110, i8* %3530
  %3531 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 41
  store i8 58, i8* %3531
  %3532 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 42
  store i8 32, i8* %3532
  %3533 = getelementptr [44 x i8], [44 x i8]* %3489, i16 0, i16 43
  store i8 0, i8* %3533
  %3534 = getelementptr inbounds [44 x i8], [44 x i8]* %3489, i16 0, i16 0
  %3535 = alloca i8*
  store i8* %3534, i8** %3535
  call void @writeString(i8** %3535)
  %3536 = load i1, i1* %4
  %3537 = load i1, i1* %5
  %3538 = icmp ne i1 %3536, %3537
  call void @writeBoolean(i1 %3538)
  %3539 = alloca [2 x i8]
  %3540 = getelementptr [2 x i8], [2 x i8]* %3539, i16 0, i16 0
  store i8 10, i8* %3540
  %3541 = getelementptr [2 x i8], [2 x i8]* %3539, i16 0, i16 1
  store i8 0, i8* %3541
  %3542 = getelementptr inbounds [2 x i8], [2 x i8]* %3539, i16 0, i16 0
  %3543 = alloca i8*
  store i8* %3542, i8** %3543
  call void @writeString(i8** %3543)
  %3544 = alloca [17 x i8]
  %3545 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 0
  store i8 71, i8* %3545
  %3546 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 1
  store i8 105, i8* %3546
  %3547 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 2
  store i8 118, i8* %3547
  %3548 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 3
  store i8 101, i8* %3548
  %3549 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 4
  store i8 32, i8* %3549
  %3550 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 5
  store i8 109, i8* %3550
  %3551 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 6
  store i8 101, i8* %3551
  %3552 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 7
  store i8 32, i8* %3552
  %3553 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 8
  store i8 97, i8* %3553
  %3554 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 9
  store i8 32, i8* %3554
  %3555 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 10
  store i8 99, i8* %3555
  %3556 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 11
  store i8 104, i8* %3556
  %3557 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 12
  store i8 97, i8* %3557
  %3558 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 13
  store i8 114, i8* %3558
  %3559 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 14
  store i8 58, i8* %3559
  %3560 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 15
  store i8 32, i8* %3560
  %3561 = getelementptr [17 x i8], [17 x i8]* %3544, i16 0, i16 16
  store i8 0, i8* %3561
  %3562 = getelementptr inbounds [17 x i8], [17 x i8]* %3544, i16 0, i16 0
  %3563 = alloca i8*
  store i8* %3562, i8** %3563
  call void @writeString(i8** %3563)
  %3564 = call i8 @readChar()
  store i8 %3564, i8* %7
  %3565 = alloca [23 x i8]
  %3566 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 0
  store i8 71, i8* %3566
  %3567 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 1
  store i8 105, i8* %3567
  %3568 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 2
  store i8 118, i8* %3568
  %3569 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 3
  store i8 101, i8* %3569
  %3570 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 4
  store i8 32, i8* %3570
  %3571 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 5
  store i8 109, i8* %3571
  %3572 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 6
  store i8 101, i8* %3572
  %3573 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 7
  store i8 32, i8* %3573
  %3574 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 8
  store i8 97, i8* %3574
  %3575 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 9
  store i8 110, i8* %3575
  %3576 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 10
  store i8 111, i8* %3576
  %3577 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 11
  store i8 116, i8* %3577
  %3578 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 12
  store i8 104, i8* %3578
  %3579 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 13
  store i8 101, i8* %3579
  %3580 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 14
  store i8 114, i8* %3580
  %3581 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 15
  store i8 32, i8* %3581
  %3582 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 16
  store i8 99, i8* %3582
  %3583 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 17
  store i8 104, i8* %3583
  %3584 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 18
  store i8 97, i8* %3584
  %3585 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 19
  store i8 114, i8* %3585
  %3586 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 20
  store i8 58, i8* %3586
  %3587 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 21
  store i8 32, i8* %3587
  %3588 = getelementptr [23 x i8], [23 x i8]* %3565, i16 0, i16 22
  store i8 0, i8* %3588
  %3589 = getelementptr inbounds [23 x i8], [23 x i8]* %3565, i16 0, i16 0
  %3590 = alloca i8*
  store i8* %3589, i8** %3590
  call void @writeString(i8** %3590)
  %3591 = call i8 @readChar()
  store i8 %3591, i8* %8
  %3592 = alloca [37 x i8]
  %3593 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 0
  store i8 72, i8* %3593
  %3594 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 1
  store i8 101, i8* %3594
  %3595 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 2
  store i8 114, i8* %3595
  %3596 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 3
  store i8 101, i8* %3596
  %3597 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 4
  store i8 39, i8* %3597
  %3598 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 5
  store i8 115, i8* %3598
  %3599 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 6
  store i8 32, i8* %3599
  %3600 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 7
  store i8 121, i8* %3600
  %3601 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 8
  store i8 111, i8* %3601
  %3602 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 9
  store i8 117, i8* %3602
  %3603 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 10
  store i8 114, i8* %3603
  %3604 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 11
  store i8 32, i8* %3604
  %3605 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 12
  store i8 99, i8* %3605
  %3606 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 13
  store i8 104, i8* %3606
  %3607 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 14
  store i8 97, i8* %3607
  %3608 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 15
  store i8 114, i8* %3608
  %3609 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 16
  store i8 32, i8* %3609
  %3610 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 17
  store i8 61, i8* %3610
  %3611 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 18
  store i8 32, i8* %3611
  %3612 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 19
  store i8 121, i8* %3612
  %3613 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 20
  store i8 111, i8* %3613
  %3614 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 21
  store i8 117, i8* %3614
  %3615 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 22
  store i8 114, i8* %3615
  %3616 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 23
  store i8 32, i8* %3616
  %3617 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 24
  store i8 111, i8* %3617
  %3618 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 25
  store i8 116, i8* %3618
  %3619 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 26
  store i8 104, i8* %3619
  %3620 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 27
  store i8 101, i8* %3620
  %3621 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 28
  store i8 114, i8* %3621
  %3622 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 29
  store i8 32, i8* %3622
  %3623 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 30
  store i8 99, i8* %3623
  %3624 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 31
  store i8 104, i8* %3624
  %3625 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 32
  store i8 97, i8* %3625
  %3626 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 33
  store i8 114, i8* %3626
  %3627 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 34
  store i8 58, i8* %3627
  %3628 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 35
  store i8 32, i8* %3628
  %3629 = getelementptr [37 x i8], [37 x i8]* %3592, i16 0, i16 36
  store i8 0, i8* %3629
  %3630 = getelementptr inbounds [37 x i8], [37 x i8]* %3592, i16 0, i16 0
  %3631 = alloca i8*
  store i8* %3630, i8** %3631
  call void @writeString(i8** %3631)
  %3632 = load i8, i8* %7
  %3633 = load i8, i8* %8
  %3634 = icmp eq i8 %3632, %3633
  call void @writeBoolean(i1 %3634)
  %3635 = alloca [2 x i8]
  %3636 = getelementptr [2 x i8], [2 x i8]* %3635, i16 0, i16 0
  store i8 10, i8* %3636
  %3637 = getelementptr [2 x i8], [2 x i8]* %3635, i16 0, i16 1
  store i8 0, i8* %3637
  %3638 = getelementptr inbounds [2 x i8], [2 x i8]* %3635, i16 0, i16 0
  %3639 = alloca i8*
  store i8* %3638, i8** %3639
  call void @writeString(i8** %3639)
  %3640 = alloca [38 x i8]
  %3641 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 0
  store i8 72, i8* %3641
  %3642 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 1
  store i8 101, i8* %3642
  %3643 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 2
  store i8 114, i8* %3643
  %3644 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 3
  store i8 101, i8* %3644
  %3645 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 4
  store i8 39, i8* %3645
  %3646 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 5
  store i8 115, i8* %3646
  %3647 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 6
  store i8 32, i8* %3647
  %3648 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 7
  store i8 121, i8* %3648
  %3649 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 8
  store i8 111, i8* %3649
  %3650 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 9
  store i8 117, i8* %3650
  %3651 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 10
  store i8 114, i8* %3651
  %3652 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 11
  store i8 32, i8* %3652
  %3653 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 12
  store i8 99, i8* %3653
  %3654 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 13
  store i8 104, i8* %3654
  %3655 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 14
  store i8 97, i8* %3655
  %3656 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 15
  store i8 114, i8* %3656
  %3657 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 16
  store i8 32, i8* %3657
  %3658 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 17
  store i8 60, i8* %3658
  %3659 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 18
  store i8 62, i8* %3659
  %3660 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 19
  store i8 32, i8* %3660
  %3661 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 20
  store i8 121, i8* %3661
  %3662 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 21
  store i8 111, i8* %3662
  %3663 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 22
  store i8 117, i8* %3663
  %3664 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 23
  store i8 114, i8* %3664
  %3665 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 24
  store i8 32, i8* %3665
  %3666 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 25
  store i8 111, i8* %3666
  %3667 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 26
  store i8 116, i8* %3667
  %3668 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 27
  store i8 104, i8* %3668
  %3669 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 28
  store i8 101, i8* %3669
  %3670 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 29
  store i8 114, i8* %3670
  %3671 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 30
  store i8 32, i8* %3671
  %3672 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 31
  store i8 99, i8* %3672
  %3673 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 32
  store i8 104, i8* %3673
  %3674 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 33
  store i8 97, i8* %3674
  %3675 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 34
  store i8 114, i8* %3675
  %3676 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 35
  store i8 58, i8* %3676
  %3677 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 36
  store i8 32, i8* %3677
  %3678 = getelementptr [38 x i8], [38 x i8]* %3640, i16 0, i16 37
  store i8 0, i8* %3678
  %3679 = getelementptr inbounds [38 x i8], [38 x i8]* %3640, i16 0, i16 0
  %3680 = alloca i8*
  store i8* %3679, i8** %3680
  call void @writeString(i8** %3680)
  %3681 = load i8, i8* %7
  %3682 = load i8, i8* %8
  %3683 = icmp ne i8 %3681, %3682
  call void @writeBoolean(i1 %3683)
  %3684 = alloca [2 x i8]
  %3685 = getelementptr [2 x i8], [2 x i8]* %3684, i16 0, i16 0
  store i8 10, i8* %3685
  %3686 = getelementptr [2 x i8], [2 x i8]* %3684, i16 0, i16 1
  store i8 0, i8* %3686
  %3687 = getelementptr inbounds [2 x i8], [2 x i8]* %3684, i16 0, i16 0
  %3688 = alloca i8*
  store i8* %3687, i8** %3688
  call void @writeString(i8** %3688)
  ret void
}
