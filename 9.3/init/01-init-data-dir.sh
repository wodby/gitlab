#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "Initializing data dir..."
chmod 755 ${GITLAB_DATA_DIR}

# symlink ${GITLAB_HOME}/.ssh -> ${GITLAB_LOG_DIR}/gitlab
#rm -rf ${GITLAB_HOME}/.ssh && \
#ln -sf ${GITLAB_DATA_DIR}/.ssh ${GITLAB_HOME}/.ssh && \

if [[ ! -d "${GITLAB_PUBLIC_DIR}" ]]; then
    mv "${GITLAB_DIR}/public/" "${GITLAB_PUBLIC_DIR}"
fi

if [[ ! -L "${GITLAB_DIR}/public" ]]; then
    ln -sf "${GITLAB_PUBLIC_DIR}" "${GITLAB_DIR}/public"
fi

# Uploads
mkdir -p "${GITLAB_PUBLIC_DIR}/uploads"
chmod 0700 "${GITLAB_PUBLIC_DIR}/uploads"
chown git:git "${GITLAB_PUBLIC_DIR}/uploads"

## symlink ${GITLAB_DIR}/.secret -> ${GITLAB_DATA_DIR}/.secret
#rm -rf ${GITLAB_DIR}/.secret && \
#su-exec git ln -sf ${GITLAB_DATA_DIR}/.secret ${GITLAB_DIR}/.secret && \

# Create SSH directory for server keys
mkdir -p ${GITLAB_DATA_DIR}/ssh
chown -R root: ${GITLAB_DATA_DIR}/ssh

# Create repositories directory and make sure it has the right permissions
mkdir -p ${GITLAB_REPOS_DIR}
chown ${GITLAB_USER}: ${GITLAB_REPOS_DIR}
chmod ug+rwX,o-rwx ${GITLAB_REPOS_DIR}
chmod g+s ${GITLAB_REPOS_DIR}

# Create build traces directory
mkdir -p ${GITLAB_BUILDS_DIR}
chmod u+rwX ${GITLAB_BUILDS_DIR}
chown ${GITLAB_USER}: ${GITLAB_BUILDS_DIR}

# Create downloads directory
mkdir -p ${GITLAB_DOWNLOADS_DIR}
chmod u+rwX ${GITLAB_DOWNLOADS_DIR}
chown ${GITLAB_USER}: ${GITLAB_DOWNLOADS_DIR}

# Shared
mkdir -p ${GITLAB_SHARED_DIR}
chmod u+rwX ${GITLAB_SHARED_DIR}
chown ${GITLAB_USER}: ${GITLAB_SHARED_DIR}

# Artifacts
mkdir -p ${GITLAB_ARTIFACTS_DIR}
chmod u+rwX ${GITLAB_ARTIFACTS_DIR}
chown ${GITLAB_USER}: ${GITLAB_ARTIFACTS_DIR}

# Pages
mkdir -p ${GITLAB_PAGES_DIR}
chmod u+rwX ${GITLAB_PAGES_DIR}
chown ${GITLAB_USER}: ${GITLAB_PAGES_DIR}

# Symlink ${GITLAB_DIR}/shared -> ${GITLAB_DATA_DIR}/shared

if [[ ! -L "${GITLAB_DIR}/shared" ]]; then
    ln -sf "${GITLAB_SHARED_DIR}" "${GITLAB_DIR}/shared"
fi

if [[ ! -L "${GITLAB_DIR}/builds" ]]; then
    ln -sf "${GITLAB_BUILDS_DIR}" "${GITLAB_DIR}/builds"
fi

# LFS objects
mkdir -p ${GITLAB_LFS_OBJECTS_DIR}
chmod u+rwX ${GITLAB_LFS_OBJECTS_DIR}
chown ${GITLAB_USER}: ${GITLAB_LFS_OBJECTS_DIR}

# Registry
if [[ ${GITLAB_REGISTRY_ENABLED} == true ]]; then
    mkdir -p ${GITLAB_REGISTRY_DIR}
    chmod u+rwX ${GITLAB_REGISTRY_DIR}
    chown ${GITLAB_USER}: ${GITLAB_REGISTRY_DIR}
fi

# Backups
mkdir -p ${GITLAB_BACKUP_DIR}
chown ${GITLAB_USER}: ${GITLAB_BACKUP_DIR}

# .ssh
mkdir -p "${GITLAB_DATA_DIR}/.ssh"
touch "${GITLAB_DATA_DIR}/.ssh/authorized_keys"
chmod 700 "${GITLAB_DATA_DIR}/.ssh"
chmod 600 "${GITLAB_DATA_DIR}/.ssh/authorized_keys"
chown -R git:git "${GITLAB_DATA_DIR}/.ssh"
