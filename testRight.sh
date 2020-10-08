#!/bin/bash

for file in 0PCL/0PCLExamples/2Right/*
do
  echo "$file:"
  cabal run < $file
  echo ""
done
