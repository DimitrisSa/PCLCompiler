#!/bin/bash

for file in 0PCL/0PCLExamples/1Παπασπύρου/*
do
  echo "$file:"
  cabal run < $file
  echo ""
done
