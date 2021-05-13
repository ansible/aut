#!/usr/bin/env bash

set -eux

source pip-common.sh

wget "https://releases.ansible.com/$PRODUCT/$PRODUCT-$VERSION.tar.gz"
tar -xf "$PRODUCT-$VERSION.tar.gz"

$PIP install "${PIP_ANSIBLE_DEPS[@]}"

if [[ "$(uname -s)" == "Darwin" ]]; then
  pushd "$(pwd)/$PRODUCT-$VERSION"
    sudo python3 setup.py install
  popd
else
  ln -s "$(pwd)/$PRODUCT-$VERSION"/bin/* /usr/bin/
fi

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
