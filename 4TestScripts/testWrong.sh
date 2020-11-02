#!/bin/bash

cd ..
for file in 0PCL/0PCLExamples/3Wrong/*
do
  echo "$file:"
  ./0PCLCompiler -f < $file
  echo ""
done
