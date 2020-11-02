#!/bin/bash

llc 3IntermediateFiles/llvmhs.ll -o 3IntermediateFiles/llvmhs.s
cat 3IntermediateFiles/llvmhs.*
