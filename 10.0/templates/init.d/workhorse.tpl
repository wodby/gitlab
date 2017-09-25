#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec gitlab-workhorse \
  -listenUmask 0 \
  -listenNetwork tcp \
  -listenAddr "0.0.0.0:8181" \
  -authBackend http://{{ getenv "WORKHORSE_BACKEND_HOST" "gitlab" }}:{{ getenv "WORKHORSE_BACKEND_PORT" "8080" }} \
  -documentRoot {{ getenv "GITLAB_PUBLIC_DIR" }} \
  -proxyHeadersTimeout {{ getenv "WORKHORSE_TIMEOUT" "5m0s" }} \
  -secretPath {{ getenv "GITLAB_DIR" }}/.gitlab_workhorse_secret \
  -logFile "/proc/self/fd/2" \
  -config workhorse.toml