#!/bin/bash

cd ..
for file in PCL/Examples/Right/*.pcl
do
  echo "$file:"
  ./PCLCompiler -f < $file > llvmhs.s
  gcc -no-pie llvmhs.s -lm
  echo "no opt time:"
  time ./a.out
  ./PCLCompiler -O -f < $file > llvmhs.s
  gcc -no-pie llvmhs.s -lm
  echo "opt time:"
  time ./a.out
done
