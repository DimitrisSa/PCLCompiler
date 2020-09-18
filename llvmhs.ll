; ModuleID = 'hello'
source_filename = "<string>"

@.intStr = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@true = private unnamed_addr constant [6 x i8] c"true\0A\00", align 1
@false = private unnamed_addr constant [7 x i8] c"false\0A\00", align 1
@.charStr = private unnamed_addr constant [4 x i8] c"%c\0A\00", align 1
@.realStr = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@scanfStr = private unnamed_addr constant [3 x i8] c"%c\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @__isoc99_scanf(i8*, ...)

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
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.realStr, i16 0, i16 0
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
  %2 = getelementptr inbounds [3 x i8], [3 x i8]* @scanfStr, i16 0, i16 0
  %3 = alloca i16
  store i16 0, i16* %3
  %4 = sub i16 %0, 1
  %5 = icmp slt i16 0, %4
  br i1 %5, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %6 = load i16, i16* %3
  %7 = getelementptr i8, i8* %1, i16 %6
  %8 = call i32 (i8*, ...) @__isoc99_scanf(i8* %2, i8* %7)
  %9 = load i8, i8* %7
  %10 = icmp ne i8 %9, 10
  %11 = add i16 %6, 1
  store i16 %11, i16* %3
  %12 = icmp slt i16 %11, %4
  %13 = and i1 %10, %12
  br i1 %13, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  %14 = load i16, i16* %3
  %15 = getelementptr i8, i8* %1, i16 %14
  store i8 0, i8* %15
  ret void
}

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
  %0 = alloca i16
  %1 = alloca double
  %2 = alloca i1
  %3 = alloca i8
  %4 = alloca [10 x i8]
  %5 = alloca [10 x i8]*
  store [10 x i8]* %4, [10 x i8]** %5
  store i16 1, i16* %0
  %6 = load i16, i16* %0
  %7 = sitofp i16 %6 to double
  store double %7, double* %1
  store i1 true, i1* %2
  store i8 99, i8* %3
  %8 = load i16, i16* %0
  %9 = load i16, i16* %0
  call void @writeInteger(i16 %9)
  %10 = load double, double* %1
  %11 = load double, double* %1
  call void @writeReal(double %11)
  %12 = load i1, i1* %2
  %13 = load i1, i1* %2
  call void @writeBoolean(i1 %13)
  %14 = load i8, i8* %3
  %15 = load i8, i8* %3
  call void @writeChar(i8 %15)
  %16 = alloca i8*
  %17 = alloca i8, i16 13
  %18 = getelementptr i8, i8* %17, i16 0
  store i8 72, i8* %18
  %19 = getelementptr i8, i8* %17, i16 1
  store i8 101, i8* %19
  %20 = getelementptr i8, i8* %17, i16 2
  store i8 108, i8* %20
  %21 = getelementptr i8, i8* %17, i16 3
  store i8 108, i8* %21
  %22 = getelementptr i8, i8* %17, i16 4
  store i8 111, i8* %22
  %23 = getelementptr i8, i8* %17, i16 5
  store i8 32, i8* %23
  %24 = getelementptr i8, i8* %17, i16 6
  store i8 87, i8* %24
  %25 = getelementptr i8, i8* %17, i16 7
  store i8 111, i8* %25
  %26 = getelementptr i8, i8* %17, i16 8
  store i8 114, i8* %26
  %27 = getelementptr i8, i8* %17, i16 9
  store i8 108, i8* %27
  %28 = getelementptr i8, i8* %17, i16 10
  store i8 100, i8* %28
  %29 = getelementptr i8, i8* %17, i16 11
  store i8 10, i8* %29
  %30 = getelementptr i8, i8* %17, i16 12
  store i8 0, i8* %30
  store i8* %17, i8** %16
  %31 = load i8*, i8** %16
  %32 = alloca i8*
  %33 = alloca i8, i16 13
  %34 = getelementptr i8, i8* %33, i16 0
  store i8 72, i8* %34
  %35 = getelementptr i8, i8* %33, i16 1
  store i8 101, i8* %35
  %36 = getelementptr i8, i8* %33, i16 2
  store i8 108, i8* %36
  %37 = getelementptr i8, i8* %33, i16 3
  store i8 108, i8* %37
  %38 = getelementptr i8, i8* %33, i16 4
  store i8 111, i8* %38
  %39 = getelementptr i8, i8* %33, i16 5
  store i8 32, i8* %39
  %40 = getelementptr i8, i8* %33, i16 6
  store i8 87, i8* %40
  %41 = getelementptr i8, i8* %33, i16 7
  store i8 111, i8* %41
  %42 = getelementptr i8, i8* %33, i16 8
  store i8 114, i8* %42
  %43 = getelementptr i8, i8* %33, i16 9
  store i8 108, i8* %43
  %44 = getelementptr i8, i8* %33, i16 10
  store i8 100, i8* %44
  %45 = getelementptr i8, i8* %33, i16 11
  store i8 10, i8* %45
  %46 = getelementptr i8, i8* %33, i16 12
  store i8 0, i8* %46
  store i8* %33, i8** %32
  %47 = load i8*, i8** %32
  call void (i8*, ...) @writeString(i8* %47)
  %48 = load [10 x i8]*, [10 x i8]** %5
  %49 = load [10 x i8]*, [10 x i8]** %5
  %50 = getelementptr [10 x i8], [10 x i8]* %49, i16 0, i16 0
  call void @readString(i16 5, i8* %50)
  %51 = load [10 x i8]*, [10 x i8]** %5
  %52 = load [10 x i8]*, [10 x i8]** %5
  %53 = getelementptr [10 x i8], [10 x i8]* %52, i16 0, i16 0
  call void (i8*, ...) @writeString(i8* %53)
  %54 = load [10 x i8]*, [10 x i8]** %5
  %55 = load [10 x i8]*, [10 x i8]** %5
  %56 = getelementptr [10 x i8], [10 x i8]* %55, i16 0, i16 0
  call void @readString(i16 5, i8* %56)
  %57 = load [10 x i8]*, [10 x i8]** %5
  %58 = load [10 x i8]*, [10 x i8]** %5
  %59 = getelementptr [10 x i8], [10 x i8]* %58, i16 0, i16 0
  call void (i8*, ...) @writeString(i8* %59)
  ret void
}
