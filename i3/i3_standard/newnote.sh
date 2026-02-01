#!/bin/bash

# Target folder for notes
DIR="$HOME/Desktop/notes"

# Create the folder if it does not exist
mkdir -p "$DIR"

# Timestamp-based filename
FILENAME="note-$(date +%Y-%m-%d-%H%M).txt"
FILE="$DIR/$FILENAME"

# Open the file in micro using the default terminal
if [ -n "$TERMINAL" ]; then
    "$TERMINAL" -e micro "$FILE"
else
    x-terminal-emulator -e micro "$FILE"
fi
