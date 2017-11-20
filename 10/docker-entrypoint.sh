#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    gotpl "/etc/gotpl/$1" > "$2"
}

init_sshd() {
    local ssh_dir="${GITLAB_DATA_DIR}/.ssh"

    mkdir -p "${ssh_dir}"
    touch "${ssh_dir}/authorized_keys"
    chmod 700 "${ssh_dir}"
    chmod 600 "${ssh_dir}/authorized_keys"

    printenv | xargs -I{} echo {} | awk ' \
        BEGIN { FS = "=" }; { \
            if ($1 != "HOME" \
                && $1 != "PWD" \
                && $1 != "PATH" \
                && $1 != "SHLVL") { \
                \
                print ""$1"="$2"" \
            } \
        }' > "${ssh_dir}/environment"

    if [[ ! -e "${GITLAB_DATA_DIR}/ssh/ssh_host_rsa_key" ]]; then
        sudo sshd-generate-keys.sh "${GITLAB_DATA_DIR}/ssh"
    fi

    exec_tpl "sshd_config.tpl" "/etc/ssh/sshd_config"
}

process_templates() {
    exec_tpl "gitlab.yml.tpl" "${GITLAB_DIR}/config/gitlab.yml"
    exec_tpl "unicorn.rb.tpl" "${GITLAB_DIR}/config/unicorn.rb"
    exec_tpl "production.rb.tpl" "${GITLAB_DIR}/config/environments/production.rb"
    exec_tpl "smtp_settings.rb.tpl" "${GITLAB_DIR}/config/initializers/smtp_settings.rb"
    exec_tpl "database.yml.tpl" "${GITLAB_DIR}/config/database.yml"
    exec_tpl "resque.yml.tpl" "${GITLAB_DIR}/config/resque.yml"
    exec_tpl "secrets.yml.tpl" "${GITLAB_DIR}/config/secrets.yml"

    exec_tpl "gitaly.toml.tpl" "${GITALY_DIR}/gitaly.toml"
    exec_tpl "gitlab-shell.yml.tpl" "${GITLAB_SHELL_DIR}/config.yml"
    exec_tpl "workhorse.toml.tpl" "${GITLAB_DIR}/workhorse.toml"

    declare -a services=(
        unicorn
        gitaly
        mailroom
        sidekiq
        workhorse
        pages
    )

    for svc in "${services[@]}"; do
        exec_tpl "init.d/${svc}.tpl" "/etc/init.d/${svc}"
        chmod +x "/etc/init.d/${svc}"
    done
}

process_secrets() {
    if [[ -n "${GITLAB_SECRETS_SHELL}" ]]; then
        echo "${GITLAB_SECRETS_SHELL}" > "${GITLAB_DIR}/.gitlab_shell_secret"
        chmod 600 "${GITLAB_DIR}/.gitlab_shell_secret"
    fi

    if [[ -n "${GITLAB_SECRETS_WORKHORSE}" ]]; then
        echo "${GITLAB_SECRETS_WORKHORSE}" > "${GITLAB_DIR}/.gitlab_workhorse_secret"
        chmod 600 "${GITLAB_DIR}/.gitlab_workhorse_secret"
    fi
}

sudo fix-permissions.sh git git "${GITLAB_DATA_DIR}"

process_templates
process_secrets

mkdir -p "${GITLAB_REPOS_DIR}"

if [[ $1 == "make" ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    if [[ "${1} ${2}" == "sudo /usr/sbin/sshd" ]]; then
        init_sshd
    fi

    exec "${@}"
fi
