#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ -z "${SIDEKIQ_MEMORY_KILLER_MAX_RSS}" ]]; then
    export SIDEKIQ_MEMORY_KILLER_MAX_RSS=1000000
fi

bundle exec sidekiq -c {{ getenv "SIDEKIQ_CONCURRENCY" "25" }} {{ if (getenv "DEBUG") }}-d{{ end }} \
  -C {{ getenv "GITLAB_DIR" }}/config/sidekiq_queues.yml \
  -e {{ getenv "RAILS_ENV" }} \
  -t {{ getenv "SIDEKIQ_SHUTDOWN_TIMEOUT" "4" }} \
  -P {{ getenv "GITLAB_DIR" }}/tmp/pids/sidekiq.pid \
  -L /proc/self/fd/2