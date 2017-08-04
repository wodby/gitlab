#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec bundle exec mail_room -c "${GITLAB_DIR}/config/mail_room.yml"