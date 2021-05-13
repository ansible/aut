#!/usr/bin/env bash

set -eux

source pip-common.sh

$PIP install "${PIP_ANSIBLE_DEPS[@]}" $PRODUCT==$VERSION
