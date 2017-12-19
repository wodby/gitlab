FROM wodby/ruby:2.3.6

ARG GITLAB_VER

ENV GITLAB_VER="${GITLAB_VER}" \
    GITLAB_DATA_DIR="/mnt/data" \
    RAILS_ENV="production" \
    NODE_ENV="production"

ENV GITLAB_DIR="/home/git/gitlab" \
    GITLAB_SHELL_DIR="/home/git/gitlab-shell" \
    GITALY_DIR="/home/git/gitaly" \
    \
    GITLAB_BACKUP_DIR="${GITLAB_DATA_DIR}/backups" \
    GITLAB_REPOS_DIR="${GITLAB_DATA_DIR}/repositories" \
    GITLAB_BUILDS_DIR="${GITLAB_DATA_DIR}/builds" \
    GITLAB_UPLOADS_DIR="${GITLAB_DATA_DIR}/uploads" \
    \
    # Temporary
    GITLAB_TEMP_DIR="${GITLAB_DATA_DIR}/tmp" \
    GITLAB_DOWNLOADS_DIR="${GITLAB_DATA_DIR}/tmp/downloads" \
    \
    # Shared
    GITLAB_SHARED_DIR="${GITLAB_DATA_DIR}/shared" \
    GITLAB_ARTIFACTS_DIR="${GITLAB_DATA_DIR}/shared/artifacts" \
    GITLAB_LFS_OBJECTS_DIR="${GITLAB_DATA_DIR}/shared/lfs-objects" \
    GITLAB_PAGES_DIR="${GITLAB_DATA_DIR}/shared/pages" \
    GITLAB_REGISTRY_DIR="${GITLAB_DATA_DIR}/shared/registry" \
    GITLAB_REGISTRY_CERTS_DIR="${GITLAB_DATA_DIR}/certs" \
    \
    GITLAB_URL="https://gitlab.com/gitlab-org/gitlab-ce/repository/archive.tar.gz?ref=v${GITLAB_VER}" \
    GITLAB_PAGES_URL="https://gitlab.com/gitlab-org/gitlab-pages/repository/archive.tar.gz" \
    \
    SSHD_PASSWORD_AUTHENTICATION="no" \
    SSHD_USE_DNS="no" \
    SSHD_PERMIT_USER_ENV="yes" \
    SSHD_HOST_KEYS_DIR="${GITLAB_DATA_DIR}/ssh" \
    SSHD_LOG_LEVEL="VERBOSE"

RUN set -xe; \
    \
    addgroup -g 1000 -S git; \
	adduser -u 1000 -D -S -s /bin/bash -G git git; \
	sed -i '/^git/s/!/*/' /etc/shadow; \
	echo "PS1='\w\$ '" >> /home/git/.bashrc; \
    \
    apk add --update --no-cache --virtual .gitlab-rundeps \
        git \
        grep \
        icu-libs \
        libc6-compat \
        libre2 \
        libressl \
        make \
        mariadb-client \
        openssh \
        postgresql-client \
        python2 \
        rsync \
        su-exec \
        sudo \
        tzdata \
        zip; \
    \
    apk add --update --no-cache --virtual .gitlab-build-deps \
        autoconf \
        build-base \
        cmake \
        coreutils \
        g++ \
        gdbm-dev \
        go \
        icu-dev \
        libffi-dev \
        libre2-dev \
        libressl-dev \
        libgcrypt-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        mariadb-dev \
        ncurses-dev \
        nodejs \
        patch \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        yaml-dev \
        yarn \
        zlib-dev; \
    \
    # Temporary install package to get specific bins
    apk add --update redis postgresql; \
    cp /usr/bin/redis-cli /tmp; \
    cp /usr/bin/pg_* /tmp; \
    apk del --purge redis postgresql; \
    mv /tmp/redis-cli /usr/bin/; \
    mv /tmp/pg_* /usr/bin/; \
    \
    # Download gitlab.
    mkdir -p ${GITLAB_DIR}; \
    wget -qO- ${GITLAB_URL} | tar xz --strip-components=1 -C ${GITLAB_DIR}; \
    chown -R git:git ${GITLAB_DIR}; \
    \
    cd ${GITLAB_DIR}; \
    su-exec git cp config/database.yml.postgresql config/database.yml; \
    su-exec git cp config/gitlab.yml.example config/gitlab.yml; \
    \
    chown -R git:git /usr/local/lib/ruby/gems/2.3.0/; \
    chown -R git:git /usr/local/bundle/; \
    \
    # Install gems (build from source).
    export BUNDLE_FORCE_RUBY_PLATFORM=1; \
    su-exec git bundle install -j$(nproc) --deployment --verbose --without development aws kerberos; \
    \
    # Compile assets
    su-exec git yarn install --production --pure-lockfile; \
    # webpack issue workaround https://gitlab.com/gitlab-org/gitlab-ce/issues/38275
    su-exec git yarn add ajv@^4.0.0; \
    su-exec git bundle exec rake gitlab:assets:compile; \
    \
    # PO files
    su-exec git bundle exec rake gettext:pack; \
    su-exec git bundle exec rake gettext:po_to_json; \
    \
    # Install gitlab shell.
    su-exec git bundle exec rake gitlab:shell:install REDIS_URL=redis:6379 SKIP_STORAGE_VALIDATION=true; \
    \
    # Install gitlab pages.
    gitlab_pages_version=$(cat "${GITLAB_DIR}/GITLAB_PAGES_VERSION"); \
    wget -qO- "${GITLAB_PAGES_URL}?ref=v${gitlab_pages_version}" | tar xz -C /tmp/; \
    export GOPATH="/tmp/go"; \
    mkdir -p "/tmp/go/src/gitlab.com/gitlab-org"; \
    ln -s /tmp/gitlab-pages* "$GOPATH/src/gitlab.com/gitlab-org/gitlab-pages"; \
    cd "$GOPATH/src/gitlab.com/gitlab-org/gitlab-pages"; \
    make; \
    mv gitlab-pages /usr/local/bin; \
    \
    # Install workhorse
    cd ${GITLAB_DIR}; \
    su-exec git bundle exec rake "gitlab:workhorse:install[/tmp/workhorse]"; \
    cd /tmp/workhorse/; \
    mv gitlab-workhorse gitlab-zip-cat gitlab-zip-metadata /usr/local/bin/; \
    cd ${GITLAB_DIR}; \
    \
    # Install gitaly (build gems from source)
    chown -R git $(go env GOROOT)/pkg; \
    export BUNDLE_FORCE_RUBY_PLATFORM=1; \
    su-exec git bundle exec rake "gitlab:gitaly:install[${GITALY_DIR}]"; \
    \
    cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb; \
    rm config/secrets.yml; \
    \
    su-exec git sed -i 's/db:reset/db:setup/' ${GITLAB_DIR}/lib/tasks/gitlab/setup.rake; \
    \
    # Configure git
    git config --global core.autocrlf input; \
    git config --global gc.auto 0; \
    git config --global repack.writeBitmaps true; \
    \
    # Configure sudoers
    echo 'git ALL=(root) NOPASSWD: /usr/local/bin/fix-permissions.sh, /usr/sbin/sshd' > tee /etc/sudoers.d/git; \
    \
    rm -rf "/home/git/.ssh"; \
    ln -sf "${GITLAB_DATA_DIR}/.ssh" "/home/git/.ssh"; \
    \
    # Prepare directories and symlinks
    mkdir -p ${GITLAB_DIR}/tmp/pids/ ${GITLAB_DIR}/tmp/sockets/; \
    chown -R git:git /etc/init.d/ ${GITLAB_DIR}/tmp/ /etc/ssh/sshd_config; \
    ln -s /usr/local/bin/ruby /usr/bin/; \
    \
    mkdir -p \
        "${GITLAB_DATA_DIR}" \
        "${GITLAB_BACKUP_DIR}" \
        "${GITLAB_REPOS_DIR}" \
        "${GITLAB_BUILDS_DIR}" \
        "${GITLAB_UPLOADS_DIR}" \
        "${GITLAB_TEMP_DIR}" \
        "${GITLAB_DOWNLOADS_DIR}" \
        "${GITLAB_SHARED_DIR}" \
        "${GITLAB_ARTIFACTS_DIR}" \
        "${GITLAB_LFS_OBJECTS_DIR}" \
        "${GITLAB_PAGES_DIR}" \
        "${GITLAB_REGISTRY_DIR}" \
        "${GITLAB_REGISTRY_CERTS_DIR}"; \
    \
    chown -R git:git "${GITLAB_DATA_DIR}"; \
    \
    rm -rf "${GITLAB_DIR}/shared" "${GITLAB_DIR}/builds"; \
    su-exec git ln -sf "${GITLAB_SHARED_DIR}" "${GITLAB_DIR}/shared"; \
    su-exec git ln -sf "${GITLAB_BUILDS_DIR}" "${GITLAB_DIR}/builds"; \
    su-exec git ln -sf "${GITLAB_UPLOADS_DIR}" "${GITLAB_DIR}/public/uploads"; \
    \
    # Clean up
    apk del --purge .gitlab-build-deps; \
    rm -rf ${GITLAB_DIR}/node_modules; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

ENV EXECJS_RUNTIME "Disabled"

VOLUME ${GITLAB_DATA_DIR}

WORKDIR ${GITLAB_DIR}

COPY templates /etc/gotpl
COPY docker-entrypoint.sh /
COPY actions /usr/local/bin/

USER git

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/etc/init.d/unicorn"]
