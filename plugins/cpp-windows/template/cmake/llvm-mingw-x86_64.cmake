# Cross-compiles for 64-bit Windows from WSL with the pinned llvm-mingw
# (clang, libc++, lld, UCRT). Every executable is linked statically: it
# depends only on DLLs that ship with Windows 10 and later.
#
# scripts/project.sh sets LLVM_MINGW_ROOT to the pinned toolchain; run CMake
# through it (bash scripts/project.sh build|gates|exec cmake ...).

set(LLVM_MINGW_ROOT "$ENV{LLVM_MINGW_ROOT}")
if(NOT LLVM_MINGW_ROOT OR NOT EXISTS "${LLVM_MINGW_ROOT}/bin/clang++")
  message(FATAL_ERROR "llvm-mingw not found (LLVM_MINGW_ROOT='${LLVM_MINGW_ROOT}'): "
                      "run CMake through bash scripts/project.sh")
endif()

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(triple x86_64-w64-mingw32)

set(CMAKE_C_COMPILER "${LLVM_MINGW_ROOT}/bin/${triple}-clang")
set(CMAKE_CXX_COMPILER "${LLVM_MINGW_ROOT}/bin/${triple}-clang++")
# An explicit --target in every compile command, so clang-tidy analyzes the
# code for Windows with libc++ instead of for the Linux host.
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})
set(CMAKE_RC_COMPILER "${LLVM_MINGW_ROOT}/bin/${triple}-windres")
set(CMAKE_AR "${LLVM_MINGW_ROOT}/bin/llvm-ar")
set(CMAKE_RANLIB "${LLVM_MINGW_ROOT}/bin/llvm-ranlib")

set(CMAKE_FIND_ROOT_PATH "${LLVM_MINGW_ROOT}/${triple}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Static libc++, libunwind, winpthreads and compiler runtime.
set(CMAKE_EXE_LINKER_FLAGS_INIT "-static")
