.PHONY: init-data-dir migrate-database check-ready check-live

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0

default: check-ready

init-data-dir:
	init-data-dir.sh

migrate-database:
	migrate-database.sh

check-ready:
	wait-for-unicorn.sh $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
