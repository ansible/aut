#!/usr/bin/env bash

set -eux

# Test official PPA
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible

# versions are e.g. 2.10.0-1ppa~bionic so match on $VERSION-*
apt-get -y install "$PRODUCT=$VERSION-*"
