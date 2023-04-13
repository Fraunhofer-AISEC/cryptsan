#!/usr/bin/env bash

set -ue

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LLVM_DIR="${SCRIPT_ROOT}/cryptsan-llvm-project"
BUILD_DIR="${SCRIPT_ROOT}/llvm-project/build"
BUILD_COMPILER_RT_DIR="${SCRIPT_ROOT}/llvm-project/build-compiler-rt"

echo "CRYPTSAN: Clone LLVM"
git clone https://github.com/Fraunhofer-AISEC/cryptsan-llvm-project.git cryptsan-llvm-project
cd $LLVM_DIR

if [ "$(uname)" == "Darwin" ]; then
    ./local-build-apple.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    ./local-build-aarch64.sh
fi
