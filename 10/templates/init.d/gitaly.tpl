#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec {{ getenv "GITALY_DIR" }}/gitaly {{ getenv "GITALY_DIR" }}/gitaly.toml