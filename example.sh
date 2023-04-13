#!/usr/bin/env bash

set -ue

cd example
mkdir -p build
if [ "$(uname)" == "Darwin" ]; then
    ./compile-bc_apple.sh test-cryptsan.c
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    ./compile-bc.sh test-cryptsan.c
fi
# Run binary
echo "## Executing binary without violation ##"
./build/test-cryptsan 0

echo "## Executing binary with violation ##"
./build/test-cryptsan 1
