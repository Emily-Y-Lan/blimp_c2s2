# ========================================================================
# CMakeVerilogInformation.cmake
# ========================================================================
# Information about how to use our compiler

# No separate object files - just run preprocessor
if(NOT CMAKE_Verilog_COMPILE_OBJECT)
  set(CMAKE_Verilog_COMPILE_OBJECT "<CMAKE_Verilog_COMPILER> -E <DEFINES> <INCLUDES> <SOURCE> > <OBJECT>")
endif()

# Use linker to actually compile
if(NOT CMAKE_Verilog_LINK_EXECUTABLE)
  set(CMAKE_Verilog_LINK_EXECUTABLE "<CMAKE_Verilog_COMPILER> <LINK_FLAGS> <OBJECTS> -o <TARGET>")
endif()

# Set flag for includes
if(NOT CMAKE_INCLUDE_FLAG_Verilog)
  set(CMAKE_INCLUDE_FLAG_Verilog "-I")
endif()

# Set flag for defines
if(NOT CMAKE_Verilog_DEFINE_FLAG)
  set(CMAKE_Verilog_DEFINE_FLAG "-D")
endif()
set(CMAKE_Verilog_INFORMATION_LOADED 1)