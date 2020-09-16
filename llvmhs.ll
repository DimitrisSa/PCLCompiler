; ModuleID = 'hello'
source_filename = "<string>"

declare i32 @printf(i8*, ...)

declare void @writeInteger(i16)

declare void @writeBoolean(i1)

declare void @writeChar(i8)

declare void @writeReal(double)

define void @writeString(i8*) {
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
  ret void
}
