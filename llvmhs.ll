; ModuleID = 'hello'
source_filename = "<string>"

define void @main() {
entry:
  %0 = alloca double
  %1 = alloca double
  %2 = alloca [2 x double]
  %3 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 0
  store double 1.000000e+00, double* %3
  %4 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 1
  store double 2.000000e+00, double* %4
  store double 1.000000e+01, double* %0
  %5 = fsub double 0.000000e+00, 1.000000e+00
  store double %5, double* %1
  %6 = load double, double* %0
  %7 = fcmp ogt double %6, 0.000000e+00
  br i1 %7, label %while, label %while.exit

while:                                            ; preds = %while, %entry
  %8 = load double, double* %0
  %9 = load double, double* %1
  %10 = fadd double %8, %9
  store double %10, double* %0
  %11 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 1
  %12 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 1
  %13 = load double, double* %12
  %14 = fadd double %13, 1.000000e+00
  store double %14, double* %11
  %15 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 0
  %16 = getelementptr [2 x double], [2 x double]* %2, i16 0, i16 0
  %17 = load double, double* %16
  %18 = fadd double %17, 1.000000e+00
  store double %18, double* %15
  %19 = load double, double* %0
  %20 = fcmp ogt double %19, 0.000000e+00
  br i1 %20, label %while, label %while.exit

while.exit:                                       ; preds = %while, %entry
  ret void
}
