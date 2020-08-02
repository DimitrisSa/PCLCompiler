#!/bin/bash

for file in 0PCL/0PCLExamples/*
do
  echo "$file:"
  ./compiler < $file
  echo ""
done
