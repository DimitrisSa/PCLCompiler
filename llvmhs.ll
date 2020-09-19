; ModuleID = 'hello'
source_filename = "<string>"

@.intStr = private unnamed_addr constant [5 x i8] c"%hi\0A\00", align 1
@true = private unnamed_addr constant [6 x i8] c"true\0A\00", align 1
@false = private unnamed_addr constant [7 x i8] c"false\0A\00", align 1
@.charStr = private unnamed_addr constant [4 x i8] c"%c\0A\00", align 1
@.realStr = private unnamed_addr constant [5 x i8] c"%lf\0A\00", align 1
@scanfChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.scanInt = private unnamed_addr constant [4 x i8] c"%hi\00", align 1
@.scanChar = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.scanReal = private unnamed_addr constant [4 x i8] c"%lf\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @__isoc99_scanf(i8*, ...)

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

declare i1 @readBoolean()

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

declare i16 @abs(i16)

declare double @fabs(double)

declare double @sqrt(double)

declare double @sin(double)

declare double @cos(double)

declare double @tan(double)

declare double @atan(double)

declare double @exp(double)

declare double @log(double)

declare double @pi()

declare i16 @trunc(double)

declare i16 @round(double)

declare i16 @ord(i8)

declare i8 @chr(i16)

define void @main() {
entry:
  %0 = alloca double
  %1 = alloca double
  %2 = alloca i16
  %3 = alloca i16
  %4 = call i16 @readInteger()
  store i16 %4, i16* %2
  %5 = load i16, i16* %2
  %6 = load i16, i16* %2
  %7 = call i16 @abs(i16 %6)
  store i16 %7, i16* %3
  %8 = load i16, i16* %3
  %9 = load i16, i16* %3
  call void @writeInteger(i16 %9)
  %10 = call double @readReal()
  store double %10, double* %0
  %11 = load double, double* %0
  %12 = load double, double* %0
  %13 = call double @fabs(double %12)
  store double %13, double* %1
  %14 = load double, double* %1
  %15 = load double, double* %1
  call void @writeReal(double %15)
  %16 = load double, double* %0
  %17 = load double, double* %0
  %18 = call double @sqrt(double %17)
  store double %18, double* %1
  %19 = load double, double* %1
  %20 = load double, double* %1
  call void @writeReal(double %20)
  %21 = load double, double* %0
  %22 = load double, double* %0
  %23 = call double @sin(double %22)
  store double %23, double* %1
  %24 = load double, double* %1
  %25 = load double, double* %1
  call void @writeReal(double %25)
  %26 = load double, double* %0
  %27 = load double, double* %0
  %28 = call double @cos(double %27)
  store double %28, double* %1
  %29 = load double, double* %1
  %30 = load double, double* %1
  call void @writeReal(double %30)
  %31 = load double, double* %0
  %32 = load double, double* %0
  %33 = call double @tan(double %32)
  store double %33, double* %1
  %34 = load double, double* %1
  %35 = load double, double* %1
  call void @writeReal(double %35)
  %36 = load double, double* %0
  %37 = load double, double* %0
  %38 = call double @atan(double %37)
  store double %38, double* %1
  %39 = load double, double* %1
  %40 = load double, double* %1
  call void @writeReal(double %40)
  %41 = load double, double* %0
  %42 = load double, double* %0
  %43 = call double @tan(double %42)
  %44 = load double, double* %0
  %45 = load double, double* %0
  %46 = call double @tan(double %45)
  %47 = call double @atan(double %46)
  store double %47, double* %1
  %48 = load double, double* %1
  %49 = load double, double* %1
  call void @writeReal(double %49)
  %50 = load double, double* %0
  %51 = load double, double* %0
  %52 = call double @exp(double %51)
  store double %52, double* %1
  %53 = load double, double* %1
  %54 = load double, double* %1
  call void @writeReal(double %54)
  %55 = load double, double* %0
  %56 = load double, double* %0
  %57 = call double @log(double %56)
  store double %57, double* %1
  %58 = load double, double* %1
  %59 = load double, double* %1
  call void @writeReal(double %59)
  ret void
}
