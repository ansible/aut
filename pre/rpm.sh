#!/usr/bin/env bash

set -eux

# Test official RPM - only for ansible right now, not ansible-base
# and only EL7
URL="https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64"

yum -y install \
    "$URL/ansible-$VERSION-1.el7.ans.noarch.rpm" \
    "$URL/ansible-test-$VERSION-1.el7.ans.noarch.rpm"
