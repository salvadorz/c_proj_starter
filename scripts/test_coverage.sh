#!/bin/bash
# Script outline to run test coverage using gcov.
# Author: Salvador Z.
# test_coverage.sh [options] DIRS SRC_F
#
# This script is used to do code coverage analysis in source code files in specified directories using gcov and lcov.
#
# Required arguments:
#   - DIRS:  A comma-separated list of directories to search for source files in.
#   - SRC_F: A comma-separated list of file types to search for, specified as globs (e.g., *.c, *.cpp, *.cc).
#
# Optional arguments:
#   -e: Specifies a comma-separated list of directories to exclude from code coverage analysis.
#
# Example usage: test_coverage.sh -e src/pid,src/external src,lib *.c,*.cpp

set -e

EXCLUDES_ARGS=""
DEBUG_SH=false

# Usage helper
print_usage() {
  echo "Usage: test_coverage.sh [options] DIRS SRC_F"
  echo "Options:"
  echo "  -e: Specifies a comma-separated list of directories to exclude from code coverage analysis."
  echo ""
  echo "Example usage:"
  echo "  test_coverage.sh -e src/pid,src/external src,lib *.c,*.cpp"
}

while getopts "e:" opt; do
  case $opt in
    e) EXCLUDES_ARGS="$OPTARG"
    ;;
    \?) print_usage; exit 1 >&2
    ;;
  esac
done

# Shift off the getopts args, leaving us with positional args
shift $((OPTIND -1))

# Parse $1 into a list of directories
DIRS=$(echo ${1} | sed 's/\([^,]\+\)/..\/\1/g' | tr ',' ' ')

# Parse $2 into file-type arguments
FILE_TYPES=$(printf " -o -iname %s" "${2//,/ -o -iname }")

# Parse $3 into the exclude arguments
if [[ -n $EXCLUDES_ARGS ]]; then
  EXCLUDES=$(echo ${EXCLUDES_ARGS} | sed 's/\([^,]\+\)/..\/\1/g')
  EXCLUDES=$(printf " -path %s" "${EXCLUDES//,/ -o -path }")
	# Create the final argument string
	EXCLUDES="-type d \( $EXCLUDES \) -prune"
else
	# Remove the initial `-o` argument for the first file type if there are no excludes,
	# otherwise the rules will not be properly parsed
	FILE_TYPES=${FILE_TYPES:3:${#FILE_TYPES}}
fi

# Search Objects files
objects=$(find . -type f \( -name "*.o" \) ! -path "*/app/*" | tr '\n' ' ')
OBJS=$(printf " %s" "${objects//.\//}")

BUILD_DIR=$(pwd)
TEST_DIR=$(ctest --show-only=json-v1)
TEST_COMMAND="$(ctest -V -N | grep -oP "(Test command:\s)\K([^\s]+)" | tail -n1 | tr -d '\n')"

if [ ! -d "Testing" ]; then
  echo "Running ${TEST_COMMAND}"
  ctest -vv
  # ${TEST_COMMAND}
fi

# Change directory to where ctest expect to be the running
#cd ${TEST_DIR}

# Run the coverage profiler
SRC_F=$(eval find $DIRS $EXCLUDES -type f $FILE_TYPES | tr '\n' ' ')
### Debug ###
if [ false = ${DEBUG_SH} ]; then
  echo "DIRS:${DIRS}"
  echo "OBJS:${OBJS}"
  echo "EXCLUDES: ${EXCLUDES}"
  echo "FILES: ${SRC_F}"
fi

obj_array=($OBJS)
src_array=($SRC_F)

# The OBJS and SRC files must be on the same order and same list length
if [ ${#obj_array[@]} -ne ${#src_array[@]} ]; then
  echo "Error: Object list and Src files list must have same length"
  exit 1
fi
for ((i=0; i<${#obj_array[@]}; i++)); do
  gcov -b "${src_array[$i]}" -o "${obj_array[$i]}"
done

lcov --capture --directory . --output-file TestCoverage.info
# Filter out test files from coverage report
lcov --remove  TestCoverage.info "*/tests/*" --output-file TestCoverage.filtered
# Print the coverage report summary to standard output
lcov --summary TestCoverage.filtered

cd "${BUILD_DIR}"

exit 0