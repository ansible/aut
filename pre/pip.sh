#!/usr/bin/env bash

# See what pip is called on the platform

PIP="$(which pip)"

if [[ $? -ne 0 ]]; then
  PIP="$(which pip3)"
fi

if [[ $? -ne 0 ]]; then
  PIP="$(which pip-3)"
fi

# On macOS we want to install with --user. On everything else, we run as root.

if [[ "$(uname -s)" == "Darwin" ]]; then
  $PIP install --user $PRODUCT==$VERSION
else
  $PIP install $PRODUCT==$VERSION
fi
