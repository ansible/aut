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

# When upgrading pip from SCL the pip binary path
# change so we need to reload the path in the PIP
# variable.
source pip-common.sh

$PIP install $PRODUCT==$VERSION
