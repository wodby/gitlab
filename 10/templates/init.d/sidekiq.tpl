#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ -z "${SIDEKIQ_MEMORY_KILLER_MAX_RSS}" ]]; then
    export SIDEKIQ_MEMORY_KILLER_MAX_RSS=1000000
fi

exec bundle exec sidekiq -c {{ getenv "SIDEKIQ_CONCURRENCY" "25" }} \
  -C "${GITLAB_DIR}/config/sidekiq_queues.yml" \
  -e "${RAILS_ENV}" \
  -t {{ getenv "SIDEKIQ_SHUTDOWN_TIMEOUT" "4" }} \
  -P "${GITLAB_DIR}/tmp/pids/sidekiq.pid" \
  -L /proc/self/fd/2