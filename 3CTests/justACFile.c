#include<stdio.h>
#include<stdlib.h>

void foo(double *a){
  printf("hello");
}

int main(){
  double a[2];
  foo(a);
  return 0;
}
