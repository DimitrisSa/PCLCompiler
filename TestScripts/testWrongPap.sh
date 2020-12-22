#!/bin/bash

cd ..
for file in PCL/Examples/Wrong2/*
do
  echo "$file:"
  ./0PCLCompiler -f < $file
  echo ""
done
