#!/bin/bash
# Script to run clang-tidy.
# Author: Salvador Z.
# clang_tidy.sh [compile_commands.json path] DIRS TYPES [options]
#
# This script is used to run clang-tidy on source code files in specified directories using a specific set of file types.
#
# Required arguments:
#   - DIRS:  A comma-separated list of directories to search for files in.
#   - TYPES: A comma-separated list of file types to search for, specified as globs (e.g., *.c, *.h, *.cpp, *.hpp).
#
# Optional arguments:
#   --fix: Apply suggested fixes.
#
# Example usage:
#   clang_tidy.sh ./build src,include *.c,*.cpp, --fix

set -e

# Argument 1 is the path to the directory containing the compile_commands.json file
BUILD_OUTPUT_FOLDER=${1:-buildresults}

# Argument 2 is a list of directories to include in clang-tidy analysis
DIRS=$(printf " %s" "${2//,/ }")

# Argument 3 is a list of file names/types to include in clang-tidy analysis
FILE_TYPES=$(printf " -iname %s" "${3//,/ -o -iname }")

find ${DIRS[@]} ${FILE_TYPES} \
	| xargs clang-tidy -p $BUILD_OUTPUT_FOLDER ${@:4} --format-style=file

exit 0
