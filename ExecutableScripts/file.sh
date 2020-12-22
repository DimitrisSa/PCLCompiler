#!/bin/bash

ll=$1.ll
imm=$1.imm
asm=$1.asm
cp $ll $imm
llc $ll -o $asm
