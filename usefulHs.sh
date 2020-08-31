#!/bin/bash

llc llvmhs.ll
cat llvmhs.s
gcc -no-pie llvmhs.s
./a.out
