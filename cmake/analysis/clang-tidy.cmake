#******************************************************************************
#*Copyright (C) 2023 by Salvador Z                                            *
#*                                                                            *
#*****************************************************************************/
#*
#*@author Salvador Z
#*@brief CMakeLists file to configure the clang-tidy static analysis
#*

#####################
# Clang-tidy Module #
#####################
# This module adds one target to your build: static-tidy
#
# The main functionality of this module is to provide a convenient way to analyze your source code using clang-tidy.
# It introduces one target:
#   - "static-tidy" target: Analyze the source code files in the specified directories according to clang-tidy rules.
#
# You can control the behavior of clang-tidy by setting the following variables
# before including this module:
#   - CLANG_TIDY_INCLUDE_DIRS: A CMake list of directories to include in formatting.
#     By default, the "src" directory is included.
#   - CLANG_TIDY_FILETYPES: A CMake list of file types to include in formatting,
#     specified as globs (e.g., "*.c").
#     By default, the module formats *.c and *.cpp files.
#
# You can override the default values by setting the variables mentioned above.
# If you want to use the default values for CLANG_TIDY_INCLUDE_DIRS and CLANG_TIDY_FILETYPES
# but add additional directories or files, you can set these variables:
#   - CLANG_TIDY_ADDITIONAL_DIRS
#   - CLANG_TIDY_ADDITIONAL_FILETYPES
# To enable clang-tidy output during the build process, set the `BUILD_WITH_CLANG_TIDY_ANALYSIS`
# option to "ON".
#
# If you want to provide extra arguments to clang-tidy, you can populate the
# CLANG_TIDY_ADDITIONAL_OPTIONS variable. It should be a CMake list consisting of 
# flags and corresponding values. These options will be passed directly to the clang-tidy command.
#   Example:
#     set(CLANG_TIDY_ADDITIONAL_OPTIONS --fix)

find_program(CLANG_TIDY clang-tidy)

if(CLANG_TIDY)
  option(BUILD_WITH_CLANG_TIDY_ANALYSIS
    "Compile the project with clang-tidy support"
    ON)

  if(BUILD_WITH_CLANG_TIDY_ANALYSIS)
    set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY})
    set(CLANG_TIDY_ADDITIONAL_OPTIONS --fix)
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY})
  endif()

  ### Supply argument defaults
  if(NOT CLANG_TIDY_INCLUDE_DIRS)
    set(CLANG_TIDY_INCLUDE_DIRS src tests CACHE STRING "CMake list of directories to analyze with clang-tidy.")
  endif()

  if(NOT CLANG_TIDY_FILETYPES)
    set(CLANG_TIDY_FILETYPES "*.c" "*.cpp" CACHE STRING "CMake list of file types to analyze using clang-tidy.")
  endif()

  if(CLANG_TIDY_ADDITIONAL_DIRS)
    list(APPEND CLANG_TIDY_INCLUDE_DIRS ${CLANG_TIDY_ADDITIONAL_DIRS})
  endif()

  if(CLANG_TIDY_ADDITIONAL_FILETYPES)
    list(APPEND CLANG_TIDY_FILETYPES ${CLANG_TIDY_ADDITIONAL_FILETYPES})
  endif()

  ## Convert Variables into script format
  string(REPLACE ";" "," CLANG_TIDY_DIRS_ARG "${CLANG_TIDY_INCLUDE_DIRS}")
  string(REPLACE ";" "," CLANG_TIDY_FILETYPES_ARG "${CLANG_TIDY_FILETYPES}")
  message(STATUS "clan-tidy args ${CMAKE_BINARY_DIR} ${CLANG_TIDY_ADDITIONAL_OPTIONS}")

  add_custom_target(static-tidy
    COMMENT "Running clang-tidy on all sources"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_SOURCE_DIR}/scripts/clang_tidy.sh ${CMAKE_BINARY_DIR}
      # Directories to include in analysis
      ${CLANG_TIDY_DIRS_ARG}
      # File types to include in analysis
      ${CLANG_TIDY_FILETYPES_ARG}
      # Additional user options to pass to clang-tidy
      ${CLANG_TIDY_ADDITIONAL_OPTIONS}
  )
else()
  message("[WARNING] Clang-tidy is not installed. Clang-tidy targets are disabled.")
endif()
