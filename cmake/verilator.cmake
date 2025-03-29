# ========================================================================
# verilator.cmake
# ========================================================================
# Utility functions for using Verilator as a Verilog compiler

# ------------------------------------------------------------------------
# vbuild
# ------------------------------------------------------------------------
# Call on a Verilog target to ensure that it's built

function(vbuild TARGET TOP_MODULE)
  target_compile_options(${TARGET} PRIVATE --prefix ${TOP_MODULE})

  # Get definitions
  get_target_property(COMPILE_DEFS ${TARGET} COMPILE_DEFINITIONS)
  foreach(COMPILE_DEF ${COMPILE_DEFS})
    list(APPEND COMPILE_DEF_FLAGS "SHELL:-CFLAGS -D${COMPILE_DEF}")
  endforeach()

  # Get include paths
  get_target_property(INCLUDE_DIRS ${TARGET} INCLUDE_DIRECTORIES)
  foreach(INCLUDE_DIR ${INCLUDE_DIRS})
    list(APPEND INCLUDE_DIR_FLAGS "SHELL:-CFLAGS -I${INCLUDE_DIR}")
  endforeach()
  list(APPEND INCLUDE_DIR_FLAGS "SHELL:-CFLAGS -I$<TARGET_OBJECTS:${TARGET}>")

  target_compile_options(${TARGET} PRIVATE ${COMPILE_DEF_FLAGS} ${INCLUDE_DIR_FLAGS})

  add_custom_command(
    TARGET ${TARGET}
    PRE_LINK
    COMMAND +make -C $<TARGET_OBJECTS:${TARGET}> -f ${TOP_MODULE}.mk VM_PARALLEL_BUILDS=1
    COMMAND cp $<TARGET_OBJECTS:${TARGET}>/${TOP_MODULE} $<TARGET_OBJECTS:${TARGET}>/vsim
  )
endfunction()

# ------------------------------------------------------------------------
# vlink_library
# ------------------------------------------------------------------------
# "Link" a library to the Verilated executable

function(vlink_library TARGET LIBRARY)
  add_dependencies(${TARGET} ${LIBRARY})
  target_compile_options(${TARGET} PRIVATE "$<TARGET_FILE:${LIBRARY}>")
endfunction()

# ------------------------------------------------------------------------
# vadd_source
# ------------------------------------------------------------------------
# "Link" a library to the Verilated executable

function(vadd_source TARGET SOURCE)
  get_target_property(TARGET_SOURCE ${TARGET} SOURCE)
  set_property(SOURCE ${TARGET_SOURCE} APPEND PROPERTY OBJECT_DEPENDS ${SOURCE})
  target_compile_options(${TARGET} PRIVATE "${SOURCE}")
endfunction()