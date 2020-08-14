#!/usr/bin/env bash

set -eux

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR/pre"
bash "${PRE}.sh"

cd ../run
for file in *.sh; do
    bash "$file"
done
