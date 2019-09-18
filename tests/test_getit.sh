#!/usr/bin/env bash

# Tests the 'getit' shell script. This must be run from the root of the
# repository:
#
#     ./tests/getit.sh

set -Eeou pipefail

# Pull in helper functions
source tests/utils.sh

# Test that the help flags exit successfully.
test_help() {
    ./getit --help
    ./getit -h
}

# Test that the script fails on invalid options.
test_invalid_option() {
    should_fail ./getit --invalid-option
}

# Test that a relative path installation works.
test_relative_install() {
    TEMP=$(mktemp -d "tmp XXXXXXXXXX with spaces")
    trap "cleanup '$TEMP'" EXIT

    ./getit "$TEMP"

    # Make sure we can execute it
    "$TEMP/bin/cloudseal" --version
}

# Test that we can install to the system.
test_absolute_install() {
    should_fail cloudseal --help

    sudo ./getit

    # Make sure it is in $PATH and can be executed.
    cloudseal --version
}

# Run all the tests.
run_test test_help
run_test test_invalid_option
run_test test_relative_install
run_test test_absolute_install
