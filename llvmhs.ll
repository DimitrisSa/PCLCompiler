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
  %6 = load i16, i16* %0
  call void @writeInteger(i16 %6)
  store i1 true, i1* %1
  %7 = load i1, i1* %1
  %8 = load i1, i1* %1
  call void @writeBoolean(i1 %8)
  store i1 false, i1* %1
  %9 = load i1, i1* %1
  %10 = load i1, i1* %1
  call void @writeBoolean(i1 %10)
  store double 1.000000e+00, double* %3
  %11 = load double, double* %3
  %12 = load double, double* %3
  call void @writeReal(double %12)
  store i8 97, i8* %2
  %13 = load i8, i8* %2
  %14 = load i8, i8* %2
  call void @writeChar(i8 %14)
  %15 = alloca i8, i16 20
  %16 = getelementptr i8, i8* %15, i16 0
  store i8 71, i8* %16
  %17 = getelementptr i8, i8* %15, i16 1
  store i8 105, i8* %17
  %18 = getelementptr i8, i8* %15, i16 2
  store i8 118, i8* %18
  %19 = getelementptr i8, i8* %15, i16 3
  store i8 101, i8* %19
  %20 = getelementptr i8, i8* %15, i16 4
  store i8 32, i8* %20
  %21 = getelementptr i8, i8* %15, i16 5
  store i8 109, i8* %21
  %22 = getelementptr i8, i8* %15, i16 6
  store i8 101, i8* %22
  %23 = getelementptr i8, i8* %15, i16 7
  store i8 32, i8* %23
  %24 = getelementptr i8, i8* %15, i16 8
  store i8 97, i8* %24
  %25 = getelementptr i8, i8* %15, i16 9
  store i8 110, i8* %25
  %26 = getelementptr i8, i8* %15, i16 10
  store i8 32, i8* %26
  %27 = getelementptr i8, i8* %15, i16 11
  store i8 105, i8* %27
  %28 = getelementptr i8, i8* %15, i16 12
  store i8 110, i8* %28
  %29 = getelementptr i8, i8* %15, i16 13
  store i8 116, i8* %29
  %30 = getelementptr i8, i8* %15, i16 14
  store i8 101, i8* %30
  %31 = getelementptr i8, i8* %15, i16 15
  store i8 103, i8* %31
  %32 = getelementptr i8, i8* %15, i16 16
  store i8 101, i8* %32
  %33 = getelementptr i8, i8* %15, i16 17
  store i8 114, i8* %33
  %34 = getelementptr i8, i8* %15, i16 18
  store i8 10, i8* %34
  %35 = getelementptr i8, i8* %15, i16 19
  store i8 0, i8* %35
  %36 = alloca i8, i16 20
  %37 = getelementptr i8, i8* %36, i16 0
  store i8 71, i8* %37
  %38 = getelementptr i8, i8* %36, i16 1
  store i8 105, i8* %38
  %39 = getelementptr i8, i8* %36, i16 2
  store i8 118, i8* %39
  %40 = getelementptr i8, i8* %36, i16 3
  store i8 101, i8* %40
  %41 = getelementptr i8, i8* %36, i16 4
  store i8 32, i8* %41
  %42 = getelementptr i8, i8* %36, i16 5
  store i8 109, i8* %42
  %43 = getelementptr i8, i8* %36, i16 6
  store i8 101, i8* %43
  %44 = getelementptr i8, i8* %36, i16 7
  store i8 32, i8* %44
  %45 = getelementptr i8, i8* %36, i16 8
  store i8 97, i8* %45
  %46 = getelementptr i8, i8* %36, i16 9
  store i8 110, i8* %46
  %47 = getelementptr i8, i8* %36, i16 10
  store i8 32, i8* %47
  %48 = getelementptr i8, i8* %36, i16 11
  store i8 105, i8* %48
  %49 = getelementptr i8, i8* %36, i16 12
  store i8 110, i8* %49
  %50 = getelementptr i8, i8* %36, i16 13
  store i8 116, i8* %50
  %51 = getelementptr i8, i8* %36, i16 14
  store i8 101, i8* %51
  %52 = getelementptr i8, i8* %36, i16 15
  store i8 103, i8* %52
  %53 = getelementptr i8, i8* %36, i16 16
  store i8 101, i8* %53
  %54 = getelementptr i8, i8* %36, i16 17
  store i8 114, i8* %54
  %55 = getelementptr i8, i8* %36, i16 18
  store i8 10, i8* %55
  %56 = getelementptr i8, i8* %36, i16 19
  store i8 0, i8* %56
  call void (i8*, ...) @writeString(i8* %36)
  %57 = call i16 @readInteger()
  store i16 %57, i16* %0
  %58 = load i16, i16* %0
  %59 = load i16, i16* %0
  call void @writeInteger(i16 %59)
  store i16* %0, i16** %4
  %60 = icmp eq i1 true, false
  store i1 %60, i1* %1
  %61 = load i1, i1* %1
  %62 = load i1, i1* %1
  call void @writeBoolean(i1 %62)
  %63 = icmp eq i1 false, false
  store i1 %63, i1* %1
  %64 = load i1, i1* %1
  %65 = load i1, i1* %1
  call void @writeBoolean(i1 %65)
  %66 = sub i16 0, 1
  store i16 1, i16* %0
  %67 = load i16, i16* %0
  %68 = load i16, i16* %0
  call void @writeInteger(i16 %68)
  %69 = sub i16 0, 1
  store i16 %69, i16* %0
  %70 = load i16, i16* %0
  %71 = load i16, i16* %0
  call void @writeInteger(i16 %71)
  %72 = fsub double 0.000000e+00, 1.000000e+00
  store double 1.000000e+00, double* %3
  %73 = load double, double* %3
  %74 = load double, double* %3
  call void @writeReal(double %74)
  %75 = fsub double 0.000000e+00, 1.000000e+00
  store double %75, double* %3
  %76 = load double, double* %3
  %77 = load double, double* %3
  call void @writeReal(double %77)
  %78 = add i16 1, 1
  store i16 %78, i16* %0
  %79 = load i16, i16* %0
  %80 = load i16, i16* %0
  call void @writeInteger(i16 %80)
  %81 = sitofp i16 1 to double
  %82 = fadd double %81, 1.000000e+00
  store double %82, double* %3
  %83 = load double, double* %3
  %84 = load double, double* %3
  call void @writeReal(double %84)
  %85 = sitofp i16 1 to double
  %86 = fadd double 1.000000e+00, %85
  store double %86, double* %3
  %87 = load double, double* %3
  %88 = load double, double* %3
  call void @writeReal(double %88)
  %89 = fadd double 1.000000e+00, 1.000000e+00
  store double %89, double* %3
  %90 = load double, double* %3
  %91 = load double, double* %3
  call void @writeReal(double %91)
  %92 = mul i16 1, 1
  store i16 %92, i16* %0
  %93 = load i16, i16* %0
  %94 = load i16, i16* %0
  call void @writeInteger(i16 %94)
  %95 = sitofp i16 1 to double
  %96 = fmul double %95, 1.000000e+00
  store double %96, double* %3
  %97 = load double, double* %3
  %98 = load double, double* %3
  call void @writeReal(double %98)
  %99 = sitofp i16 1 to double
  %100 = fmul double 1.000000e+00, %99
  store double %100, double* %3
  %101 = load double, double* %3
  %102 = load double, double* %3
  call void @writeReal(double %102)
  %103 = fmul double 1.000000e+00, 1.000000e+00
  store double %103, double* %3
  %104 = load double, double* %3
  %105 = load double, double* %3
  call void @writeReal(double %105)
  %106 = sub i16 1, 1
  store i16 %106, i16* %0
  %107 = load i16, i16* %0
  %108 = load i16, i16* %0
  call void @writeInteger(i16 %108)
  %109 = sitofp i16 1 to double
  %110 = fsub double %109, 1.000000e+00
  store double %110, double* %3
  %111 = load double, double* %3
  %112 = load double, double* %3
  call void @writeReal(double %112)
  %113 = sitofp i16 1 to double
  %114 = fsub double 1.000000e+00, %113
  store double %114, double* %3
  %115 = load double, double* %3
  %116 = load double, double* %3
  call void @writeReal(double %116)
  %117 = fsub double 1.000000e+00, 1.000000e+00
  store double %117, double* %3
  %118 = load double, double* %3
  %119 = load double, double* %3
  call void @writeReal(double %119)
  %120 = sitofp i16 1 to double
  %121 = sitofp i16 1 to double
  %122 = fdiv double %120, %121
  store double %122, double* %3
  %123 = load double, double* %3
  %124 = load double, double* %3
  call void @writeReal(double %124)
  %125 = sitofp i16 1 to double
  %126 = fdiv double %125, 1.000000e+00
  store double %126, double* %3
  %127 = load double, double* %3
  %128 = load double, double* %3
  call void @writeReal(double %128)
  %129 = sitofp i16 1 to double
  %130 = fdiv double 1.000000e+00, %129
  store double %130, double* %3
  %131 = load double, double* %3
  %132 = load double, double* %3
  call void @writeReal(double %132)
  %133 = fdiv double 1.000000e+00, 1.000000e+00
  store double %133, double* %3
  %134 = load double, double* %3
  %135 = load double, double* %3
  call void @writeReal(double %135)
  %136 = sdiv i16 3, 2
  store i16 %136, i16* %0
  %137 = load i16, i16* %0
  %138 = load i16, i16* %0
  call void @writeInteger(i16 %138)
  %139 = srem i16 3, 2
  store i16 %139, i16* %0
  %140 = load i16, i16* %0
  %141 = load i16, i16* %0
  call void @writeInteger(i16 %141)
  %142 = or i1 true, false
  store i1 %142, i1* %1
  %143 = load i1, i1* %1
  %144 = load i1, i1* %1
  call void @writeBoolean(i1 %144)
  %145 = and i1 true, false
  store i1 %145, i1* %1
  %146 = load i1, i1* %1
  %147 = load i1, i1* %1
  call void @writeBoolean(i1 %147)
  %148 = icmp eq i16 1, 1
  store i1 %148, i1* %1
  %149 = load i1, i1* %1
  %150 = load i1, i1* %1
  call void @writeBoolean(i1 %150)
  %151 = sitofp i16 1 to double
  %152 = fcmp oeq double 1.000000e+00, %151
  store i1 %152, i1* %1
  %153 = load i1, i1* %1
  %154 = load i1, i1* %1
  call void @writeBoolean(i1 %154)
  %155 = sitofp i16 1 to double
  %156 = fcmp oeq double %155, 1.000000e+00
  store i1 %156, i1* %1
  %157 = load i1, i1* %1
  %158 = load i1, i1* %1
  call void @writeBoolean(i1 %158)
  store i1 true, i1* %1
  %159 = load i1, i1* %1
  %160 = load i1, i1* %1
  call void @writeBoolean(i1 %160)
  %161 = icmp eq i8 97, 97
  store i1 %161, i1* %1
  %162 = load i1, i1* %1
  %163 = load i1, i1* %1
  call void @writeBoolean(i1 %163)
  %164 = icmp eq i1 true, true
  store i1 %164, i1* %1
  %165 = load i1, i1* %1
  %166 = load i1, i1* %1
  call void @writeBoolean(i1 %166)
  %167 = icmp ne i16 1, 1
  store i1 %167, i1* %1
  %168 = load i1, i1* %1
  %169 = load i1, i1* %1
  call void @writeBoolean(i1 %169)
  %170 = sitofp i16 1 to double
  %171 = fcmp one double 1.000000e+00, %170
  store i1 %171, i1* %1
  %172 = load i1, i1* %1
  %173 = load i1, i1* %1
  call void @writeBoolean(i1 %173)
  %174 = sitofp i16 1 to double
  %175 = fcmp one double %174, 1.000000e+00
  store i1 %175, i1* %1
  %176 = load i1, i1* %1
  %177 = load i1, i1* %1
  call void @writeBoolean(i1 %177)
  store i1 false, i1* %1
  %178 = load i1, i1* %1
  %179 = load i1, i1* %1
  call void @writeBoolean(i1 %179)
  %180 = icmp ne i8 97, 97
  store i1 %180, i1* %1
  %181 = load i1, i1* %1
  %182 = load i1, i1* %1
  call void @writeBoolean(i1 %182)
  %183 = icmp ne i1 true, true
  store i1 %183, i1* %1
  %184 = load i1, i1* %1
  %185 = load i1, i1* %1
  call void @writeBoolean(i1 %185)
  %186 = icmp slt i16 1, 1
  store i1 %186, i1* %1
  %187 = load i1, i1* %1
  %188 = load i1, i1* %1
  call void @writeBoolean(i1 %188)
  %189 = sitofp i16 1 to double
  %190 = fcmp olt double 1.000000e+00, %189
  store i1 %190, i1* %1
  %191 = load i1, i1* %1
  %192 = load i1, i1* %1
  call void @writeBoolean(i1 %192)
  %193 = sitofp i16 1 to double
  %194 = fcmp olt double %193, 1.000000e+00
  store i1 %194, i1* %1
  %195 = load i1, i1* %1
  %196 = load i1, i1* %1
  call void @writeBoolean(i1 %196)
  store i1 false, i1* %1
  %197 = load i1, i1* %1
  %198 = load i1, i1* %1
  call void @writeBoolean(i1 %198)
  %199 = icmp sgt i16 1, 1
  store i1 %199, i1* %1
  %200 = load i1, i1* %1
  %201 = load i1, i1* %1
  call void @writeBoolean(i1 %201)
  %202 = sitofp i16 1 to double
  %203 = fcmp ogt double 1.000000e+00, %202
  store i1 %203, i1* %1
  %204 = load i1, i1* %1
  %205 = load i1, i1* %1
  call void @writeBoolean(i1 %205)
  %206 = sitofp i16 1 to double
  %207 = fcmp ogt double %206, 1.000000e+00
  store i1 %207, i1* %1
  %208 = load i1, i1* %1
  %209 = load i1, i1* %1
  call void @writeBoolean(i1 %209)
  store i1 false, i1* %1
  %210 = load i1, i1* %1
  %211 = load i1, i1* %1
  call void @writeBoolean(i1 %211)
  %212 = icmp sle i16 1, 1
  store i1 %212, i1* %1
  %213 = load i1, i1* %1
  %214 = load i1, i1* %1
  call void @writeBoolean(i1 %214)
  %215 = sitofp i16 1 to double
  %216 = fcmp ole double 1.000000e+00, %215
  store i1 %216, i1* %1
  %217 = load i1, i1* %1
  %218 = load i1, i1* %1
  call void @writeBoolean(i1 %218)
  %219 = sitofp i16 1 to double
  %220 = fcmp ole double %219, 1.000000e+00
  store i1 %220, i1* %1
  %221 = load i1, i1* %1
  %222 = load i1, i1* %1
  call void @writeBoolean(i1 %222)
  store i1 true, i1* %1
  %223 = load i1, i1* %1
  %224 = load i1, i1* %1
  call void @writeBoolean(i1 %224)
  %225 = icmp sge i16 1, 1
  store i1 %225, i1* %1
  %226 = load i1, i1* %1
  %227 = load i1, i1* %1
  call void @writeBoolean(i1 %227)
  %228 = sitofp i16 1 to double
  %229 = fcmp oge double 1.000000e+00, %228
  store i1 %229, i1* %1
  %230 = load i1, i1* %1
  %231 = load i1, i1* %1
  call void @writeBoolean(i1 %231)
  %232 = sitofp i16 1 to double
  %233 = fcmp oge double %232, 1.000000e+00
  store i1 %233, i1* %1
  %234 = load i1, i1* %1
  %235 = load i1, i1* %1
  call void @writeBoolean(i1 %235)
  store i1 true, i1* %1
  %236 = load i1, i1* %1
  %237 = load i1, i1* %1
  call void @writeBoolean(i1 %237)
  ret void
}
