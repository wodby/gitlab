#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

bundle exec mail_room {{ if (getenv "GITLAB_INCOMING_EMAIL") }}-c {{ getenv "GITLAB_DIR" }}/config/mail_room.yml{{ end }} {{ if (getenv "DEBUG") }}-d{{ end }}
