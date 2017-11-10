#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "Initializing data dir..."
chmod 755 "${GITLAB_DATA_DIR}"

# Public
mkdir -p "${GITLAB_PUBLIC_DIR}"
rsync -rlt "${GITLAB_DIR}/orig_public/" "${GITLAB_PUBLIC_DIR}"

# Uploads
mkdir -p "${GITLAB_PUBLIC_DIR}/uploads"
chmod 0700 "${GITLAB_PUBLIC_DIR}/uploads"

# Repositories
mkdir -p "${GITLAB_REPOS_DIR}"
chmod ug+rwX,o-rwx "${GITLAB_REPOS_DIR}"
chmod g+s "${GITLAB_REPOS_DIR}"

# Backups
mkdir -p "${GITLAB_BACKUP_DIR}"

declare -a dirs=(
    "${GITLAB_BUILDS_DIR}"
    "${GITLAB_DOWNLOADS_DIR}"
    "${GITLAB_SHARED_DIR}"
    "${GITLAB_ARTIFACTS_DIR}"
    "${GITLAB_PAGES_DIR}"
    "${GITLAB_LFS_OBJECTS_DIR}"
    "${GITLAB_REGISTRY_DIR}"
)

for dir in "${dirs[@]}"
do
    mkdir -p "${dir}"
    chmod u+rwX "${dir}"
done

# Generating key and self-signed certificate for container registry.
if [[ "${GITLAB_REGISTRY_ENABLED}" == "true" && ! -f "${certs_dir}/registry-auth.crt" ]]; then
    mkdir -p "${GITLAB_DATA_DIR}/certs"
    cd "${GITLAB_DATA_DIR}/certs"
    openssl req -nodes -newkey rsa:2048 -keyout registry-auth.key -out registry-auth.csr -subj "/CN=gitlab-issuer"
    openssl x509 -in registry-auth.csr -out registry-auth.crt -req -signkey registry-auth.key -days 3650
fi
