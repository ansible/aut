#!/usr/bin/env bash
python build-matrix.py > .travis.yml
git add matrix.yml .travis.yml
git commit -sm 'update matrix'
