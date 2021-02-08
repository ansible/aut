#!/usr/bin/env bash

set -xu

# See what pip is called on the platform

PIP="$(which pip3)"

if [[ $? -ne 0 ]]; then
  PIP="$(which pip-3)"
fi

if [[ $? -ne 0 ]]; then
  PIP="$(which pip)"
fi

# On macOS we need to sudo. On everything else, we run as root.
if [[ "$(uname -s)" == "Darwin" ]]; then
  PIP="sudo $PIP"
fi
