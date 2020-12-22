#!/bin/bash

ifs=IntermediateFiles
opt -S -O2 $ifs/llvmhs.ll -o $ifs/llvmhsOpt.ll
llc -O2 $ifs/llvmhs.ll -o $ifs/llvmhs.s
cat $ifs/llvmhsOpt.ll
cat $ifs/llvmhs.s
