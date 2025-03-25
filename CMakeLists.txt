# ========================================================================
# CMakeLists.txt
# ========================================================================
# A build system for Blimp

#-------------------------------------------------------------------------
# Get all of the source files
#-------------------------------------------------------------------------

set(V_TEST_FILES
  hw/common/test/Fifo_test.v
  hw/common/test/PriorityEncoder_test.v
  hw/common/test/RRArb_test.v
  hw/decode_issue/test/DecodeIssueUnitL1_test.v
  hw/decode_issue/test/DecodeIssueUnitL2_test.v
  hw/decode_issue/test/DecodeIssueUnitL3_test.v
  hw/decode_issue/test/DecodeIssueUnitL4_test.v
  hw/decode_issue/test/DecodeIssueUnitL5_test.v
  hw/decode_issue/test/ImmGen_test.v
  hw/decode_issue/test/RegfilePending_test.v
  hw/decode_issue/test/RenameTable_test.v
  hw/execute/test/l1/ALUL1_test.v
  hw/execute/test/l1/MultiplierL1_test.v
  hw/execute/test/l2/PipelinedMultiplierL2_test.v
  hw/execute/test/l3/LoadStoreUnitL3_test.v
  hw/execute/test/l4/ControlFlowUnitL4_test.v
  hw/execute/test/l5/ControlFlowUnitL5_test.v
  hw/execute/test/l6/ALUL6_test.v
  hw/execute/test/l6/ControlFlowUnitL6_test.v
  hw/fetch/test/FetchUnitL1_test.v
  hw/fetch/test/FetchUnitL2_test.v
  hw/fetch/test/FetchUnitL3_test.v
  hw/fetch/test/SeqNumGenL2_test.v
  hw/fetch/test/SeqNumGenL3_test.v
  hw/squash/test/SquashUnitL1_test.v
  hw/squash/test/SquashUnitL1Chain_test.v
  hw/top/test/BlimpV1_test.v
  hw/top/test/BlimpV2_test.v
  hw/top/test/BlimpV3_test.v
  hw/top/test/BlimpV4_test.v
  hw/top/test/BlimpV5_test.v
  hw/top/test/BlimpV6_test.v
  hw/top/test/BlimpV7_test.v
  hw/top/test/FLProc_test.v
  hw/util/test/SeqAge_test.v
  hw/writeback_commit/test/WritebackCommitUnitL1_test.v
  hw/writeback_commit/test/WritebackCommitUnitL2_test.v
  hw/writeback_commit/test/WritebackCommitUnitL3_test.v
  hw/writeback_commit/test/ROB_test.v
)

set(V_SIM_FILES
  hw/top/sim/BlimpV7_sim.v
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
  fl/FLPeripheral.cpp
  fl/FLProc.cpp
  fl/FLRegfile.cpp
  fl/FLTrace.cpp
  fl/fl_vtrace.cpp
  fl/fl_peripherals.cpp
  fl/parse_elf.cpp

  fl/peripherals/FLExit.cpp
  fl/peripherals/FLTerminal.cpp
)

set(APP_SUBDIRS
  app
)

#-------------------------------------------------------------------------
# Verilator Flags
#-------------------------------------------------------------------------
# Used for fast compilation
#
# Source: https://github.com/pymtl/pymtl3/blob/eea5ff49e06b303123097dc4d9e163790c0f58d6/pymtl3/passes/backends/verilog/import_/VerilogVerilatorImportConfigs.py

set(OPT_FAST_FLAGS
  -O1
  -fno-guess-branch-probability
  -fno-reorder-blocks
  -fno-if-conversion
  -fno-if-conversion2
  -fno-dce
  -fno-delayed-branch
  -fno-dse
  -fno-auto-inc-dec
  -fno-branch-count-reg
  -fno-combine-stack-adjustments
  -fno-cprop-registers
  -fno-forward-propagate
  -fno-inline-functions-called-once
  -fno-ipa-profile
  -fno-ipa-pure-const
  -fno-ipa-reference
  -fno-move-loop-invariants
  -fno-omit-frame-pointer
  -fno-split-wide-types
  -fno-tree-bit-ccp
  -fno-tree-ccp
  -fno-tree-ch
  -fno-tree-coalesce-vars
  -fno-tree-copy-prop
  -fno-tree-dce
  -fno-tree-dominator-opts
  -fno-tree-dse
  -fno-tree-fre
  -fno-tree-phiprop
  -fno-tree-pta
  -fno-tree-scev-cprop
  -fno-tree-sink
  -fno-tree-slsr
  -fno-tree-sra
  -fno-tree-ter
  -fno-tree-reassoc
)

set(OPT_SLOW_FLAGS
  -O0
  -fno-guess-branch-probability
  -fno-reorder-blocks
  -fno-if-conversion
  -fno-if-conversion2
  -fno-dce
  -fno-delayed-branch
  -fno-dse
  -fno-auto-inc-dec
  -fno-branch-count-reg
  -fno-combine-stack-adjustments
  -fno-cprop-registers
  -fno-forward-propagate
  -fno-inline-functions-called-once
  -fno-ipa-profile
  -fno-ipa-pure-const
  -fno-ipa-reference
  -fno-move-loop-invariants
  -fno-omit-frame-pointer
  -fno-split-wide-types
  -fno-tree-bit-ccp
  -fno-tree-ccp
  -fno-tree-ch
  -fno-tree-coalesce-vars
  -fno-tree-copy-prop
  -fno-tree-dce
  -fno-tree-dominator-opts
  -fno-tree-dse
  -fno-tree-fre
  -fno-tree-phiprop
  -fno-tree-pta
  -fno-tree-scev-cprop
  -fno-tree-sink
  -fno-tree-slsr
  -fno-tree-sra
  -fno-tree-ter
  -fno-tree-reassoc
)

#-------------------------------------------------------------------------
# Tracing
#-------------------------------------------------------------------------
# Disable by default for speed

if(NOT DEFINED TRACE)
set(TRACE 0)
endif()

if(TRACE)
  set(VTRACE TRACE TRACE_STRUCTS)
else()
  set(VTRACE "")
endif()

#-------------------------------------------------------------------------
# Set the compiler
#-------------------------------------------------------------------------
# Use clang if available, then gcc if not

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

#-------------------------------------------------------------------------
# Boilerplate
#-------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.10)
project(
  BLIMP 
  VERSION 1.0
  DESCRIPTION "BLIMP: BRG's Luculently-Interfaced Modular Processor"
  LANGUAGES C CXX ASM
)

enable_testing()
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

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
# sim_name
#------------------------------------------------------------------------
# A function to convert a simulation Verilog file name to an executable
# name

function(sim_name SIMNAME FILE_NAME)
  string(REGEX MATCH "BlimpV([0-9]+)_sim\\.v" FILE_NAME ${FILE_NAME})
  message("File Name: ${FILE_NAME}")
  set(${SIMNAME} "v${CMAKE_MATCH_1}-sim" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------
# add_prefix
#------------------------------------------------------------------------
# A function to add a prefix to all elements of a list

function(add_prefix LIST_VAR PREFIX)
  set(NEW_LIST_VAR "")
  foreach(ITEM ${${LIST_VAR}})
    list(APPEND NEW_LIST_VAR "${PREFIX}${ITEM}")
  endforeach(ITEM)
  set(${LIST_VAR} ${NEW_LIST_VAR} PARENT_SCOPE)
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

add_custom_target(check COMMAND "ctest" "--timeout" "20")

foreach(V_TEST_FILE_REL_PATH ${V_TEST_FILES})
  set(V_TEST_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${V_TEST_FILE_REL_PATH}")
  get_leaf(V_TEST_FILE ${V_TEST_FILE_PATH})
  remove_extension(V_TEST_BIN ${V_TEST_FILE})

  add_executable(${V_TEST_BIN} "${CMAKE_CURRENT_SOURCE_DIR}/test/sim.cpp")
  target_link_libraries(${V_TEST_BIN} PRIVATE ASM FL_PROC) 
  set(CMAKE_VTESTS ${CMAKE_VTESTS} ${V_TEST_BIN})

  target_compile_definitions(${V_TEST_BIN} PRIVATE 
    VERILATOR_INCL_HEADER="V${V_TEST_BIN}.h"
    VERILATOR_TOP_MODULE=V${V_TEST_BIN}
    VL_USER_FINISH
    VL_USER_FATAL
  )
  verilate(
    ${V_TEST_BIN} 
    SOURCES ${V_TEST_FILE_PATH} 
    ${VTRACE}
    # OPT_FAST ${OPT_FAST_FLAGS}
    # OPT_SLOW ${OPT_SLOW_FLAGS}
    VERILATOR_ARGS --timing --quiet-stats -DVL_USER_FINISH -DVL_USER_FATAL
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
set(LIST_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "Available test targets:")
foreach(VTEST ${CMAKE_VTESTS})
  set(LIST_COMMANDS ${LIST_COMMANDS} COMMAND ${CMAKE_COMMAND} -E echo " - ${VTEST}")
endforeach(VTEST)

add_custom_target(
  list
  ${LIST_COMMANDS}
  COMMENT ${KNOWN_TEST_TEXT}
)

#------------------------------------------------------------------------
# Add our SystemVerilog simulations
#------------------------------------------------------------------------

foreach(V_SIM_FILE_REL_PATH ${V_SIM_FILES})
  set(V_SIM_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${V_SIM_FILE_REL_PATH}")
  get_leaf(V_SIM_FILE ${V_SIM_FILE_PATH})
  remove_extension(V_SIM_FILE_STUB ${V_SIM_FILE})
  sim_name(V_SIM_BIN ${V_SIM_FILE})

  add_executable(${V_SIM_BIN} "${CMAKE_CURRENT_SOURCE_DIR}/hw/top/sim/utils/proc_sim.cpp")
  target_link_libraries(${V_SIM_BIN} PRIVATE ASM FL_PROC) 

  target_compile_definitions(${V_SIM_BIN} PRIVATE 
    VERILATOR_INCL_HEADER="V${V_SIM_FILE_STUB}.h"
    VERILATOR_DPI_HEADER="V${V_SIM_FILE_STUB}__Dpi.h"
    VERILATOR_TOP_MODULE=V${V_SIM_FILE_STUB}
    VERILATOR_MODULE_NAME=${V_SIM_FILE_STUB}
  )
  verilate(
    ${V_SIM_BIN} 
    SOURCES ${V_SIM_FILE_PATH} 
    ${VTRACE}
    # OPT_FAST ${OPT_FAST_FLAGS}
    # OPT_SLOW ${OPT_SLOW_FLAGS}
    VERILATOR_ARGS --timing --quiet-stats
  )
endforeach(V_SIM_FILE_REL_PATH)

#------------------------------------------------------------------------
# Include RISCV programs
#------------------------------------------------------------------------

foreach(APP_SUBDIR ${APP_SUBDIRS})
  set(APP_FILES "")
  set(SRC_FILES "")
  add_subdirectory(app)
  add_prefix(SRC_FILES ${CMAKE_CURRENT_SOURCE_DIR}/${APP_SUBDIR}/)
  add_prefix(APP_FILES ${CMAKE_CURRENT_SOURCE_DIR}/${APP_SUBDIR}/)

  # Include native builds for all apps
  foreach(APP_FILE_PATH ${APP_FILES})
    get_leaf(APP_FILE ${APP_FILE_PATH})
    remove_extension(APP_BIN ${APP_FILE})
    add_executable(app-${APP_BIN}-native ${APP_FILE_PATH} ${SRC_FILES})
    target_compile_options(app-${APP_BIN}-native PRIVATE -Wall -Wextra -Wpedantic -Werror)
    target_include_directories(app-${APP_BIN}-native PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${APP_SUBDIR})
    set_target_properties(app-${APP_BIN}-native PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${APP_SUBDIR}"
      OUTPUT_NAME ${APP_BIN}-native
    )
  endforeach(APP_FILE_PATH)
endforeach(APP_SUBDIR)

#-------------------------------------------------------------------------
# Include FL Simulator
#-------------------------------------------------------------------------

add_executable(fl-sim fl/fl_sim.cpp)
target_compile_options(fl-sim PRIVATE -Wall -Wextra -Wpedantic -Werror)
target_link_libraries(fl-sim PRIVATE FL_PROC)