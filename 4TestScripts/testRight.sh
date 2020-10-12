#!/bin/bash

cd ..
for file in 0PCL/0PCLExamples/2Right/*
do
  echo "$file:"
  cabal run < $file
  ./a.out
  echo ""
done
