#!/bin/bash

PYTHON="./venv/bin/python"
PIP="./venv/bin/pip"
REQUIREMENTS="requirements.txt"

check_virtualenv() {
    if [ ! -x "$PYTHON" ]; then
        echo "Virtual environment not found. Make sure to create it with 'python -m venv venv'."
        exit 1
    fi
}

sync_dependencies() {
    echo "Syncing dependencies..."
    INSTALLED=$($PIP install --disable-pip-version-check -r $REQUIREMENTS 2>&1)
    if [ $? -eq 0 ]; then
        echo "Dependencies synced."
        echo "$INSTALLED" | grep -E '^Successfully installed' | sed 's/^Successfully installed /Installed packages: /'
    else
        echo "Failed to sync dependencies."
        exit 1
    fi
}

list_dependencies() {
    echo "Listing installed dependencies..."
    $PIP freeze
}

run_bot() {
    echo "Starting the bot..."
    $PYTHON main.py
    if [ $? -ne 0 ]; then
        echo "Failed to start the bot."
        exit 1
    fi
}

case "$1" in
    --run)
        check_virtualenv
        sync_dependencies
        run_bot
        ;;
    --dependency)
        case "$2" in
            list)
                check_virtualenv
                list_dependencies
                ;;
            sync)
                check_virtualenv
                sync_dependencies
                ;;
            *)
                echo "Invalid option for --dependency. Use 'list' or 'sync'."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage:"
        echo "./ayu.sh --run                      # Start the bot"
        echo "./ayu.sh --dependency list          # List installed dependencies"
        echo "./ayu.sh --dependency sync          # Sync dependencies with requirements.txt"
        exit 1
        ;;
esac
