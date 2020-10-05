#include<stdio.h>
#include<stdlib.h>

int main(){
  char *str = (char *) malloc(1);
  free(str);
  return 0;
}
