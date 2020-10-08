; ModuleID = 'RValues'
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

define void @writeString(i8*, ...) {
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
  %4 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %5 = alloca i8
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* %4, i8* %5)
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
  %4 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %5 = alloca i8
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* %4, i8* %5)
  ret i8 %3
}

define double @readReal() {
entry:
  %0 = getelementptr inbounds [4 x i8], [4 x i8]* @.scanReal, i16 0, i16 0
  %1 = alloca double
  %2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, double* %1)
  %3 = load double, double* %1
  %4 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfChar, i16 0, i16 0
  %5 = alloca i8
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* %4, i8* %5)
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

declare double @atan(double)

declare double @exp(double)

declare double @log(double)

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
  %1 = alloca i1
  %2 = alloca i8
  %3 = alloca double
  %4 = alloca i16*
  store i16 1, i16* %0
  %5 = load i16, i16* %0
  call void @writeInteger(i16 %5)
  store i1 true, i1* %1
  %6 = load i1, i1* %1
  call void @writeBoolean(i1 %6)
  store i1 false, i1* %1
  %7 = load i1, i1* %1
  call void @writeBoolean(i1 %7)
  store double 1.000000e+00, double* %3
  %8 = load double, double* %3
  call void @writeReal(double %8)
  store i8 97, i8* %2
  %9 = load i8, i8* %2
  call void @writeChar(i8 %9)
  %10 = alloca i8, i16 20
  %11 = getelementptr i8, i8* %10, i16 0
  store i8 71, i8* %11
  %12 = getelementptr i8, i8* %10, i16 1
  store i8 105, i8* %12
  %13 = getelementptr i8, i8* %10, i16 2
  store i8 118, i8* %13
  %14 = getelementptr i8, i8* %10, i16 3
  store i8 101, i8* %14
  %15 = getelementptr i8, i8* %10, i16 4
  store i8 32, i8* %15
  %16 = getelementptr i8, i8* %10, i16 5
  store i8 109, i8* %16
  %17 = getelementptr i8, i8* %10, i16 6
  store i8 101, i8* %17
  %18 = getelementptr i8, i8* %10, i16 7
  store i8 32, i8* %18
  %19 = getelementptr i8, i8* %10, i16 8
  store i8 97, i8* %19
  %20 = getelementptr i8, i8* %10, i16 9
  store i8 110, i8* %20
  %21 = getelementptr i8, i8* %10, i16 10
  store i8 32, i8* %21
  %22 = getelementptr i8, i8* %10, i16 11
  store i8 105, i8* %22
  %23 = getelementptr i8, i8* %10, i16 12
  store i8 110, i8* %23
  %24 = getelementptr i8, i8* %10, i16 13
  store i8 116, i8* %24
  %25 = getelementptr i8, i8* %10, i16 14
  store i8 101, i8* %25
  %26 = getelementptr i8, i8* %10, i16 15
  store i8 103, i8* %26
  %27 = getelementptr i8, i8* %10, i16 16
  store i8 101, i8* %27
  %28 = getelementptr i8, i8* %10, i16 17
  store i8 114, i8* %28
  %29 = getelementptr i8, i8* %10, i16 18
  store i8 10, i8* %29
  %30 = getelementptr i8, i8* %10, i16 19
  store i8 0, i8* %30
  call void (i8*, ...) @writeString(i8* %10)
  %31 = call i16 @readInteger()
  store i16 %31, i16* %0
  %32 = load i16, i16* %0
  call void @writeInteger(i16 %32)
  store i16* %0, i16** %4
  %33 = icmp eq i1 true, false
  store i1 %33, i1* %1
  %34 = load i1, i1* %1
  call void @writeBoolean(i1 %34)
  %35 = icmp eq i1 false, false
  store i1 %35, i1* %1
  %36 = load i1, i1* %1
  call void @writeBoolean(i1 %36)
  %37 = sub i16 0, 1
  store i16 1, i16* %0
  %38 = load i16, i16* %0
  call void @writeInteger(i16 %38)
  %39 = sub i16 0, 1
  store i16 %39, i16* %0
  %40 = load i16, i16* %0
  call void @writeInteger(i16 %40)
  %41 = fsub double 0.000000e+00, 1.000000e+00
  store double 1.000000e+00, double* %3
  %42 = load double, double* %3
  call void @writeReal(double %42)
  %43 = fsub double 0.000000e+00, 1.000000e+00
  store double %43, double* %3
  %44 = load double, double* %3
  call void @writeReal(double %44)
  %45 = add i16 1, 1
  store i16 %45, i16* %0
  %46 = load i16, i16* %0
  call void @writeInteger(i16 %46)
  %47 = sitofp i16 1 to double
  %48 = fadd double %47, 1.000000e+00
  store double %48, double* %3
  %49 = load double, double* %3
  call void @writeReal(double %49)
  %50 = sitofp i16 1 to double
  %51 = fadd double 1.000000e+00, %50
  store double %51, double* %3
  %52 = load double, double* %3
  call void @writeReal(double %52)
  %53 = fadd double 1.000000e+00, 1.000000e+00
  store double %53, double* %3
  %54 = load double, double* %3
  call void @writeReal(double %54)
  %55 = mul i16 1, 1
  store i16 %55, i16* %0
  %56 = load i16, i16* %0
  call void @writeInteger(i16 %56)
  %57 = sitofp i16 1 to double
  %58 = fmul double %57, 1.000000e+00
  store double %58, double* %3
  %59 = load double, double* %3
  call void @writeReal(double %59)
  %60 = sitofp i16 1 to double
  %61 = fmul double 1.000000e+00, %60
  store double %61, double* %3
  %62 = load double, double* %3
  call void @writeReal(double %62)
  %63 = fmul double 1.000000e+00, 1.000000e+00
  store double %63, double* %3
  %64 = load double, double* %3
  call void @writeReal(double %64)
  %65 = sub i16 1, 1
  store i16 %65, i16* %0
  %66 = load i16, i16* %0
  call void @writeInteger(i16 %66)
  %67 = sitofp i16 1 to double
  %68 = fsub double %67, 1.000000e+00
  store double %68, double* %3
  %69 = load double, double* %3
  call void @writeReal(double %69)
  %70 = sitofp i16 1 to double
  %71 = fsub double 1.000000e+00, %70
  store double %71, double* %3
  %72 = load double, double* %3
  call void @writeReal(double %72)
  %73 = fsub double 1.000000e+00, 1.000000e+00
  store double %73, double* %3
  %74 = load double, double* %3
  call void @writeReal(double %74)
  %75 = sitofp i16 1 to double
  %76 = sitofp i16 1 to double
  %77 = fdiv double %75, %76
  store double %77, double* %3
  %78 = load double, double* %3
  call void @writeReal(double %78)
  %79 = sitofp i16 1 to double
  %80 = fdiv double %79, 1.000000e+00
  store double %80, double* %3
  %81 = load double, double* %3
  call void @writeReal(double %81)
  %82 = sitofp i16 1 to double
  %83 = fdiv double 1.000000e+00, %82
  store double %83, double* %3
  %84 = load double, double* %3
  call void @writeReal(double %84)
  %85 = fdiv double 1.000000e+00, 1.000000e+00
  store double %85, double* %3
  %86 = load double, double* %3
  call void @writeReal(double %86)
  %87 = sdiv i16 3, 2
  store i16 %87, i16* %0
  %88 = load i16, i16* %0
  call void @writeInteger(i16 %88)
  %89 = srem i16 3, 2
  store i16 %89, i16* %0
  %90 = load i16, i16* %0
  call void @writeInteger(i16 %90)
  %91 = or i1 true, false
  store i1 %91, i1* %1
  %92 = load i1, i1* %1
  call void @writeBoolean(i1 %92)
  %93 = and i1 true, false
  store i1 %93, i1* %1
  %94 = load i1, i1* %1
  call void @writeBoolean(i1 %94)
  %95 = icmp eq i16 1, 1
  store i1 %95, i1* %1
  %96 = load i1, i1* %1
  call void @writeBoolean(i1 %96)
  %97 = sitofp i16 1 to double
  %98 = fcmp oeq double 1.000000e+00, %97
  store i1 %98, i1* %1
  %99 = load i1, i1* %1
  call void @writeBoolean(i1 %99)
  %100 = sitofp i16 1 to double
  %101 = fcmp oeq double %100, 1.000000e+00
  store i1 %101, i1* %1
  %102 = load i1, i1* %1
  call void @writeBoolean(i1 %102)
  store i1 true, i1* %1
  %103 = load i1, i1* %1
  call void @writeBoolean(i1 %103)
  %104 = icmp eq i8 97, 97
  store i1 %104, i1* %1
  %105 = load i1, i1* %1
  call void @writeBoolean(i1 %105)
  %106 = icmp eq i1 true, true
  store i1 %106, i1* %1
  %107 = load i1, i1* %1
  call void @writeBoolean(i1 %107)
  %108 = icmp ne i16 1, 1
  store i1 %108, i1* %1
  %109 = load i1, i1* %1
  call void @writeBoolean(i1 %109)
  %110 = sitofp i16 1 to double
  %111 = fcmp one double 1.000000e+00, %110
  store i1 %111, i1* %1
  %112 = load i1, i1* %1
  call void @writeBoolean(i1 %112)
  %113 = sitofp i16 1 to double
  %114 = fcmp one double %113, 1.000000e+00
  store i1 %114, i1* %1
  %115 = load i1, i1* %1
  call void @writeBoolean(i1 %115)
  store i1 false, i1* %1
  %116 = load i1, i1* %1
  call void @writeBoolean(i1 %116)
  %117 = icmp ne i8 97, 97
  store i1 %117, i1* %1
  %118 = load i1, i1* %1
  call void @writeBoolean(i1 %118)
  %119 = icmp ne i1 true, true
  store i1 %119, i1* %1
  %120 = load i1, i1* %1
  call void @writeBoolean(i1 %120)
  %121 = icmp slt i16 1, 1
  store i1 %121, i1* %1
  %122 = load i1, i1* %1
  call void @writeBoolean(i1 %122)
  %123 = sitofp i16 1 to double
  %124 = fcmp olt double 1.000000e+00, %123
  store i1 %124, i1* %1
  %125 = load i1, i1* %1
  call void @writeBoolean(i1 %125)
  %126 = sitofp i16 1 to double
  %127 = fcmp olt double %126, 1.000000e+00
  store i1 %127, i1* %1
  %128 = load i1, i1* %1
  call void @writeBoolean(i1 %128)
  store i1 false, i1* %1
  %129 = load i1, i1* %1
  call void @writeBoolean(i1 %129)
  %130 = icmp sgt i16 1, 1
  store i1 %130, i1* %1
  %131 = load i1, i1* %1
  call void @writeBoolean(i1 %131)
  %132 = sitofp i16 1 to double
  %133 = fcmp ogt double 1.000000e+00, %132
  store i1 %133, i1* %1
  %134 = load i1, i1* %1
  call void @writeBoolean(i1 %134)
  %135 = sitofp i16 1 to double
  %136 = fcmp ogt double %135, 1.000000e+00
  store i1 %136, i1* %1
  %137 = load i1, i1* %1
  call void @writeBoolean(i1 %137)
  store i1 false, i1* %1
  %138 = load i1, i1* %1
  call void @writeBoolean(i1 %138)
  %139 = icmp sle i16 1, 1
  store i1 %139, i1* %1
  %140 = load i1, i1* %1
  call void @writeBoolean(i1 %140)
  %141 = sitofp i16 1 to double
  %142 = fcmp ole double 1.000000e+00, %141
  store i1 %142, i1* %1
  %143 = load i1, i1* %1
  call void @writeBoolean(i1 %143)
  %144 = sitofp i16 1 to double
  %145 = fcmp ole double %144, 1.000000e+00
  store i1 %145, i1* %1
  %146 = load i1, i1* %1
  call void @writeBoolean(i1 %146)
  store i1 true, i1* %1
  %147 = load i1, i1* %1
  call void @writeBoolean(i1 %147)
  %148 = icmp sge i16 1, 1
  store i1 %148, i1* %1
  %149 = load i1, i1* %1
  call void @writeBoolean(i1 %149)
  %150 = sitofp i16 1 to double
  %151 = fcmp oge double 1.000000e+00, %150
  store i1 %151, i1* %1
  %152 = load i1, i1* %1
  call void @writeBoolean(i1 %152)
  %153 = sitofp i16 1 to double
  %154 = fcmp oge double %153, 1.000000e+00
  store i1 %154, i1* %1
  %155 = load i1, i1* %1
  call void @writeBoolean(i1 %155)
  store i1 true, i1* %1
  %156 = load i1, i1* %1
  call void @writeBoolean(i1 %156)
  ret void
}
