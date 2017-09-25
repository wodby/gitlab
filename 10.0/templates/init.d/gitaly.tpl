#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec "${GITLAB_GITALY_DIR}/gitaly" "${GITLAB_GITALY_DIR}/config.toml"