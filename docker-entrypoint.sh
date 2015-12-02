#!/bin/bash
set -e

if [ "$1" = 'check-update' ]; then
    last_version=$(git ls-remote --tags https://github.com/spf13/hugo.git \
        | sort -t '/' -k 3 -V \
        | awk '/./{line=$0} END{print line}' \
        | sed 's/[^\/]*\/tags\/v//')

    if [ $HUGO_VERSION = $last_version ]; then
        echo "Your version is latest (v${last_version})."
    else
        echo "Available newer version (v${last_version})."
    fi
else
    exec hugo "$@"
fi