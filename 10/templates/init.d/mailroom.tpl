#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ "${GITLAB_INCOMING_EMAIL}" == "true" ]]; then
    exec bundle exec mail_room -c "${GITLAB_DIR}/config/mail_room.yml"
else
    exec bundle exec mail_room
fi