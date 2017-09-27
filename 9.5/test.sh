#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

run_action() {
    docker-compose -f test/docker-compose.yml exec "${1}" make "${@:2}" -f /usr/local/bin/actions.mk
}

docker-compose -f test/docker-compose.yml up -d

run_action redis check-ready max_try=10
run_action postgres check-ready delay_seconds=5 wait_seconds=3 max_try=10
run_action gitlab check-ready delay_seconds=10 wait_seconds=5 max_try=10
run_action nginx check-ready max_try=10

run_action gitlab init-data-dir
run_action gitlab migrate-database

docker-compose -f test/docker-compose.yml down
