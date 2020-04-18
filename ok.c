#include<stdio.h>
//#include<_.h>

void ok() {
  goto ok;
  return;
}

int main(){

ok:
  printf("ok\n");
  return 0;
}


