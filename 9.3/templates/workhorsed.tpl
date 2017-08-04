#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec gitlab-workhorse \
  -listenUmask 0 \
  -listenNetwork tcp \
  -listenAddr ":8181" \
  -authBackend http://{{ getenv "GITLAB_BACKEND_HOST" "gitlab" }}:{{ getenv "GITLAB_BACKEND_PORT" "8080" }} \
  -documentRoot "${GITLAB_PUBLIC_DIR}" \
  -proxyHeadersTimeout {{ getenv "GITLAB_WORKHORSE_TIMEOUT" "5m0s" }}