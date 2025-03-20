# ========================================================================
# CMakeLists.txt
# ========================================================================
# Building RISCV binaries for use in Blimp

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/rv32.cmake)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

#-------------------------------------------------------------------------
# Set all of the application files
#-------------------------------------------------------------------------

set(APP_FILES
  hello/hello.cpp
)

#-------------------------------------------------------------------------
# Set the libraries
#-------------------------------------------------------------------------

set(UTIL_FILES
  utils/blimp_wprintf.cpp
)

#-------------------------------------------------------------------------
# Build the libraries
#-------------------------------------------------------------------------

add_library(UTILS STATIC ${UTIL_FILES})

#-------------------------------------------------------------------------
# Make targets
#-------------------------------------------------------------------------

set(APP_FILE_PATHS "")

foreach(APP_FILE_REL_PATH ${APP_FILES})
  set(APP_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${APP_FILE_REL_PATH}")
  get_leaf(APP_FILE ${APP_FILE_PATH})
  remove_extension(APP_BIN ${APP_FILE})

  add_executable(app-${APP_BIN} ${APP_FILE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/scripts/crt0.S)
  set_target_properties(app-${APP_BIN} PROPERTIES OUTPUT_NAME ${APP_BIN})
  target_link_libraries(app-${APP_BIN} PRIVATE UTILS)

  set(APP_FILE_PATHS ${APP_FILE_PATHS} ${APP_FILE_PATH})
endforeach(APP_FILE_REL_PATH)

#-------------------------------------------------------------------------
# Give parent our source files for native builds
#-------------------------------------------------------------------------

set(APP_FILES ${APP_FILES} PARENT_SCOPE)
set(SRC_FILES ${UTIL_FILES} PARENT_SCOPE)
