#!/bin/bash
set -e

if [ $1 = 'exec' ]; then
    exec "${@:5}"
elif [[ $1 = 'pygmentize' || $1 = 'hugo' ]]; then
    exec "$@"
else
    exec hugo "$@"
fi

chown -R 1000:1000 /data