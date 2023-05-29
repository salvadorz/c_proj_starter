#!/bin/bash
# Script to run clang-format.
# Author: Salvador Z.
# format.sh [options] DIRS TYPES
#
# This script is used to format source code files in specified directories using a specific set of file types.
#
# Required arguments:
#   - DIRS:  A comma-separated list of directories to search for files in.
#   - TYPES: A comma-separated list of file types to search for, specified as globs (e.g., *.c, *.h, *.cpp, *.hpp).
#
# Optional arguments:
#   -e: Specifies a comma-separated list of directories to exclude from formatting.
#   -p: Generates a patch file using 'git'.
#   -a: Performs a search of source code files in current project directory
#
# Example usage:
#   format.sh -e src/pid,src/external src,include *.c,*.h,*.cpp,*.hpp
# NOTE: Due to limitations of 'getopts', optional arguments must precede positional arguments.
#
## Processing strategy for separating CSVs is derived from:
## https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash#tab-top

set -e

EXCLUDES_ARGS=
PATCH='0'
ALL='0'

while getopts "e:pa" opt; do
  case $opt in
    e) EXCLUDES_ARGS="$OPTARG"
    ;;
    p) PATCH='1'
    ;;
    a) ALL='1'
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Shift off the getopts args, leaving us with positional args
shift $((OPTIND -1))

if [ "$ALL" == '1' ]; then
  sources=$(find . -regextype posix-extended -regex \
  ".*\.(c|cpp|cxx|cc|hpp|hxx|h)" |
  grep -vE "^./(build)/")
  #echo "Found this sources ${sources}"
  echo "Running clang-format on all source files from the project"
  clang-format --dry-run --ferror-limit=3 -style=file ${sources} -i -fallback-style=LLVM
  exit 0
fi

DIRS=
# Parse $1 into a list of directories
IFS=',' read -ra ENTRIES <<< "$1"
for entry in "${ENTRIES[@]}"; do
	DIRS="$DIRS $entry"
done

# Parse $2 into file-type arguments
FILE_TYPES=
IFS=',' read -ra ENTRIES <<< "$2"
for entry in "${ENTRIES[@]}"; do
	FILE_TYPES="$FILE_TYPES -o -iname $entry"
done

# Parse $3 into the exclude arguments
EXCLUDES=
IFS=',' read -ra ENTRIES <<< "$EXCLUDES_ARGS"
for entry in "${ENTRIES[@]}"; do
	EXCLUDES="$EXCLUDES -o -path $entry"
done

if [[ ! -z $EXCLUDES ]]; then
	# Remove the initial `-o` argument for a single/first directory
	EXCLUDES=${EXCLUDES:3:${#EXCLUDES}}

	# Create the final argument string
	EXCLUDES="-type d \( $EXCLUDES \) -prune"
else
	# Remove the initial `-o` argument for the first file type if there are no excludes,
	# otherwise the rules will not be properly parsed
	FILE_TYPES=${FILE_TYPES:3:${#FILE_TYPES}}
fi

echo "DIRS:${DIRS}"
echo "EXCLUDES: ${EXCLUDES}"
echo "FILE_TYPES: ${FILE_TYPES}"

eval find $DIRS $EXCLUDES -type f $FILE_TYPES \
	| xargs echo #clang-format -style=file -i -fallback-style=LLVM

if [ "$PATCH" == '1' ]; then
	git diff > clang_format.patch

	# Delete if 0 size
	if [ ! -s clang_format.patch ]
	then
		rm clang_format.patch
	fi
fi

exit 0
