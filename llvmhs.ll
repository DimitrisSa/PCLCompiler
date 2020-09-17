; ModuleID = 'hello'
source_filename = "<string>"

@.intStr = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.charStr = private unnamed_addr constant [4 x i8] c"%c\0A\00", align 1
@.realStr = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @writeInteger(i16) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.intStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i16 %0)
  ret void
}

declare void @writeBoolean(i1)

define void @writeChar(i8) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.charStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, i8 %0)
  ret void
}

define void @writeReal(double) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.realStr, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, double %0)
  ret void
}

define void @writeString(i8*, ...) {
entry:
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  ret void
}

declare void @readString(i16, i8*)

declare i16 @readInteger()

declare i1 @readBoolean()

declare i8 @readChar()

declare double @readReal()

declare i16 @abs(i16)

declare double @fabs(double)

declare double @sqrt(double)

declare double @sin(double)

declare double @cos(double)

declare double @tan(double)

declare double @arctan(double)

declare double @exp(double)

declare double @ln(double)

declare double @pi()

declare i16 @trunc(double)

declare i16 @round(double)

declare i16 @ord(i8)

declare i8 @chr(i16)

define void @main() {
entry:
  %0 = alloca double
  %1 = alloca i16
  %2 = alloca i8
  store i16 1, i16* %1
  %3 = load i16, i16* %1
  %4 = sitofp i16 %3 to double
  store double %4, double* %0
  store i8 99, i8* %2
  %5 = load double, double* %0
  %6 = load double, double* %0
  call void @writeReal(double %6)
  %7 = load i16, i16* %1
  %8 = load i16, i16* %1
  call void @writeInteger(i16 %8)
  %9 = load i8, i8* %2
  %10 = load i8, i8* %2
  call void @writeChar(i8 %10)
  ret void
}
