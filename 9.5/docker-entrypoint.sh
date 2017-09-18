#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    gotpl "/etc/gotpl/$1" > "$2"
}

init_sshd() {
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

sudo gitlab-fix-permissions.sh

exec_tpl "unicorn.rb.tpl" "${GITLAB_DIR}/config/unicorn.rb"
exec_tpl "production.rb.tpl" "${GITLAB_DIR}/config/environments/production.rb"
exec_tpl "smtp_settings.rb.tpl" "${GITLAB_DIR}/config/initializers/smtp_settings.rb"

exec_tpl "gitlab.yml.tpl" "${GITLAB_DIR}/config/gitlab.yml"
exec_tpl "database.yml.tpl" "${GITLAB_DIR}/config/database.yml"
exec_tpl "resque.yml.tpl" "${GITLAB_DIR}/config/resque.yml"
exec_tpl "gitlab-shell.yml.tpl" "${GITLAB_SHELL_DIR}/config.yml"

exec_tpl "sidekiqd.tpl" "/etc/init.d/sidekiqd"
exec_tpl "mailroomd.tpl" "/etc/init.d/mailroomd"

mkdir -p "${GITLAB_DATA_DIR}/.secrets"
touch "${GITLAB_DATA_DIR}/.secrets/gitlab_shell_secret"
touch "${GITLAB_DATA_DIR}/.secrets/gitlab_workhorse_secret"

chmod +x /etc/init.d/sidekiqd
chmod +x /etc/init.d/mailroomd

if [[ $1 == "make" ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    if [[ "${@}" == "sudo /usr/sbin/sshd"* ]]; then
        init_sshd
    fi

    exec "${@}"
fi
