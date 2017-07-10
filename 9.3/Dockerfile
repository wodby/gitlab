FROM wodby/ruby:2.3.4

ENV GOTPL_VER 0.1.5
ENV GITLAB_VER 9.3.5
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
        make \
        libressl \
        nodejs \
        openssh \
        postgresql-client \
        python2 \
        libc6-compat \
        su-exec \
        tar \
        wget \
        yarn \
        mariadb-client

RUN apk add --update --no-cache --virtual .gitlab-build-deps \
        autoconf \
        cmake \
        build-base \
        coreutils \
        g++ \
        gdbm-dev \
        go \
        icu-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        ncurses-dev \
        libressl-dev \
        patch \
        postgresql-dev \
        readline-dev \
        yaml-dev \
        zlib-dev \
        mariadb-dev \
        linux-headers \
        libgcrypt-dev \
        sqlite-dev

    # Install Gotpl
RUN wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin

RUN git config --global core.autocrlf input && \
    git config --global gc.auto 0 && \
    git config --global repack.writeBitmaps true

RUN mkdir -p ${GITLAB_DIR} && \
    wget -qO- ${GITLAB_URL} | tar xz --strip-components=1 -C ${GITLAB_DIR} && \
    chown -R git:git ${GITLAB_DIR}

## https://github.com/google/protobuf/issues/2335
RUN cd ${GITLAB_DIR} && \
    chown -R git:git /usr/local/lib/ruby/gems/2.3.0/ && \
    chown -R git:git /usr/local/bundle/ && \
    su-exec git bundle install -j$(nproc) --deployment --verbose --without development aws kerberos
