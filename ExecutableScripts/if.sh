#!/bin/bash

ifs=IntermediateFiles
llc $ifs/llvmhs.ll -o $ifs/llvmhs.s
cat $ifs/llvmhs.*
