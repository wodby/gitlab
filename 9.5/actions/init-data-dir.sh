#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "Initializing data dir..."
chmod 755 "${GITLAB_DATA_DIR}"

# Public
if [[ ! -d "${GITLAB_PUBLIC_DIR}" ]]; then
    mv "${GITLAB_DIR}/public/" "${GITLAB_PUBLIC_DIR}"
fi

if [[ ! -L "${GITLAB_DIR}/public" ]]; then
    ln -sf "${GITLAB_PUBLIC_DIR}" "${GITLAB_DIR}/public"
fi

# Uploads
mkdir -p "${GITLAB_PUBLIC_DIR}/uploads"
chmod 0700 "${GITLAB_PUBLIC_DIR}/uploads"

# Repositories
mkdir -p "${GITLAB_REPOS_DIR}"
chmod ug+rwX,o-rwx "${GITLAB_REPOS_DIR}"
chmod g+s "${GITLAB_REPOS_DIR}"

# Builds
mkdir -p "${GITLAB_BUILDS_DIR}"
chmod u+rwX "${GITLAB_BUILDS_DIR}"

# Downloads
mkdir -p "${GITLAB_DOWNLOADS_DIR}"
chmod u+rwX "${GITLAB_DOWNLOADS_DIR}"

# Shared
mkdir -p "${GITLAB_SHARED_DIR}"
chmod u+rwX "${GITLAB_SHARED_DIR}"

# Artifacts
mkdir -p "${GITLAB_ARTIFACTS_DIR}"
chmod u+rwX "${GITLAB_ARTIFACTS_DIR}"

if [[ ! -L "${GITLAB_DIR}/shared" ]]; then
    ln -sf "${GITLAB_SHARED_DIR}" "${GITLAB_DIR}/shared"
fi

if [[ ! -L "${GITLAB_DIR}/builds" ]]; then
    ln -sf "${GITLAB_BUILDS_DIR}" "${GITLAB_DIR}/builds"
fi

# LFS objects
mkdir -p "${GITLAB_LFS_OBJECTS_DIR}"
chmod u+rwX "${GITLAB_LFS_OBJECTS_DIR}"

# Registry
if [[ "${GITLAB_REGISTRY_ENABLED}" == true ]]; then
    mkdir -p "${GITLAB_REGISTRY_DIR}"
    chmod u+rwX "${GITLAB_REGISTRY_DIR}"
fi

# Backups
mkdir -p "${GITLAB_BACKUP_DIR}"

# SSH
mkdir -p "${GITLAB_DATA_DIR}/.ssh"
touch "${GITLAB_DATA_DIR}/.ssh/authorized_keys"
chmod 700 "${GITLAB_DATA_DIR}/.ssh"
chmod 600 "${GITLAB_DATA_DIR}/.ssh/authorized_keys"

# Gitlab shell secret
if [[ -z "${GITLAB_SHELL_SECRET}" ]]; then
    openssl rand -hex -out "${GITLAB_DATA_DIR}/.secrets/gitlab_shell_secret" 16
else
    echo "${GITLAB_SHELL_SECRET}" > "${GITLAB_DATA_DIR}/.secrets/gitlab_shell_secret"
fi

chmod 600 "${GITLAB_DATA_DIR}/.secrets/gitlab_shell_secret"

# Workhorse secret
if [[ -z "${GITLAB_WORKHORSE_SECRET}" ]]; then
    openssl rand -base64 -out "${GITLAB_DATA_DIR}/.secrets/gitlab_workhorse_secret" 32
else
    echo "${GITLAB_WORKHORSE_SECRET}" > "${GITLAB_DATA_DIR}/.secrets/gitlab_workhorse_secret"
fi

chmod 600 "${GITLAB_DATA_DIR}/.secrets/gitlab_workhorse_secret"