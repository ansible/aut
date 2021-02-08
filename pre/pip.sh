#!/usr/bin/env bash

set -eux

source pip-common.sh

$PIP install 'cryptography >=2.5,<3.4' $PRODUCT==$VERSION
