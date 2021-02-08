#!/usr/bin/env bash

set -eux

source pip-common.sh

if [[ "$PIP" != "" ]]; then
  echo "pip already installed, refusing to install via get-pip.py"
  echo "This pre script is only compatible with dockerfiles that don't install"
  echo "pip from system repositories."
  exit 1
fi

# Install latest pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

pip install $PRODUCT==$VERSION
