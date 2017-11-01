#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ -n "${1}" ]]; then
    bundle exec rake gitlab:backup:create SKIP="${1}"
else
    bundle exec rake gitlab:backup:create
fi

filename=$(ls -Art "${GITLAB_BACKUP_DIR}" | tail -n 1)
filepath="${GITLAB_BACKUP_DIR}/${filename}"

if [[ "${filename}" =~ (.+)gitlab_backup\.tar$ ]]; then
    timestamp="${BASH_REMATCH[1]}";
fi

echo "BACKUP_FILE_PATH=${filepath}"
echo "BACKUP_TIMESTAMP=${timestamp}"
stat -c "BACKUP_FILE_SIZE=%s" "${filepath}"
