#!/usr/bin/env bash

set -xu
set +e

# See what python is called on the platform

PYTHON="$(which python3)"

if [[ $? -ne 0 ]]; then
  PYTHON="$(which python)"
fi

if [[ $? -ne 0 ]]; then
  PYTHON="$(which python2)"
fi

set -e
