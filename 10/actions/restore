#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

bundle exec rake gitlab:backup:restore BACKUP="${1}" force=yes
