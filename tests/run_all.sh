#!/usr/bin/env bash

THIS_DIR=${BASH_SOURCE%/*}

# Run all tests
for file in "$THIS_DIR/test_*"; do
    echo $file
    ./$file
done
