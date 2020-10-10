#include<stdio.h>
#include<stdlib.h>

void foo(double a){
  a = 2.0;
}

int main(){
  double a;
  foo(a);
  return 0;
}
