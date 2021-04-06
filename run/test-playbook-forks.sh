#!/usr/bin/env bash

set -eux

ansible-playbook -i inventory --forks 3 pb.yml
