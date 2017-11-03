#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

gitlab-pages -pages-domain "{{ getenv "GITLAB_PAGES_DOMAIN" }}" -pages-root "{{ getenv "GITLAB_PAGES_DIR" }}" -listen-proxy :8090