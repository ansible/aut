#!/usr/bin/env bash

set -eux

source pip-common.sh

$PIP install --upgrade pip
$PIP install $PRODUCT==$VERSION
