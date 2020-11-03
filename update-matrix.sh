#!/usr/bin/env bash
python build-matrix.py > .github/workflows/aut.yml
git add matrix.yml .github/workflows/aut.yml
git commit -sm 'update matrix'
