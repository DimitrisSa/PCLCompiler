#!/bin/bash

opt -S -o 3IntermediateFiles/llvmhsOpt.ll -O2 3IntermediateFiles/llvmhs.ll
cat 3IntermediateFiles/llvmhsOpt.ll
