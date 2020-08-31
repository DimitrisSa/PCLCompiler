; ModuleID = 'hello'
source_filename = "<string>"

declare i32 @printf(i8*, ...)

define i32 @writeString(i8*, ...) {
entry:
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  ret i32 %1
}

define void @main() {
entry:
  %0 = alloca i8*
  %1 = alloca i8, i16 15
  %2 = getelementptr i8, i8* %1, i16 0
  store i8 72, i8* %2
  %3 = getelementptr i8, i8* %1, i16 1
  store i8 101, i8* %3
  %4 = getelementptr i8, i8* %1, i16 2
  store i8 108, i8* %4
  %5 = getelementptr i8, i8* %1, i16 3
  store i8 108, i8* %5
  %6 = getelementptr i8, i8* %1, i16 4
  store i8 111, i8* %6
  %7 = getelementptr i8, i8* %1, i16 5
  store i8 32, i8* %7
  %8 = getelementptr i8, i8* %1, i16 6
  store i8 87, i8* %8
  %9 = getelementptr i8, i8* %1, i16 7
  store i8 111, i8* %9
  %10 = getelementptr i8, i8* %1, i16 8
  store i8 114, i8* %10
  %11 = getelementptr i8, i8* %1, i16 9
  store i8 108, i8* %11
  %12 = getelementptr i8, i8* %1, i16 10
  store i8 100, i8* %12
  %13 = getelementptr i8, i8* %1, i16 11
  store i8 32, i8* %13
  %14 = getelementptr i8, i8* %1, i16 12
  store i8 92, i8* %14
  %15 = getelementptr i8, i8* %1, i16 13
  store i8 110, i8* %15
  %16 = getelementptr i8, i8* %1, i16 14
  store i8 0, i8* %16
  store i8* %1, i8** %0
  %17 = load i8*, i8** %0
  %18 = call i32 (i8*, ...) @writeString(i8* %17)
  ret void
}
