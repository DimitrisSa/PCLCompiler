#!/bin/bash

for file in 0PCL/0PCLExamples/*
do
  echo "$file:"
  cabal new-run < $file
  echo ""
done
