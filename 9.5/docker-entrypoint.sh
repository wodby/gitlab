#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    gotpl "/etc/gotpl/$1" > "$2"
}

init_sshd() {
    mkdir -p "${GITLAB_DATA_DIR}/.ssh"
    touch "${GITLAB_DATA_DIR}/.ssh/authorized_keys"
    chmod 700 "${GITLAB_DATA_DIR}/.ssh"
    chmod 600 "${GITLAB_DATA_DIR}/.ssh/authorized_keys"

    # Make sure ~/.ssh symlink won't be broken.
    mkdir -p "${GITLAB_DATA_DIR}/.ssh"

    # Env vars for SSH sessions.
    printenv | xargs -I{} echo {} | awk ' \
        BEGIN { FS = "=" }; { \
            if ($1 != "HOME" \
                && $1 != "PWD" \
                && $1 != "PATH" \
                && $1 != "SHLVL") { \
                \
                print ""$1"="$2"" \
            } \
        }' > /home/git/.ssh/environment

    if [[ ! -e "${GITLAB_DATA_DIR}/ssh/ssh_host_rsa_key" ]]; then
        echo -n "Generating OpenSSH host keys... "
        mkdir -p "${GITLAB_DATA_DIR}/ssh"
        ssh-keygen -qt rsa -N '' -f "${GITLAB_DATA_DIR}/ssh/ssh_host_rsa_key"
        ssh-keygen -qt dsa -N '' -f "${GITLAB_DATA_DIR}/ssh/ssh_host_dsa_key"
        ssh-keygen -qt ecdsa -N '' -f "${GITLAB_DATA_DIR}/ssh/ssh_host_ecdsa_key"
        ssh-keygen -qt ed25519 -N '' -f "${GITLAB_DATA_DIR}/ssh/ssh_host_ed25519_key"
        chmod 0600 ${GITLAB_DATA_DIR}/ssh/*_key
        chmod 0644 ${GITLAB_DATA_DIR}/ssh/*.pub
        echo "OK"
    fi
}

process_templates() {
    exec_tpl "unicorn.rb.tpl" "${GITLAB_DIR}/config/unicorn.rb"
    exec_tpl "production.rb.tpl" "${GITLAB_DIR}/config/environments/production.rb"
    exec_tpl "smtp_settings.rb.tpl" "${GITLAB_DIR}/config/initializers/smtp_settings.rb"

    exec_tpl "database.yml.tpl" "${GITLAB_DIR}/config/database.yml"
    exec_tpl "gitaly.toml.tpl" "${GITLAB_GITALY_DIR}/config.toml"
    exec_tpl "gitlab.yml.tpl" "${GITLAB_DIR}/config/gitlab.yml"
    exec_tpl "gitlab-shell.yml.tpl" "${GITLAB_SHELL_DIR}/config.yml"
    exec_tpl "resque.yml.tpl" "${GITLAB_DIR}/config/resque.yml"
    exec_tpl "secrets.yml.tpl" "${GITLAB_DIR}/config/secrets.yml"
    exec_tpl "workhorse.toml.tpl" "${GITLAB_WORKHORSE_DIR}/config.toml"

    exec_tpl "init.d/gitaly.tpl" "/etc/init.d/gitaly"
    exec_tpl "init.d/mailroom.tpl" "/etc/init.d/mailroom"
    exec_tpl "init.d/sidekiq.tpl" "/etc/init.d/sidekiq"
    exec_tpl "init.d/workhorse.tpl" "/etc/init.d/workhorse"
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

sudo gitlab-fix-permissions.sh

process_templates
process_secrets

chmod +x /etc/init.d/*
mkdir -p "${GITLAB_REPOS_DIR}"

if [[ $1 == "make" ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    if [[ "${@}" == "sudo /usr/sbin/sshd"* ]]; then
        init_sshd
    fi

    exec "${@}"
fi
