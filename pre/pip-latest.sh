#!/usr/bin/env bash

set -eux

source pip-common.sh
source python-common.sh

# Upgrade pip
PIPVER="$($PYTHON <<EOF
import sys
if sys.version_info[:2] < (3, 6):
    print("pip < 21")
else:
    print("pip")
EOF
)"

$PIP install --upgrade "$PIPVER"
$PIP install $PRODUCT==$VERSION
