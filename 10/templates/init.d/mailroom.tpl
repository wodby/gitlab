#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
    debug_flags="-d"
fi

if [[ "${GITLAB_INCOMING_EMAIL}" == "true" ]]; then
    bundle exec mail_room -c "${GITLAB_DIR}/config/mail_room.yml" ${debug_flags}
else
    bundle exec mail_room ${debug_flags}
fi

