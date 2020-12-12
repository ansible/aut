#!/usr/bin/env bash

# See what pip is called on the platform

PIP="$(which pip)"

if [[ $? -ne 0 ]]; then
  PIP="$(which pip3)"
fi

if [[ $? -ne 0 ]]; then
  PIP="$(which pip-3)"
fi

$PIP install $PRODUCT==$VERSION
