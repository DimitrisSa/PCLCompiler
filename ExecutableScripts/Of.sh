#!/bin/bash

ifs=IntermediateFiles
llc -O2 $ifs/llvmhs.ll -o $ifs/llvmhs.s
cat $ifs/llvmhs.s
