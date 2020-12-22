#!/bin/bash

ifs=IntermediateFiles 
ll=$2.ll
imm=$2.imm
asm=$2.asm

case $1 in
f) llc $ifs/llvmhs.ll -o $ifs/llvmhs.s;cat $ifs/llvmhs.s;;
if) llc $ifs/llvmhs.ll -o $ifs/llvmhs.s;cat $ifs/llvmhs.*;;
Of) llc -O2 $ifs/llvmhs.ll -o $ifs/llvmhs.s; cat $ifs/llvmhs.s;;
Oi) opt -S -o $ifs/llvmhsOpt.ll -O2 $ifs/llvmhs.ll; cat $ifs/llvmhsOpt.ll;;
Oif) opt -S -o $ifs/llvmhsOpt.ll -O2 $ifs/llvmhs.ll; llc -O2 $ifs/llvmhs.ll -o $ifs/llvmhs.s;
     cat $ifs/llvmhsOpt.ll; cat $ifs/llvmhs.s;;
file) cp $ll $imm; llc $ll -o $asm;;
Ofile) opt -S -O2 $ll -o $imm; llc -O2 $ll -o $asm;;
*) echo "Wrong Inputs to compilation script"
esac
