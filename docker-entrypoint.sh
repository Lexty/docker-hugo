#!/bin/bash
set -e

exec /bin/hugo "$@"

chown -R 1000:1000 /data