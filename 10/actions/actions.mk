.PHONY: init-data-dir migrate-database backup restore check-ready check-live

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command ?= curl -s -o /dev/null -I -w '%{http_code}' ${host}:8080 | grep -q 302

default: check-ready

init-data-dir:
	init-data-dir.sh

migrate-database:
	migrate-database.sh

backup:
	backup.sh $(skip)

restore:
	$(call check_defined, timestamp)
	restore.sh $(timestamp)

check-ready:
	wait-for.sh "$(command)" "Unicorn" $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
