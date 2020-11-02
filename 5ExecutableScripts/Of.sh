#!/bin/bash

llc -O2 3IntermediateFiles/llvmhs.ll -o 3IntermediateFiles/llvmhs.s
cat 3IntermediateFiles/llvmhs.s
