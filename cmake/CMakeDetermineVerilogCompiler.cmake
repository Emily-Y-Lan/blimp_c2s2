# ========================================================================
# CMakeDetermineVerilogCompiler.cmake
# ========================================================================
# Determine whether we have a Verilog compiler. Currently, only
# iverilog is supported

# Find the compiler
find_program(
  CMAKE_Verilog_COMPILER 
  NAMES verilator_bin verilator_bin.exe
  DOC "Verilog compiler" 
)
mark_as_advanced(CMAKE_Verilog_COMPILER)

set(CMAKE_Verilog_SOURCE_FILE_EXTENSIONS v;sv)
set(CMAKE_Verilog_OUTPUT_EXTENSION .a)
set(CMAKE_Verilog_COMPILER_ENV_VAR "Verilog")
set(CMAKE_Verilog_STANDARD_LIBRARIES "")
set(CMAKE_Verilog_IMPLICIT_LINK_LIBRARIES pthread)

# Configure variables set in this file for fast reload later on
configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeVerilogCompiler.cmake.in
               ${CMAKE_PLATFORM_INFO_DIR}/CMakeVerilogCompiler.cmake)