# ========================================================================
# CMakeLists.txt
# ========================================================================
# A build system for Blimp

#-------------------------------------------------------------------------
# Get all of the test files
#-------------------------------------------------------------------------

set(V_TEST_FILES
  hw/common/test/Fifo_test.v
  hw/common/test/PriorityEncoder_test.v
  hw/common/test/RRArb_test.v
  hw/decode_issue/test/DecodeIssueUnitL1_test.v
  hw/decode_issue/test/DecodeIssueUnitL2_test.v
  hw/decode_issue/test/DecodeIssueUnitL3_test.v
  hw/decode_issue/test/ImmGen_test.v
  hw/decode_issue/test/RegfilePending_test.v
  hw/decode_issue/test/RenameTable_test.v
  hw/execute/test/l1/ALU_test.v
  hw/execute/test/l1/Multiplier_test.v
  hw/execute/test/l2/PipelinedMultiplier_test.v
  hw/execute/test/l3/LoadStoreUnit_test.v
  hw/fetch/test/FetchUnitL1_test.v
  hw/fetch/test/FetchUnitL2_test.v
  hw/fetch/test/FetchUnitL3_test.v
  hw/fetch/test/SeqNumGenL2_test.v
  hw/fetch/test/SeqNumGenL3_test.v
  hw/top/test/BlimpV1_test.v
  hw/top/test/BlimpV2_test.v
  hw/top/test/BlimpV3_test.v
  hw/top/test/BlimpV4_test.v
  hw/top/test/FLProc_test.v
  hw/util/test/SeqAge_test.v
  hw/writeback_commit/test/WritebackCommitUnitL1_test.v
  hw/writeback_commit/test/WritebackCommitUnitL2_test.v
  hw/writeback_commit/test/WritebackCommitUnitL3_test.v
  hw/writeback_commit/test/ROB_test.v
)

set(ASM_FILES
  asm/assemble.cpp
  asm/disassemble.cpp
  asm/inst.cpp
  asm/fields.cpp
)

set(FL_PROC_FILES
  fl/FLInst.cpp
  fl/FLMem.cpp
  fl/FLProc.cpp
  fl/FLRegfile.cpp
  fl/FLTrace.cpp
  fl/fl_vtrace.cpp
)

#-------------------------------------------------------------------------
# Boilerplate
#-------------------------------------------------------------------------

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

cmake_minimum_required(VERSION 3.10)
project(
  BLIMP 
  VERSION 1.0
  DESCRIPTION "BLIMP: BRG's Luculently-Interfaced Modular Processor"
)

enable_testing()
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_compile_options(-g)

#------------------------------------------------------------------------
# Import Verilator
#------------------------------------------------------------------------

find_package(verilator REQUIRED)

#-------------------------------------------------------------------------
# get_leaf
#-------------------------------------------------------------------------
# Gets the leaf file of a path.

function(get_leaf VARNAME FILE_NAME)
  string(REGEX REPLACE "[^/]*/" "" NAME_WITHOUT_EXT ${FILE_NAME})
  set(${VARNAME} "${NAME_WITHOUT_EXT}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------
# remove_extension
#------------------------------------------------------------------------
# A function to remove a file's extension

function(remove_extension VARNAME FILE_NAME)
  string(REGEX REPLACE "\\.[^.]*$" "" NAME_WITHOUT_EXT ${FILE_NAME})
  set(${VARNAME} "${NAME_WITHOUT_EXT}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------
# ASM Library
#------------------------------------------------------------------------

add_library(ASM STATIC ${ASM_FILES})
target_compile_options(ASM PRIVATE -Wall -Wextra -Wpedantic -Werror)

#------------------------------------------------------------------------
# FL_PROC Library
#------------------------------------------------------------------------

add_library(FL_PROC STATIC ${FL_PROC_FILES})
target_link_libraries(FL_PROC PRIVATE ASM)
target_compile_options(FL_PROC PRIVATE -Wall -Wextra -Wpedantic -Werror)

#------------------------------------------------------------------------
# Add our SystemVerilog tests
#------------------------------------------------------------------------

add_custom_target(check COMMAND "ctest" "--timeout" "10")

foreach(V_TEST_FILE_REL_PATH ${V_TEST_FILES})
  set(V_TEST_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${V_TEST_FILE_REL_PATH}")
  get_leaf(V_TEST_FILE ${V_TEST_FILE_PATH})
  remove_extension(V_TEST_BIN ${V_TEST_FILE})

  add_executable(${V_TEST_BIN} "${CMAKE_CURRENT_SOURCE_DIR}/test/sim.cpp")
  target_link_libraries(${V_TEST_BIN} PRIVATE ASM FL_PROC) 
  set(CMAKE_VTESTS ${CMAKE_VTESTS} ${V_TEST_BIN})

  target_compile_definitions(${V_TEST_BIN} PRIVATE 
    VERILATOR_INCL_HEADER="V${V_TEST_BIN}.h"
    VERILATOR_DPI_HEADER="V${V_TEST_BIN}__Dpi.h"
    VERILATOR_TOP_MODULE=V${V_TEST_BIN}
  )
  verilate(
    ${V_TEST_BIN} 
    SOURCES ${V_TEST_FILE_PATH} 
    TRACE
    TRACE_STRUCTS
    VERILATOR_ARGS --timing --flatten --quiet-stats
  )

  add_dependencies(check ${V_TEST_BIN})
  file(RELATIVE_PATH TEST_PATH ${CMAKE_CURRENT_SOURCE_DIR} ${V_TEST_FILE_PATH})
  remove_extension(TEST_NAME ${TEST_PATH})
  add_test(NAME ${TEST_NAME} COMMAND ${V_TEST_BIN})
endforeach(V_TEST_FILE_REL_PATH)

#------------------------------------------------------------------------
# List tests
#------------------------------------------------------------------------

set(KNOWN_TESTS_TEXT "Available test targets:")
foreach(VTEST ${CMAKE_VTESTS})
  set(KNOWN_TESTS_TEXT "${KNOWN_TESTS_TEXT}" " - ${VTEST}")
endforeach(VTEST)

add_custom_target(
  list
  COMMAND echo ${KNOWN_TESTS_TEXT}
  VERBATIM
)