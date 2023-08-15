#!/usr/bin/env bash

set -e # Exit if any command fails

# Usage: ./script.sh <github-repo-url> <file-extension>

if [[ $# -ne 2 ]]; then
	echo "Usage: ./script.sh <github-repo-url> <file-extension>"
	exit 1
fi

REPO=$1
EXTENSION=$2

# Create a temporary directory
TMP_DIR=$(mktemp -d -t repo-XXXXX)

# Cleanup function to remove temporary directory
function cleanup {
	rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

# Clone the repository into the temporary directory
git clone "${REPO}" "${TMP_DIR}"

# Find and print file contents
echo ""
echo "// *** Printing files with extension .$EXTENSION ***"
echo ""
find "${TMP_DIR}" -name "*.${EXTENSION}" -exec bash -c 'echo ""; echo "// $(realpath --relative-to='"${TMP_DIR}"' {})"' \; -exec cat {} \;

# The script will automatically cleanup as it exits
