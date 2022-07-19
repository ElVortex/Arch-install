#!/bin/bash
#github-action genshdoc
#

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set +a

cat $SCRIPT_DIR
