# ========================================================================
# rv32.cmake
# ========================================================================
# A toolchain for compiling RISCV binaries for Blimp
# Based off of Derin Ozturk's toolchain: 
#  - https://github.com/cornell-brg/ento-bench/blob/main/gem5-cmake/rv32-gem5.cmake

if(RISCV_TOOLCHAIN_INCLUDED)
  return()
endif(RISCV_TOOLCHAIN_INCLUDED)
set(RISCV_TOOLCHAIN_INCLUDED true)

if(NOT DEFINED TOOLCHAIN_PREFIX)
set(TOOLCHAIN_PREFIX riscv64-unknown-linux-gnu-)
endif()

FIND_FILE(RISCV_GCC_COMPILER ${TOOLCHAIN_PREFIX}gcc PATHS ENV INCLUDE)
if (EXISTS ${RISCV_GCC_COMPILER})
message("Found RISC-V GCC Toolchain: ${RISCV_GCC_COMPILER}")
else()
message(FATAL_ERROR "RISC-V GCC Toolchain not found!")
endif()

get_filename_component(RISCV_TOOLCHAIN_BIN_PATH ${RISCV_GCC_COMPILER} DIRECTORY)
get_filename_component(RISCV_TOOLCHAIN_BIN_GCC ${RISCV_GCC_COMPILER} NAME_WE)
get_filename_component(RISCV_TOOLCHAIN_BIN_EXT ${RISCV_GCC_COMPILER} EXT)
message("Found RISCV toolchain path, prefix, and ext: ${RISCV_TOOLCHAIN_BIN_PATH}, ${RISCV_TOOLCHAIN_BIN_GCC}, ${RISCV_TOOLCHAIN_BIN_EXT}")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR RISCV)

set(CMAKE_C_COMPILER ${RISCV_TOOLCHAIN_BIN_PATH}/${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${RISCV_TOOLCHAIN_BIN_PATH}/${TOOLCHAIN_PREFIX}g++)
set(CMAKE_ASM_COMPILER ${RISCV_TOOLCHAIN_BIN_PATH}/${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_AR ${RISCV_TOOLCHAIN_BIN_PATH}/${TOOLCHAIN_PREFIX}ar)
set(CMAKE_OBJCOPY ${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILE}objcopy CACHE FILEPATH "The toolchain objcopy command " FORCE)
set(CMAKE_OBJDUMP ${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILE}objdump CACHE FILEPATH "The toolchain objdump command " FORCE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O3 -D_RISCV -fno-builtin -march=rv32imac -mabi=ilp32")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++20")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}")
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostdlib -nostartfiles -T${CMAKE_CURRENT_SOURCE_DIR}/scripts/tinyrv2.ld" )