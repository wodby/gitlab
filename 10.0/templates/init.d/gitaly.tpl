#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec gitaly {{ getenv "GITLAB_DIR"}}/gitaly.toml