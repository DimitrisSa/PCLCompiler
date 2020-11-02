#!/bin/bash

cd ..
for file in 0PCL/0PCLExamples/1Παπασπύρου/*.pcl
do
  echo "$file:"
  ./0PCLCompiler -f < $file > llvmhs.s
  gcc -no-pie llvmhs.s -lm
  echo "no opt time:"
  time ./a.out
  ./0PCLCompiler -O -f < $file > llvmhs.s
  gcc -no-pie llvmhs.s -lm
  echo "opt time:"
  time ./a.out
done
