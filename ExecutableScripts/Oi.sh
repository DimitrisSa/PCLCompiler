#!/bin/bash

ifs=IntermediateFiles
opt -S -o $ifs/llvmhsOpt.ll -O2 $ifs/llvmhs.ll
cat $ifs/llvmhsOpt.ll
