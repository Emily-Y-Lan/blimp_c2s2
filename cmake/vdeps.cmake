# ========================================================================
# vdeps.cmake
# ========================================================================
# A function to find the Verilog dependencies of a source file
#
# Author: Aidan McNay
# Date: March 27th, 2025

cmake_minimum_required(VERSION 3.19)

function(vdeps DEPENDENCIES)
  cmake_parse_arguments(
    VDEP
    ""
    ""
    "SOURCES;INCLUDE_DIRS"
    ${ARGN}
  )
  set(FILES_TO_CHECK ${VDEP_SOURCES})
  set(VDEPENDENCIES ${VDEP_SOURCES})

  # Continue until no more files to check
  while(FILES_TO_CHECK)
    set(CURR_FILES_TO_CHECK ${FILES_TO_CHECK})
    set(FILES_TO_CHECK "")

    # Check all files for dependencies
    foreach(FILE_TO_CHECK ${CURR_FILES_TO_CHECK})
      # Get contents as a list
      unset(FILE_PATH)
      find_file(
        FILE_PATH 
        NAMES ${FILE_TO_CHECK}
        PATHS ${VDEP_INCLUDE_DIRS}
        NO_DEFAULT_PATH
        NO_CACHE
      )
      if(${FILE_PATH} STREQUAL "FILE_PATH-NOTFOUND")
        message(FATAL_ERROR "Couldn't find file '${FILE_TO_CHECK}' (searched ${VDEP_INCLUDE_DIRS})")
      endif()
      file(READ ${FILE_PATH} FILE_CONTENTS)
      string(REPLACE "\n" ";" FILE_CONTENTS ${FILE_CONTENTS})

      # Find all `include lines
      foreach(FILE_LINE ${FILE_CONTENTS})
        string(REGEX MATCHALL "^[^\\/]*`include[ \\t\\r\\n\\f]*(\"(.+)\"|'(.+)')[ \\t\\r\\n\\f]*$" INCL_MATCHES ${FILE_LINE})
        if(NOT ${CMAKE_MATCH_2} IN_LIST DEPENDENCIES)
          set(FILES_TO_CHECK "${CMAKE_MATCH_2}" ${FILES_TO_CHECK})
          set(VDEPENDENCIES "${CMAKE_MATCH_2}" ${VDEPENDENCIES})
        endif()
      endforeach(FILE_LINE)
    endforeach(FILE_TO_CHECK)
  endwhile()

  set(${DEPENDENCIES} ${VDEPENDENCIES} PARENT_SCOPE)
endfunction()