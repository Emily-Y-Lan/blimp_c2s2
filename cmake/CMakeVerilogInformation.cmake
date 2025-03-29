# ========================================================================
# CMakeVerilogInformation.cmake
# ========================================================================
# Information about how to use our compiler

# Verilate files
if(NOT CMAKE_Verilog_COMPILE_OBJECT)
  set(CMAKE_Verilog_COMPILE_OBJECT
    "<CMAKE_Verilog_COMPILER> <FLAGS> --cc --main <DEFINES> <INCLUDES> <SOURCE> --Mdir <OBJECT>.vobjs --prefix VModel"
    "+make -C <OBJECT>.vobjs -f VModel.mk"
    "<CMAKE_AR> rc --thin <OBJECT> <OBJECT>.vobjs/libVModel.a <OBJECT>.vobjs/libverilated.a"
  )
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