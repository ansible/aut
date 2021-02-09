#!/usr/bin/env bash

set -eux

source pip-common.sh
source python-common.sh

# Upgrade pip
PYVER="$($PYTHON -c 'import sys; print(sys.version_info[0])')"

if [[ "$PYVER" == "3" ]]; then
  $PIP install --upgrade pip
else
  $PIP install --upgrade 'pip < 21'
fi

$PIP install $PRODUCT==$VERSION
