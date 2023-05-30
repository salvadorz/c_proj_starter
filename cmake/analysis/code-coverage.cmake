#******************************************************************************
#*Copyright (C) 2023 by Salvador Z                                            *
#*                                                                            *
#*****************************************************************************/
#*
#*@author Salvador Z
#*@brief CMakeLists file to configure the code coverage by using gcov
#*

########################
# Code-coverage Module #
########################
# This module add one target to your build: test-coverage
#
# The main functionality of this module is to provide a convenient way to perform code coverage informationa 
# to be able to perform test-coverage using gcov as analysis tool.
# It introduces one targets:
#   - "test-coverage" target: Add the needed flags to generate coverage information at compile time instrumenting the code
#
# You can control the behavior of code-coverage by setting the following variables
# before including this module:
#   - CODE_COVERAGE_EXCLUDE_DIRS: A CMake list of directories to exclude from coverage analysis.
#     By default, no directories are excluded.
#   - CODE_COVERAGE_INCLUDE_DIRS: A CMake list of directories to include in coverage analysis.
#     By default, the "src" directory is included.
#   - CODE_COVERAGE_FILETYPES: A CMake list of file types to include in coverage analysis,
#     specified as globs (e.g., "*.cc").
#     By default, the module covers *.c, and *.cpp files.
#
# You can override the default values by setting the variables mentioned above.
# If you want to use the default values for CODE_COVERAGE_INCLUDE_DIRS and CODE_COVERAGE_FILETYPES
# but add additional directories or files, you can set these variables:
#   - CODE_COVERAGE_ADDITIONAL_DIRS
#   - CODE_COVERAGE_ADDITIONAL_FILETYPES

# Code Coverage Configuration
if(ENABLE_CODEGCOV)
  find_program( GCOV_BIN gcov )
endif()

# Add any additional directory to include in the code coverage analysis
set(CODE_COVERAGE_ADDITIONAL_DIRS tests )
# Add any additional source filetype to include in the analysis
#set(CODE_COVERAGE_ADDITIONAL_FILETYPES "*.cc")

# NOTE: Coverage only works/makes sense with debug builds
# set(CMAKE_BUILD_TYPE "Debug")

#set(C_COVERAGE_FLAGS "-g --coverage"
  #   CACHE INTERNAL "")

set(C_COVERAGE_FLAGS "-g -fprofile-arcs -ftest-coverage")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${C_COVERAGE_FLAGS}")

if(GCOV_BIN)
  ### Supply argument defaults
  if(NOT CODE_COVERAGE_EXCLUDE_DIRS)
    set(CODE_COVERAGE_EXCLUDE_DIRS "src/app")
  endif()

  if(NOT CODE_COVERAGE_INCLUDE_DIRS)
    set(CODE_COVERAGE_INCLUDE_DIRS src CACHE STRING "CMake list of directories to format using clang-format.")
  endif()

  if(NOT CODE_COVERAGE_FILETYPES)
    set(CODE_COVERAGE_FILETYPES "*.c" "*.cpp" CACHE STRING "CMake list of file types to format using clang-format.")
  endif()

  if(CODE_COVERAGE_ADDITIONAL_DIRS)
    list(APPEND CODE_COVERAGE_INCLUDE_DIRS ${CODE_COVERAGE_ADDITIONAL_DIRS})
  endif()

  if(CODE_COVERAGE_ADDITIONAL_FILETYPES)
    list(APPEND CODE_COVERAGE_FILETYPES ${CODE_COVERAGE_ADDITIONAL_FILETYPES})
  endif()

  ### Convert variables into script format
  if(CODE_COVERAGE_EXCLUDE_DIRS)
    string(REPLACE ";" "," CODE_COVERAGE_EXCLUDE_ARG "${CODE_COVERAGE_EXCLUDE_DIRS}")
    set(CODE_COVERAGE_EXCLUDE_ARG "-e ${CODE_COVERAGE_EXCLUDE_ARG}")
  else()
    set(CODE_COVERAGE_EXCLUDE_ARG "")
  endif()

  string(REPLACE ";" "," CODE_COVERAGE_INCLUDE_ARG "${CODE_COVERAGE_INCLUDE_DIRS}")
  string(REPLACE ";" "," CODE_COVERAGE_FILETYPES_ARG "${CODE_COVERAGE_FILETYPES}")

  set(code_coverage_args
    ${CODE_COVERAGE_EXCLUDE_ARG}
    ${CODE_COVERAGE_INCLUDE_ARG}
    ${CODE_COVERAGE_FILETYPES_ARG}
  )
  message(STATUS " code_coverage args: ${code_coverage_args}")

  add_custom_target(test-gcov
    COMMENT "Run test coverage for all sources except for tests"
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/test_coverage.sh
      # Common args
      ${code_coverage_args}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
else()
  message(SEND_ERROR "gcov utility is not installed!")
endif()
