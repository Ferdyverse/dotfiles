#!/bin/bash

FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$|\.js$|\.css$|\.html$|\.yml$|\.yaml$|\.json$|\.sh$|\.md$')

for FILE in $FILES; do
    # Remove trailing whitespace
    sed -i 's/[[:space:]]\+$//' "$FILE"

    # Add modified file to the staging area
    git add "$FILE"
done

echo "✅ Trailing whitespaces removed for staged files."
