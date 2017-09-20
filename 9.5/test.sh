#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

run_action() {
    docker-compose -f test/docker-compose.yml exec gitlab make "${@}" -f /usr/local/bin/actions.mk
}

docker-compose -f test/docker-compose.yml up

run_action check-ready delay_seconds=5 max_try=25
run_action init-data-dir
run_action migrate-database

#docker-compose -f test/docker-compose.yml exec nginx make check-ready -f /usr/local/bin/actions.mk
#docker-compose -f test/docker-compose.yml down
