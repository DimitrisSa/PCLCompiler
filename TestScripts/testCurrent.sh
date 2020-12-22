#!/bin/bash

cd ..
for file in PCL/Examples/*.pcl
do
  echo "$file:"
  ./0PCLCompiler -f < $file > llvmhs.s
  gcc -no-pie llvmhs.s -lm
  ./a.out
done
