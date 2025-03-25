# ========================================================================
# CMakeLists.txt
# ========================================================================
# Building RISCV binaries for use in Blimp

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/rv32.cmake)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

#-------------------------------------------------------------------------
# Set all of the directories to look in
#-------------------------------------------------------------------------

set(APP_SUBDIRS
  hello
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

set(ALL_APP_FILES)
set(ALL_SRC_FILES)

foreach(APP_SUBDIR ${APP_SUBDIRS})
  add_subdirectory(${APP_SUBDIR} "${CMAKE_CURRENT_BINARY_DIR}/${APP_SUBDIR}_cmake")
  add_prefix(SRC_FILES "${APP_SUBDIR}/")
  add_prefix(APP_FILES "${APP_SUBDIR}/")

  set(ALL_APP_FILES ${ALL_APP_FILES} ${APP_FILES})
  set(ALL_SRC_FILES ${ALL_SRC_FILES} ${SRC_FILES})

  set(ABSOLUTE_SRC_FILES ${SRC_FILES})
  add_prefix(ABSOLUTE_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/")
  
  foreach(APP_FILE_REL_PATH ${APP_FILES})
    set(APP_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${APP_FILE_REL_PATH}")
    get_leaf(APP_FILE ${APP_FILE_PATH})
    remove_extension(APP_BIN ${APP_FILE})
  
    add_executable(app-${APP_BIN} ${APP_FILE_PATH} ${ABSOLUTE_SRC_FILES} ${CMAKE_CURRENT_SOURCE_DIR}/scripts/crt0.S)
    set_target_properties(app-${APP_BIN} PROPERTIES OUTPUT_NAME ${APP_BIN})
    target_link_libraries(app-${APP_BIN} PRIVATE UTILS)
  endforeach(APP_FILE_REL_PATH)
endforeach(APP_SUBDIR)

#-------------------------------------------------------------------------
# Give parent our source files for native builds
#-------------------------------------------------------------------------

set(APP_FILES ${ALL_APP_FILES} PARENT_SCOPE)
set(SRC_FILES ${ALL_SRC_FILES} ${UTIL_FILES} PARENT_SCOPE)
