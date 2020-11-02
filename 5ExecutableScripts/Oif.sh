#!/bin/bash

opt -S -O2 3IntermediateFiles/llvmhs.ll -o 3IntermediateFiles/llvmhsOpt.ll
llc -O2 3IntermediateFiles/llvmhs.ll -o 3IntermediateFiles/llvmhs.s
cat 3IntermediateFiles/llvmhsOpt.ll
cat 3IntermediateFiles/llvmhs.s
