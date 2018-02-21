.PHONY: init-data-dir init-db backup restore check-ready check-live gitlab-readiness gitlab-liveness

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
gitlab_readiness_cmd ?= curl -s ${host}:8080/-/readiness | grep -qvP '\"status\":(?!\"ok\")'
gitlab_liveness_cmd ?= curl -s ${host}:8080/-/liveness | grep -qvP '\"status\":(?!\"ok\")'

default: check-ready

init-data-dir:
	init_data_dir

init-db:
	init_db

backup:
	backup $(skip)

restore:
	$(call check_defined, timestamp)
	restore $(timestamp)

check-ready:
	# Health check on application server without initialized db breaks the app.
	@echo "OK"

check-live:
	@echo "OK"

gitlab-readiness:
	wait-for.sh "$(gitlab_readiness_cmd)" "GitLab" $(host) $(max_try) $(wait_seconds) $(delay_seconds)

gitlab-liveness:
	wait-for.sh "$(gitlab_liveness_cmd)" "GitLab" $(host) $(max_try) $(wait_seconds) $(delay_seconds)
