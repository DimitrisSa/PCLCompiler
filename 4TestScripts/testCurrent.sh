#!/bin/bash

cd ..
for file in 0PCL/0PCLExamples/*.pcl
do
  echo "$file:"
  cabal run < $file
#  ./a.out
  echo ""
done
