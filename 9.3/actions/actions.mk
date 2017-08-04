.PHONY: init-data-dir migrate-database check-ready check-live

default: check-ready

init-data-dir:
	init-data-dir.sh

migrate-database:
	migrate-database.sh

check-ready:
	exit 0

check-live:
	@echo "OK"
