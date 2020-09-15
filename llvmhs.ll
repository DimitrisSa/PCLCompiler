; ModuleID = 'hello'
source_filename = "<string>"

@.str = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @writeReal(double) {
entry:
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i16 0, i16 0
  %2 = call i32 (i8*, ...) @printf(i8* %1, double %0)
  ret void
}

define void @writeString(i8*, ...) {
entry:
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  ret void
}

define void @main() {
entry:
  %0 = alloca double
  store double 0.000000e+00, double* %0
  %1 = load double, double* %0
  %2 = fcmp olt double %1, 1.000000e+01
  br i1 %2, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %3 = load double, double* %0
  %4 = fadd double %3, 1.000000e+00
  store double %4, double* %0
  %5 = load double, double* %0
  call void @writeReal(double %5)
  %6 = load double, double* %0
  %7 = fcmp olt double %6, 1.000000e+01
  br i1 %7, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %8 = alloca i8*
  %9 = alloca i8, i16 15
  %10 = getelementptr i8, i8* %9, i16 0
  store i8 119, i8* %10
  %11 = getelementptr i8, i8* %9, i16 1
  store i8 114, i8* %11
  %12 = getelementptr i8, i8* %9, i16 2
  store i8 111, i8* %12
  %13 = getelementptr i8, i8* %9, i16 3
  store i8 116, i8* %13
  %14 = getelementptr i8, i8* %9, i16 4
  store i8 101, i8* %14
  %15 = getelementptr i8, i8* %9, i16 5
  store i8 32, i8* %15
  %16 = getelementptr i8, i8* %9, i16 6
  store i8 114, i8* %16
  %17 = getelementptr i8, i8* %9, i16 7
  store i8 101, i8* %17
  %18 = getelementptr i8, i8* %9, i16 8
  store i8 97, i8* %18
  %19 = getelementptr i8, i8* %9, i16 9
  store i8 108, i8* %19
  %20 = getelementptr i8, i8* %9, i16 10
  store i8 115, i8* %20
  %21 = getelementptr i8, i8* %9, i16 11
  store i8 33, i8* %21
  %22 = getelementptr i8, i8* %9, i16 12
  store i8 33, i8* %22
  %23 = getelementptr i8, i8* %9, i16 13
  store i8 10, i8* %23
  %24 = getelementptr i8, i8* %9, i16 14
  store i8 0, i8* %24
  store i8* %9, i8** %8
  %25 = load i8*, i8** %8
  call void (i8*, ...) @writeString(i8* %25)
  ret void
}
