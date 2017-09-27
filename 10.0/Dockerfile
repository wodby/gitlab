FROM wodby/ruby:2.3.5

ENV GOTPL_VER="0.1.5" \
    GITLAB_VER="10.0.1" \
    GITLAB_DATA_DIR="/mnt/data" \
    RAILS_ENV="production" \
    NODE_ENV="production"

ENV GITLAB_DIR="/home/git/gitlab" \
    GITLAB_SHELL_DIR="/home/git/gitlab-shell" \

    GITLAB_BACKUP_DIR="${GITLAB_DATA_DIR}/backups" \
    GITLAB_REPOS_DIR="${GITLAB_DATA_DIR}/repositories" \
    GITLAB_BUILDS_DIR="${GITLAB_DATA_DIR}/builds" \
    GITLAB_PUBLIC_DIR="${GITLAB_DATA_DIR}/public" \

    # Temporary
    GITLAB_TEMP_DIR="${GITLAB_DATA_DIR}/tmp" \
    GITLAB_DOWNLOADS_DIR="${GITLAB_DATA_DIR}/tmp/downloads" \

    # Shared
    GITLAB_SHARED_DIR="${GITLAB_DATA_DIR}/shared" \
    GITLAB_LFS_OBJECTS_DIR="${GITLAB_DATA_DIR}/shared/lfs-objects" \
    GITLAB_REGISTRY_DIR="${GITLAB_DATA_DIR}/shared/registry" \
    GITLAB_ARTIFACTS_DIR="${GITLAB_DATA_DIR}/shared/artifacts" \

    GITLAB_URL="https://gitlab.com/gitlab-org/gitlab-ce/repository/archive.tar.gz?ref=v${GITLAB_VER}" \
    GITLAB_PAGES_URL="https://gitlab.com/gitlab-org/gitlab-pages/repository/archive.tar.gz" \
    GOTPL_URL="https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz"

RUN set -xe && \

    addgroup -g 1000 -S git && \
	adduser -u 1000 -D -S -s /bin/bash -G git git && \
	sed -i '/^git/s/!/*/' /etc/shadow && \

    apk add --update --no-cache --virtual .gitlab-rundeps \
        bash \
        ca-certificates \
        curl \
        git \
        gzip \
        icu-libs \
        libc6-compat \
        libre2 \
        libressl \
        make \
        mariadb-client \
        nodejs \
        openssh \
        postgresql-client \
        python2 \
        rsync \
        su-exec \
        sudo \
        tar \
        tzdata \
        wget \
        yarn && \

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
        patch \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        yaml-dev \
        zlib-dev && \

    apk add --update redis && \

    # Download gitlab.
    mkdir -p ${GITLAB_DIR} && \
    wget -qO- ${GITLAB_URL} | tar xz --strip-components=1 -C ${GITLAB_DIR} && \
    chown -R git:git ${GITLAB_DIR} && \

    cd ${GITLAB_DIR} && \
    su-exec git cp config/database.yml.postgresql config/database.yml && \
    su-exec git cp config/gitlab.yml.example config/gitlab.yml && \

    chown -R git:git /usr/local/lib/ruby/gems/2.3.0/ && \
    chown -R git:git /usr/local/bundle/ && \

    # Install gems (build from source).
    export BUNDLE_FORCE_RUBY_PLATFORM=1 && \
    su-exec git bundle install -j$(nproc) --deployment --verbose --without development aws kerberos && \

    # Compile assets
    su-exec git yarn install --production --pure-lockfile && \
    # webpack issue workaround https://gitlab.com/gitlab-org/gitlab-ce/issues/38275
    su-exec git yarn add ajv@^4.0.0 && \
    su-exec git bundle exec rake gitlab:assets:compile && \

    # PO files
    su-exec git bundle exec rake gettext:pack && \
    su-exec git bundle exec rake gettext:po_to_json && \

    # Install gitlab shell.
    su-exec git bundle exec rake gitlab:shell:install REDIS_URL=redis:6379 SKIP_STORAGE_VALIDATION=true && \

    # Install gitlab pages.
    gitlab_pages_version=$(cat "${GITLAB_DIR}/GITLAB_PAGES_VERSION") && \
    wget -qO- "${GITLAB_PAGES_URL}?ref=v${gitlab_pages_version}" | tar xz -C /tmp/ && \
    export GOPATH="/tmp/go" && \
    mkdir -p "/tmp/go/src/gitlab.com/gitlab-org" && \
    ln -s /tmp/gitlab-pages* "$GOPATH/src/gitlab.com/gitlab-org/gitlab-pages" && \
    cd "$GOPATH/src/gitlab.com/gitlab-org/gitlab-pages" && \
    make && \
    mv gitlab-pages /usr/local/bin && \

    # Install workhorse
    cd ${GITLAB_DIR} && \
    su-exec git bundle exec rake "gitlab:workhorse:install[/tmp/workhorse]" && \
    mv /tmp/workhorse/gitlab-workhorse /usr/local/bin && \

    # Install gitaly (build gems from source)
    export BUNDLE_FORCE_RUBY_PLATFORM=1 && \
    su-exec git bundle exec rake "gitlab:gitaly:install[/tmp/gitaly]" && \
    mv /tmp/gitaly/gitaly /usr/local/bin && \
    mv /tmp/gitaly/ruby /home/git/gitaly-ruby && \

    # Gotpl
    wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin && \

    cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb && \
    rm config/secrets.yml && \

    su-exec git sed -i 's/db:reset/db:setup/' ${GITLAB_DIR}/lib/tasks/gitlab/setup.rake && \

    # Configure git
    git config --global core.autocrlf input && \
    git config --global gc.auto 0 && \
    git config --global repack.writeBitmaps true && \

    # Leave only redis-cli from redis package
    cp /usr/bin/redis-cli /usr/bin/redis && \
    ln -s /usr/local/bin/ruby /usr/bin/ && \

    # SSHd config
    sed -i "s|^[#]*HostKey /etc/ssh/|HostKey ${GITLAB_DATA_DIR}/ssh/|g" /etc/ssh/sshd_config && \
    sed -i '/PermitUserEnvironment/c\PermitUserEnvironment yes' /etc/ssh/sshd_config && \
    sed -i \
      -e "s|^[#]*UsePAM yes|UsePAM no|" \
      -e "s|^[#]*UsePrivilegeSeparation yes|UsePrivilegeSeparation no|" \
      -e "s|^[#]*PasswordAuthentication yes|PasswordAuthentication no|" \
      -e "s|^[#]*LogLevel INFO|LogLevel VERBOSE|" \
      /etc/ssh/sshd_config && \
    echo "UseDNS no" >> /etc/ssh/sshd_config && \

    # Fix permissions script.
    { \
        echo "sudo chown -R git:git ${GITLAB_DATA_DIR}" ; \
        echo "sudo chown -R git:git ${GITLAB_DIR}/config" ; \
        echo "sudo chown git:git ${GITLAB_SHELL_DIR}/config.yml" ; \
    } | tee /usr/local/bin/gitlab-fix-permissions.sh && \
    chmod +x /usr/local/bin/gitlab-fix-permissions.sh && \
    echo 'git ALL=(root) NOPASSWD: /usr/local/bin/gitlab-fix-permissions.sh, /usr/sbin/sshd' > /etc/sudoers.d/git && \

    rm -rf "/home/git/.ssh" && \
    ln -sf "${GITLAB_DATA_DIR}/.ssh" "/home/git/.ssh" && \

    # Prepare directories
    mkdir -p ${GITLAB_DIR}/tmp/pids/ ${GITLAB_DIR}/tmp/sockets/ && \
    chown -R git:git /etc/init.d/ ${GITLAB_DIR}/tmp/ && \

    apk del --purge .gitlab-build-deps && \
    apk del --purge redis && \
    rm -rf /tmp/*

VOLUME ${GITLAB_DATA_DIR}

WORKDIR ${GITLAB_DIR}

COPY templates /etc/gotpl
COPY docker-entrypoint.sh /
COPY actions /usr/local/bin/

USER git

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bundle", "exec", "unicorn_rails", "-c", "config/unicorn.rb", "-E", "production"]
