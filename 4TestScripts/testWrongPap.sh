#!/bin/bash

cd ..
for file in 0PCL/0PCLExamples/5Wrong/*
do
  echo "$file:"
  ./0PCLCompiler -f < $file
  echo ""
done
