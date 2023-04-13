#!/usr/bin/env bash

HELP="Usage: ./compile.sh MAIN [FILES] [FLAGS]

Mandatory parameters:
  MAIN      Input file containing main()
  FILES     List of additional input files (separated by white spaces)
  FLAGS     Additional flags (separated by white spaces)
"

if (( $# < 1 )); then
  echo -e "$HELP"
  exit 1
fi

ARGS=$@
MAIN="${ARGS%% *}"
EXT="${MAIN##*.}"

MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"
LLVM_BIN_PATH="$MY_PATH/../cryptsan-llvm-project/build-dir/bin"
LLD="$LLVM_BIN_PATH/ld.lld"
LLVM_LIB_PATH="$MY_PATH/../cryptsan-llvm-project/build-dir/lib"
COMPILER_RT_LIB_PATH="$MY_PATH/../cryptsan-llvm-project/build-compiler-rt-dir/lib/linux"
CC="$LLVM_BIN_PATH/clang"
CXX="$LLVM_BIN_PATH/clang++"
CRYPTSAN_LIB="$LLVM_LIB_PATH/LLVMCryptSan.so"
OUT_DIR="$MY_PATH/build"

if [ $EXT = "c" ]; then
  C=$CC
elif [ $EXT = "cpp" ]; then
  C=$CXX
else
  echo -e "$HELP"
  exit 1
fi

CFLAGS="-g -emit-llvm --target=aarch64-linux-gnu -march=armv8.3-a+pauth"
OFLAGS="-debug -load $CRYPTSAN_LIB -cryptsan"
LFLAGS="-g -O0 -flto -fsplit-lto-unit --target=aarch64-linux-gnu -fuse-ld=$LLD -march=armv8.3-a+pauth -Wl,--whole-archive,$COMPILER_RT_LIB_PATH/libclang_rt.cryptsan_lto-aarch64.a,--no-whole-archive,--dynamic-list=$COMPILER_RT_LIB_PATH/libclang_rt.cryptsan_lto-aarch64.a.syms,--no-as-needed,-lpthread,-lrt,-lm,-ldl,-lgcc"

BC="${MAIN%%.*}.ll"
BIR="${MAIN%%.*}.ir"
BIN="${MAIN%%.*}"

rm $BIN 2>/dev/null

# Compile to bitcode
echo "Executing $C $CFLAGS -c $ARGS -o $BC"
$C $CFLAGS -c $ARGS -o $BC

# Run CryptSan pass
if [ $? -eq 0 ]; then
# Compile to binary and link
  if [ $? -eq 0 ]; then
    echo "Executing $C $LFLAGS $BC -o $BIN"
    $C $LFLAGS $BC -o $BIN
    mv $BC $OUT_DIR
    mv $BIN $OUT_DIR
  fi
fi


