#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec /home/git/gitaly/gitaly /home/git/gitaly/gitaly.toml