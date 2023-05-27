cmake_minimum_required(VERSION 3.0.0)
project(embedded_c_utils
  VERSION 0.1
  DESCRIPTION "Utils for Embedded Systems in C"
  LANGUAGES C CXX ASM)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

message(STATUS ${CMAKE_SOURCE_DIR})

### General Configuration ###

set_property(GLOBAL PROPERTY C_STANDARD 11)
set_property(GLOBAL PROPERTY CXX_STANDARD 17)

### Compiler Flags Configuration ###

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_FLAGS "-Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_C_FLAGS_RELEASE "-O3")

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

### General Project Structure ###

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/)
  # Create an output dir in PROJECT_SOURCE_DIR
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_BUILD_TYPE}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_BUILD_TYPE}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/${CMAKE_BUILD_TYPE}/lib)

### Project Source Tree ###

add_subdirectory("src")