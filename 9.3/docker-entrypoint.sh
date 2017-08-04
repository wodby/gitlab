#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        su-exec git gotpl "/etc/gotpl/$1" > "$2"
    fi
}

exec_init_scripts() {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*.sh; do
        echo "$0: running $f"
        . "$f"
    done
    shopt -u nullglob
}

sudo gitlab-fix-permissions.sh

exec_init_scripts

exec_tpl "unicorn.rb.tpl" "${GITLAB_DIR}/config/unicorn.rb"
exec_tpl "gitlab.yml.tpl" "${GITLAB_DIR}/config/gitlab.yml"
exec_tpl "database.yml.tpl" "${GITLAB_DIR}/config/database.yml"
exec_tpl "resque.yml.tpl" "${GITLAB_DIR}/config/resque.yml"
exec_tpl "gitlab-shell.yml.tpl" "${GITLAB_SHELL_DIR}/config.yml"
exec_tpl "workhorsed.tpl" "/etc/init.d/workhorsed"
exec_tpl "sidekiqd.tpl" "/etc/init.d/sidekiqd"
exec_tpl "mailroomd.tpl" "/etc/init.d/mailroomd"

chmod +x /etc/init.d/workhorsed
chmod +x /etc/init.d/sidekiqd
chmod +x /etc/init.d/mailroomd

if [[ $1 == "make" ]]; then
    su-exec git "${@}" -f /usr/local/bin/actions.mk
else
    exec "${@}"
fi
