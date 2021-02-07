#!/bin/bash

cd ..
for file in PCL/Examples/Wrong/*
do
  echo "$file:"
  ./PCLCompiler -f < $file
  echo ""
done
