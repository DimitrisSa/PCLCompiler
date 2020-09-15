#!/bin/bash

llc llvmhs.ll
##cat llvmhs.ll
gcc -no-pie llvmhs.s
./a.out
