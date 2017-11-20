#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

gitlab-workhorse \
  -listenUmask 0 \
  -listenNetwork tcp \
  -listenAddr "0.0.0.0:8181" \
  -authBackend http://{{ getenv "WORKHORSE_BACKEND_HOST" "gitlab" }}:{{ getenv "WORKHORSE_BACKEND_PORT" "8080" }} \
  -documentRoot {{ getenv "GITLAB_DIR" }}/public \
  -proxyHeadersTimeout {{ getenv "WORKHORSE_TIMEOUT" "5m0s" }} \
  -secretPath {{ getenv "GITLAB_DIR" }}/.gitlab_workhorse_secret \
  -logFile "/proc/self/fd/2" \
  -config {{ getenv "GITLAB_DIR"}}/workhorse.toml