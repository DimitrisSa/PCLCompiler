#!/bin/bash

cd ..
for file in PCL/Examples/Wrong2/*
do
  echo "$file:"
  ./PCLCompiler -f < $file
  echo ""
done
