#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose -f test/docker-compose.yml up -d
docker-compose -f test/docker-compose.yml exec postgres make check-ready delay_seconds=5 max_try=25 -f /usr/local/bin/actions.mk
docker-compose -f test/docker-compose.yml exec gitlab make migrate-database -f /usr/local/bin/actions.mk
#docker-compose -f test/docker-compose.yml exec nginx make check-ready -f /usr/local/bin/actions.mk
#docker-compose -f test/docker-compose.yml down
