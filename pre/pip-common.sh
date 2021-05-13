#!/usr/bin/env bash

set -xu
set +e

source python-common.sh

# See what pip is called on the platform

PIP="$(which pip3)"

if [[ $? -ne 0 ]]; then
  PIP="$(which pip-3)"
fi

if [[ $? -ne 0 ]]; then
  PIP="$(which pip)"
fi

# On macOS we need to sudo. On everything else, we run as root.
if [[ "$PIP" != "" && "$(uname -s)" == "Darwin" ]]; then
  PIP="sudo $PIP"
fi

_PIP_ANSIBLE_DEPS="$($PYTHON <<EOF
import pip
if int(pip.__version__.split('.')[0]) < 9:
    print("pyyaml cryptography>=2.5,<3.4 jinja2<3 markupsafe<2")
else:
    print("pyyaml cryptography jinja2 markupsafe")
EOF
)"

IFS=' ' read -r -a PIP_ANSIBLE_DEPS <<< "$_PIP_ANSIBLE_DEPS"

set -e
