.PHONY: init-data-dir migrate-database check-ready check-live

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command ?= curl -s "${host}:8080" &> /dev/null
service ?= "Unicorn"

default: check-ready

init-data-dir:
	init-data-dir.sh

migrate-database:
	migrate-database.sh

check-ready:
	wait-for.sh "$(command)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
