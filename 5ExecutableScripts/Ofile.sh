#!/bin/bash

ll=$1.ll
imm=$1.imm
asm=$1.asm
opt -S -O2 $ll -o $imm
llc -O2 $ll -o $asm
