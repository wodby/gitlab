.PHONY: init-data-dir init-db backup restore check-ready check-live

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
command ?= curl -s ${host}:8080/-/readiness | grep -qvP '\"status\":(?!\"ok\")'

default: check-ready

init-data-dir:
	init-data-dir.sh

init-db:
	init-db.sh

backup:
	backup.sh $(skip)

restore:
	$(call check_defined, timestamp)
	restore.sh $(timestamp)

check-ready:
	# Health check on application server without initialized db breaks the app.
	@echo "OK"

readiness:
	# Instead check for GitLab app readiness.
	wait-for.sh "$(command)" "GitLab" $(host) $(max_try) $(wait_seconds) $(delay_seconds)
