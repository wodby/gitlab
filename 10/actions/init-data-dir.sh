#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "Initializing data dir..."
chmod 755 "${GITLAB_DATA_DIR}"

# Uploads
mkdir -p "${GITLAB_UPLOADS_DIR}"
chmod 0700 "${GITLAB_UPLOADS_DIR}"

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

mkdir -p "${GITLAB_REGISTRY_CERTS_DIR}"

# Generating key and self-signed certificate for container registry.
if [[ "${GITLAB_REGISTRY_ENABLED}" == "true" && ! -f "${GITLAB_REGISTRY_CERTS_DIR}/registry-auth.crt" ]]; then
    sudo fix-permissions.sh git git "${GITLAB_REGISTRY_CERTS_DIR}"
    gen-ssl-certs.sh "${GITLAB_REGISTRY_CERTS_DIR}" "${GITLAB_REGISTRY_ISSUER:-gitlab-issuer}" "registry-auth"
fi
