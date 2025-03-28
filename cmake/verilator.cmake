# ========================================================================
# verilator.cmake
# ========================================================================
# Utility functions for using Verilator as a Verilog compiler
#
# Inspired by the `verilate` command here:
#  - https://github.com/verilator/verilator/blob/master/verilator-config.cmake.in

cmake_minimum_required(VERSION 3.20)

find_program(
  VERILATOR_BIN
  NAMES verilator_bin verilator_bin.exe
)
if(VERILATOR_BIN)
  message(STATUS "Found Verilator: ${VERILATOR_BIN}")
elseif(NOT VERILATOR_BIN)
  message(FATAL_ERROR "Cannot find verilator_bin executable.")
endif()

cmake_path(GET VERILATOR_BIN PARENT_PATH VERILATOR_BIN_DIR)
cmake_path(GET VERILATOR_BIN_DIR PARENT_PATH VERILATOR_ROOT)
set(VERILATOR_INCLUDE "${VERILATOR_ROOT}/share/verilator/include")

include(CheckCXXSourceCompiles)
function(_verilator_check_cxx_libraries LIBRARIES RESVAR)
  # Check whether a particular link option creates a valid executable
  set(_VERILATOR_CHECK_CXX_LINK_OPTIONS_SRC "int main() {return 0;}\n")
  set(CMAKE_REQUIRED_FLAGS)
  set(CMAKE_REQUIRED_DEFINITIONS)
  set(CMAKE_REQUIRED_INCLUDES)
  set(CMAKE_REQUIRED_LINK_OPTIONS)
  set(CMAKE_REQUIRED_LIBRARIES ${LIBRARIES})
  set(CMAKE_REQUIRED_QUIET)
  check_cxx_source_compiles(
    "${_VERILATOR_CHECK_CXX_LINK_OPTIONS_SRC}"
    "${RESVAR}"
  )
  set("${RESVAR}" "${${RESVAR}}" PARENT_SCOPE)
endfunction()

# Check compiler flag support. Skip on MSVC, these are all GCC flags.
if(NOT CMAKE_CXX_COMPILER_ID MATCHES MSVC)
  if(NOT DEFINED VERILATOR_CFLAGS OR NOT DEFINED VERILATOR_MT_CFLAGS)
    include(CheckCXXCompilerFlag)
    foreach(FLAG @CFG_CXX_FLAGS_CMAKE@)
      string(MAKE_C_IDENTIFIER ${FLAG} FLAGNAME)
      check_cxx_compiler_flag(${FLAG} ${FLAGNAME})
      if(${FLAGNAME})
        list(APPEND VERILATOR_CFLAGS ${FLAG})
      endif()
    endforeach()
    foreach(FLAG @CFG_LDFLAGS_THREADS_CMAKE@)
      string(MAKE_C_IDENTIFIER ${FLAG} FLAGNAME)
      _verilator_check_cxx_libraries("${FLAG}" ${FLAGNAME})
      if(${FLAGNAME})
        list(APPEND VERILATOR_MT_CFLAGS ${FLAG})
      endif()
    endforeach()
  endif()
endif()

# ------------------------------------------------------------------------
# verilator_target
# ------------------------------------------------------------------------
# Add flags to a pre-defined target for use with Verilator
#
# Verilator is used at "linking", so all of these will be "link flags"

function(verilator_target TARGET)
  cmake_parse_arguments(
    VERILATOR
    "COVERAGE;TRACE;TRACE_FST;TRACE_STRUCTS;TIMING"
    ""
    "DEFINES;VERILATOR_ARGS"
    ${ARGN}
  )

  set(VERILATOR_ARGS ${VERILATOR_VERILATOR_ARGS})
  target_link_options(${TARGET} PRIVATE --binary)

  if(VERILATOR_COVERAGE)
    target_link_options(${TARGET} PRIVATE --coverage)
  endif()

  if(VERILATOR_TRACE AND VERILATOR_TRACE_FST)
    message(FATAL_ERROR "Cannot have both TRACE and TRACE_FST")
  endif()

  if(VERILATOR_TRACE)
    target_link_options(${TARGET} PRIVATE --trace)
  endif()

  if(VERILATOR_TRACE_FST)
    target_link_options(${TARGET} PRIVATE --trace-fst)
  endif()

  if(VERILATOR_TRACE_STRUCTS)
    target_link_options(${TARGET} PRIVATE --trace-structs)
  endif()

  foreach(DEF ${VERILATOR_DEFINES})
    target_link_options(${TARGET} PRIVATE "-D${DEF}")
  endforeach()

  set(TIMING_FLAG "")
  if(VERILATOR_TIMING)
    list(APPEND VERILATOR_ARGS --timing)
    check_cxx_compiler_flag(-fcoroutines-ts COROUTINES_TS_FLAG)
    set(TIMING_FLAG $<IF:$<BOOL:${COROUTINES_TS_FLAG}>,-fcoroutines-ts,-fcoroutines>)
  endif()

  get_target_property(BINARY_DIR "${TARGET}" BINARY_DIR)
  get_target_property(TARGET_NAME "${TARGET}" NAME)
  set(VDIR
    "${BINARY_DIR}/CMakeFiles/${TARGET_NAME}.dir/V${TARGET_NAME}.dir"
  )
  target_link_options(${TARGET} PRIVATE --Mdir ${VDIR})
  target_link_options(${TARGET} PRIVATE --prefix ${TARGET_NAME})
  target_include_directories(
    ${TARGET}
    PUBLIC
    "${VERILATOR_INCLUDE}" "${VERILATOR_INCLUDE}/vltstd"
    ${VDIR}
  )
  set_target_properties(${TARGET} PROPERTIES LINKER_LANGUAGE Verilog)
endfunction()