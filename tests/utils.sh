# Utility functions for test scripts. Simply source this file to use the
# functions defined here.

# Cleans up a directory. Used with traps for cleaning up temporary files and
# directories.
cleanup() {
    rm -rf -- "$1"
}

# Runs a command that should fail.
should_fail() {
    if $@; then
        # Command didn't fail
        return 1
    else
        # Command failed as expected
        return 0
    fi
}

# Reports a test failure.
report_failure() {
    local _code=$?

    if [[ "$_code" -eq 0 ]]; then
        # Command didn't fail. Clean up the log file.
        rm -f -- "$1"
        return 0
    fi

    echo " FAILED! See log output below:"
    echo "============================================================"
    cat "$1"
    echo "============================================================"

    # Remove the log file.
    rm -f -- "$1"

    echo "(Command exited with code $_code)"

    exit 1
}

# Runs a test, reporting the output if it failed.
run_test() {
    echo -n ":: Running test '$@'..."
    LOG_FILE=$(mktemp)

    # Run the command
    if $@ > "$LOG_FILE" 2>&1; then
        echo " success."
    else
        local _code=$?
        echo " FAILED! See log output below:"
        echo "============================================================"
        cat "$LOG_FILE"
        echo "============================================================"

        # Remove the log file.
        rm -f -- "$LOG_FILE"

        echo "(Command exited with code $_code)"
        return 1
    fi
}
