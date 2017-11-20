#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

bundle exec unicorn_rails -c config/unicorn.rb -E {{ getenv "RAILS_ENV" }} {{ if (getenv "DEBUG") }}-d{{ end }}