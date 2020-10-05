#include<stdio.h>
#include<stdlib.h>

int main(){
  double **a = &malloc(2*sizeof(double));
  double b;
  *a[0] = 2.1234;
  b = *a[0];
  printf("%lf",b);
  return 0;
}
