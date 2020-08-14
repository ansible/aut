#!/usr/bin/env bash

set -xu

PIP="$(which pip)"

if [[ $? -ne 0 ]]; then
  PIP="$(which pip3)"
fi

if [[ $? -ne 0 ]]; then
  PIP="$(which pip-3)"
fi

set -e

wget "https://releases.ansible.com/$PRODUCT/$PRODUCT-$VERSION.tar.gz"
tar -xvf "$PRODUCT-$VERSION.tar.gz"
ln -s "$(pwd)/$PRODUCT-$VERSION"/bin/* /usr/bin/

$PIP install jinja2 pyyaml

set +e

# HACK! Shebangs want `python` in path.
which python

if [[ $? -ne 0 ]]; then
    which python3
    if [[ $? -eq 0 ]]; then
        ln -s "$(which python3)" /usr/bin/python
    else
        echo "No python/python3 found"
        exit 1
    fi
fi
