# ========================================================================
# CMakeLists.txt
# ========================================================================
# Building RISCV binaries for use in Blimp

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/rv32.cmake)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)

#-------------------------------------------------------------------------
# Set all of the application files
#-------------------------------------------------------------------------

set(APP_FILES
  test.cpp
)

#-------------------------------------------------------------------------
# Make targets
#-------------------------------------------------------------------------

foreach(APP_FILE_REL_PATH ${APP_FILES})
  set(APP_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${APP_FILE_REL_PATH}")
  get_leaf(APP_FILE ${APP_FILE_PATH})
  remove_extension(APP_BIN ${APP_FILE})

  add_executable(${APP_BIN}.elf ${APP_FILE_PATH})
endforeach(APP_FILE_REL_PATH)
