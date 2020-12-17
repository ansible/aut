#!/usr/bin/env bash

set -eux

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Some systems (cough, osx) need their $PATH altered for certain pre's.
# Just do it here so they affect all run-tests.
export PATH="$PATH:$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["data"])')/bin"

cd "$DIR/pre"
bash "${PRE}.sh"

cd ../run
for file in *.sh; do
  bash "$file"
done
