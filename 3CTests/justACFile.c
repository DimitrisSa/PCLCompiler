#include<stdio.h>
#include<stdlib.h>

int main(){
  char *c = (char *) malloc(1);
  int **i = (int **) malloc(sizeof(int*));
  free(c);
  free(i);
  return 0;
}
