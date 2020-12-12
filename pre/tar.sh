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

set +e

# On macOS we need to sudo. On everything else, we run as root.
if [[ "$(uname -s)" == "Darwin" ]]; then
  set -e
  sudo $PIP install jinja2 pyyaml
  #sudo ln -s "$(pwd)/$PRODUCT-$VERSION"/bin/* /usr/local/bin/
  pushd "$(pwd)/$PRODUCT-$VERSION"
  sudo python3 setup.py install
  popd
  set +e
else
  set -e
  $PIP install jinja2 pyyaml
  ln -s "$(pwd)/$PRODUCT-$VERSION"/bin/* /usr/bin/
  set +e
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
