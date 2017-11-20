#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
    debug_flags="-d"
fi

bundle exec unicorn_rails -c config/unicorn.rb -E "${RAILS_ENV}" "${debug_flags}"