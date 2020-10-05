#!/bin/bash

clang -S -emit-llvm justACFile.c
cat justACFile.ll
