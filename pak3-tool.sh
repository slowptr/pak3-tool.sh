#!/bin/bash
#
# pak3-tool.sh
#
# This script extracts a specified .pak3 archive into the current folder.
# Later, after you modify its contents, it repacks the current folder into
# a new archive having the same name as the original, while first renaming
# the original archive with a .bk suffix.
#
# Requirements:
#   - 7z (part of p7zip-full on many distributions)
#
# Usage:
#   ./pak3-tool.sh unpack archive.pak3
#   (Make your modifications in the current folder, then run:)
#   ./pak3-tool.sh pack archive.pak3

usage() {
    echo "Usage: $0 {unpack|pack} archive.pak3"
    exit 1
}

# ensure argument count of 2
if [ "$#" -ne 2 ]; then
    usage
fi

ACTION=$1
ARCHIVE=$2

if ! command -v 7z >/dev/null 2>&1; then
    echo "Error: 7z command not found. Please install p7zip (or p7zip-full on Debian/Ubuntu)."
    exit 1
fi

case "$ACTION" in
    unpack)
        if [ ! -f "$ARCHIVE" ]; then
            echo "Error: File '$ARCHIVE' not found."
            exit 1
        fi

        echo "Unpacking '$ARCHIVE' into the current folder..."
        7z x "$ARCHIVE"
        if [ $? -eq 0 ]; then
            echo "Unpacking complete."
        else
            echo "Error: An error occurred during unpacking."
            exit 1
        fi
        ;;
    pack)
        # backup 'original' archive for 1337 master-safety
        if [ -f "$ARCHIVE" ]; then
            BACKUP="${ARCHIVE}.bk"
            echo "Renaming original archive '$ARCHIVE' to '$BACKUP'..."
            # Remove any existing backup
            if [ -f "$BACKUP" ]; then
                echo "Removing existing backup '$BACKUP'..."
                rm -f "$BACKUP" || { echo "Error: Could not remove existing backup."; exit 1; }
            fi
            mv "$ARCHIVE" "$BACKUP" || { echo "Error: Could not rename original archive."; exit 1; }
        else
            echo "Warning: Original archive '$ARCHIVE' not found in current folder."
            echo "         Packing will create a new archive named '$ARCHIVE'."
        fi

        SCRIPT_NAME=$(basename "$0")
        echo "Packing current folder into archive '$ARCHIVE'..."

        files=( * .[!.]* )

        if [ ${#files[@]} -eq 0 ]; then
            echo "Error: No files found in the current directory to pack."
            exit 1
        fi

        7z a "$ARCHIVE" "${files[@]}" -x!"${ARCHIVE}.bk" -x!"$SCRIPT_NAME"
        if [ $? -eq 0 ]; then
            echo "Packing complete. New archive created: '$ARCHIVE'"
        else
            echo "Error: An error occurred during packing."
            exit 1
        fi
        ;;
    *)
        echo "Error: Invalid action '$ACTION'."
        usage
        ;;
esac

exit 0
