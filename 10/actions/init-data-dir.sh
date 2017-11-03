#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "Initializing data dir..."
chmod 755 "${GITLAB_DATA_DIR}"

# Public
mkdir -p "${GITLAB_PUBLIC_DIR}"

if [[ ! -L "${GITLAB_DIR}/public" ]]; then
    rsync -rlt "${GITLAB_DIR}/public/" "${GITLAB_PUBLIC_DIR}"
    rm -rf  "${GITLAB_DIR}/public"
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

if [[ ! -L "${GITLAB_DIR}/builds" ]]; then
    rm -rf "${GITLAB_DIR}/builds"
    ln -sf "${GITLAB_BUILDS_DIR}" "${GITLAB_DIR}/builds"
fi

# Downloads
mkdir -p "${GITLAB_DOWNLOADS_DIR}"
chmod u+rwX "${GITLAB_DOWNLOADS_DIR}"

# Shared
mkdir -p "${GITLAB_SHARED_DIR}"
chmod u+rwX "${GITLAB_SHARED_DIR}"

if [[ ! -L "${GITLAB_DIR}/shared" ]]; then
    rm -rf "${GITLAB_DIR}/shared"
    ln -sf "${GITLAB_SHARED_DIR}" "${GITLAB_DIR}/shared"
fi

# Artifacts
mkdir -p "${GITLAB_ARTIFACTS_DIR}"
chmod u+rwX "${GITLAB_ARTIFACTS_DIR}"

# Pages
mkdir -p "${GITLAB_PAGES_DIR}"
chmod u+rwX "${GITLAB_PAGES_DIR}"

# LFS objects
mkdir -p "${GITLAB_LFS_OBJECTS_DIR}"
chmod u+rwX "${GITLAB_LFS_OBJECTS_DIR}"

# Registry
mkdir -p "${GITLAB_REGISTRY_DIR}"
chmod u+rwX "${GITLAB_REGISTRY_DIR}"

# Backups
mkdir -p "${GITLAB_BACKUP_DIR}"
