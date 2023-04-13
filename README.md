# CryptSan: Leveraging ARM Pointer Authentication for Memory Safety in C/C++
This project is not maintained. It has been published as part of the following SAC '23 conference paper:

> Konrad Hohentanner, Philipp Zieris, and Julian Horsch. 2023. CryptSan:
> Leveraging ARM Pointer Authentication for Memory Safety in C/C++. In
> The 38th ACM/SIGAPP Symposium on Applied Computing (SAC ’23), March
> 27-April 2, 2023, Tallinn, Estonia. ACM, New York, NY, USA, 10 pages. https://doi.org/10.1145/3555776.3577635

Note that these repositories present a **prototype** implementation and are **not** to be used in production.

## Introduction
This archive contains the necessary patches and scripts to setup and build the
CryptSan LLVM project. Because of its dependency on the ARM Pointer
Authentication feature, it **only supports ARMv8.3 devices**. The build results in a Clang compiler that is able to build
CryptSan-protected programs from C/C++ source code.

## Setup Source Code
To setup the project, run:

    $ ./setup.sh

Note that cmake and a working clang compiler is required for the build.
This script will:

  * Clone the LLVM 12 repository with the added CryptSan Sources
  * Build the LLVM repository to generate the clang compiler with cryptsan enabled

Afterwards, the CryptSan code can be found in the following subdirectories:

  * `llvm-project/llvm/lib/CryptSan` - Contains the CryptSan Pass to instrument
    C/C++ source code with pointer authentication
  * `llvm-project/compiler-rt/cryptsan` - Contains the source code of the
    CryptSan compiler-rt library providing stdlib wrappers, allocation
    wrappers, and initialization routines

## ARMv8.3 Linux: Run Example
After setting up the LLVM repository with the added CryptSan instrumentation, the following command will run an example showing the bug detection of CryptSan:

    $ ./example.sh

## M1/M2 macOS: Run Example
Due to the dependency on the new Pointer Authentication (PA) feature, this
step only works macOS platforms with user space PA
enabled and has been tested on macOS 11. To enable user space PA, the system
integrity protection has to be disabled [1].

Additionally, the following command is necessary:

    $ sudo nvram boot-args=-arm64e_preview_abi
    
Run the example:
 
    $ ./example.sh

[1] https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection  