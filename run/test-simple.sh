#!/usr/bin/env bash

set -eux

res="$(ansible -a uptime localhost)"

echo "$res" | grep 'load average'
echo "$res" | grep 'rc=0'
