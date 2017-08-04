FROM wodby/ruby:2.3.4

ENV GOTPL_VER 0.1.5
ENV GITLAB_VER 9.3.6
ENV GITLAB_SHELL_VER 5.1.1
ENV GITLAB_WORKHORSE_VER 2.1.1
ENV GITLAB_PAGES_VER 0.4.3
ENV GITLAB_GITALY_VER 0.11.2

ENV GITLAB_USER git
ENV GITLAB_HOME "/home/git"

ENV GITLAB_DIR "${GITLAB_HOME}/gitlab"
ENV GITLAB_SHELL_DIR "${GITLAB_HOME}/gitlab-shell"
ENV GITLAB_WORKHORSE_DIR "${GITLAB_HOME}/gitlab-workhorse"
ENV GITLAB_PAGES_DIR "${GITLAB_HOME}/gitlab-pages"
ENV GITLAB_GITALY_DIR "${GITLAB_HOME}/gitaly"

ENV GITLAB_DATA_DIR "${GITLAB_HOME}/data"

ENV _BASE_URL https://gitlab.com/gitlab-org

ENV GITLAB_URL ${_BASE_URL}/gitlab-ce/repository/archive.tar.gz?ref=v${GITLAB_VER}
ENV GITLAB_SHELL_URL ${_BASE_URL}/gitlab-shell/repository/archive.tar.gz?ref=v${GITLAB_SHELL_VER}
ENV GITLAB_WORKHORSE_URL ${_BASE_URL}/gitlab-workhorse/repository/archive.tar.gz?ref=v${GITLAB_WORKHORSE_VER}
ENV GITLAB_PAGES_URL ${_BASE_URL}/gitlab-pages/repository/archive.tar.gz?ref=v${GITLAB_PAGES_VER}
ENV GITLAB_GITALY_URL ${_BASE_URL}/gitaly/repository/archive.tar.gz?ref=v${GITLAB_GITALY_VER}

ENV GOTPL_URL https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz

RUN set -xe && \

    addgroup -g 1000 -S git && \
	adduser -u 1000 -D -S -s /bin/bash -G git ${GITLAB_USER} && \
	sed -i '/^${GITLAB_USER}/s/!/*/' /etc/shadow && \

    apk add --update --no-cache --virtual .gitlab-rundeps \
        bash \
        ca-certificates \
        git \
        gzip \
        libc6-compat \
        libressl \
        make \
        mariadb-client \
        nodejs \
        openssh \
        postgresql-client \
        python2 \
        su-exec \
        tar \
        tzdata \
        wget \
        yarn

RUN apk add --update --no-cache --virtual .gitlab-build-deps \
        autoconf \
        build-base \
        cmake \
        coreutils \
        g++ \
        gdbm-dev \
        go \
        icu-dev \
        libffi-dev \
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
        zlib-dev

    # Install Gotpl
RUN wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin && \

    git config --global core.autocrlf input && \
    git config --global gc.auto 0 && \
    git config --global repack.writeBitmaps true && \

    # Download GitLab
    mkdir -p ${GITLAB_DIR} && \
    wget -qO- ${GITLAB_URL} | tar xz --strip-components=1 -C ${GITLAB_DIR} && \
    chown -R git:git ${GITLAB_DIR} && \

    cd ${GITLAB_DIR} && \
    chown -R git:git /usr/local/lib/ruby/gems/2.3.0/ && \
    chown -R git:git /usr/local/bundle/

RUN cd ${GITLAB_DIR} && \
    su-exec git bundle install -j$(nproc) --no-deployment --verbose --without development aws kerberos

RUN cd ${GITLAB_DIR} && \
    # https://github.com/google/protobuf/issues/2335#issuecomment-286283645
    sed -i "/gem 'gitaly/i \gem 'google-protobuf', '3.2.0'" Gemfile && \
    su-exec git bundle update google-protobuf --verbose

    # Install gems
RUN cd ${GITLAB_DIR} && \
    export BUNDLE_FORCE_RUBY_PLATFORM=1 && \
    su-exec git bundle install -j$(nproc) --deployment --verbose --without development aws kerberos

RUN cd ${GITLAB_DIR} && \
    su-exec git cp config/resque.yml.example config/resque.yml && \
    su-exec git cp config/database.yml.postgresql config/database.yml && \
    su-exec git cp config/gitlab.yml.example config/gitlab.yml && \
    su-exec git yarn install --production --pure-lockfile

ENV GITLAB_SHELL_DIR "${GITLAB_HOME}/gitlab-shell"

ENV GITLAB_SHELL_URL https://gitlab.com/gitlab-org/gitlab-shell/repository/archive.tar.gz?ref=v${GITLAB_SHELL_VER}

    # Install gitlab shell
RUN mkdir -p ${GITLAB_SHELL_DIR} && \
    wget -qO- ${GITLAB_SHELL_URL} | tar xz --strip-components=1 -C ${GITLAB_SHELL_DIR} && \
    cd ${GITLAB_SHELL_DIR} && \
    cp config.yml.example config.yml && \
    chown -R ${GITLAB_USER}: ${GITLAB_SHELL_DIR} && \

    su-exec git ./bin/compile && \
    su-exec git ./bin/install && \

    sed -i \
      -e "s|^[#]*UsePAM yes|UsePAM no|" \
      -e "s|^[#]*UsePrivilegeSeparation yes|UsePrivilegeSeparation no|" \
      -e "s|^[#]*PasswordAuthentication yes|PasswordAuthentication no|" \
      -e "s|^[#]*LogLevel INFO|LogLevel VERBOSE|" \
      /etc/ssh/sshd_config && \
    echo "UseDNS no" >> /etc/ssh/sshd_config

ENV RAILS_ENV production
ENV NODE_ENV production

RUN cd ${GITLAB_DIR} && \
    rm -rf ${GITLAB_HOME}/repositories && \
    chown -R ${GITLAB_USER}: ${GITLAB_HOME} && \
    su-exec git sed -i 's/db:reset/db:setup/' ${GITLAB_DIR}/lib/tasks/gitlab/setup.rake && \
    su-exec git bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true

ENV GITLAB_DATA_DIR /mnt/data
#ENV GITLAB_LOG_DIR /var/log/gitlab

# WORKAROUND for https://github.com/sameersbn/docker-gitlab/issues/509
RUN rm -rf ${GITLAB_DIR}/builds && \
    rm -rf ${GITLAB_DIR}/shared

RUN apk add --update icu-libs sudo && \

    { \
		echo "sudo chown -R git:git ${GITLAB_DATA_DIR}" ; \
		echo "sudo chown -R git:git ${GITLAB_DIR}/config" ; \
		echo "sudo chown git:git ${GITLAB_SHELL_DIR}/config.yml" ; \
	} | tee /usr/local/bin/gitlab-fix-permissions.sh && \

	chmod +x /usr/local/bin/gitlab-fix-permissions.sh && \

    echo 'git ALL=(root) NOPASSWD: /usr/local/bin/gitlab-fix-permissions.sh' > /etc/sudoers.d/git

RUN mkdir -p ${GITLAB_WORKHORSE_DIR} && \
    wget -qO- ${GITLAB_WORKHORSE_URL} | tar xz --strip-components=1 -C ${GITLAB_WORKHORSE_DIR} && \
    cd ${GITLAB_WORKHORSE_DIR} && \
    make install && \

    apk del .gitlab-build-deps

ENV GITLAB_TEMP_DIR="${GITLAB_DATA_DIR}/tmp" \
    GITLAB_BACKUP_DIR="${GITLAB_DATA_DIR}/backups" \
    GITLAB_REPOS_DIR="${GITLAB_DATA_DIR}/repositories" \
    GITLAB_BUILDS_DIR="${GITLAB_DATA_DIR}/builds" \
    GITLAB_DOWNLOADS_DIR="${GITLAB_TEMP_DIR}/downloads" \
    GITLAB_SHARED_DIR="${GITLAB_DATA_DIR}/shared" \
    GITLAB_LFS_OBJECTS_DIR="${GITLAB_SHARED_DIR}/lfs-objects" \
    GITLAB_REGISTRY_DIR="${GITLAB_SHARED_DIR}/registry" \
    GITLAB_PUBLIC_DIR="${GITLAB_PUBLIC_DIR}/public" \
    GITLAB_ARTIFACTS_DIR="${GITLAB_SHARED_DIR}/artifacts"

VOLUME ${GITLAB_DATA_DIR}

WORKDIR ${GITLAB_DIR}

COPY templates /etc/gotpl
COPY docker-entrypoint.sh /
COPY init /docker-entrypoint-init.d/
COPY actions /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bundle", "exec", "unicorn_rails", "-c", "config/unicorn.rb", "-E", "production"]
