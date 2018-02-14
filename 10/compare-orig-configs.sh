#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

gitlab_ver=$1

url="https://gitlab.com/gitlab-org"
gitlab_url="${url}/gitlab-ce/raw/v${gitlab_ver}"
gitlab_config_url="${url}/gitlab-ce/raw/v${gitlab_ver}/config"

gitaly_ver=$(wget -qO- "${gitlab_url}/GITALY_SERVER_VERSION")
gitlab_shell_ver=$(wget -qO- "${gitlab_url}/GITLAB_SHELL_VERSION")

array=(
    "gitlab/database.yml.postgresql::${gitlab_config_url}/database.yml.postgresql"
    "gitlab/gitlab.yml.example::${gitlab_config_url}/gitlab.yml.example"
    "gitlab/resque.yml.example::${gitlab_config_url}/resque.yml.example"
    "gitlab/secrets.yml.example::${gitlab_config_url}/secrets.yml.example"
    "gitlab/unicorn.rb.example::${gitlab_config_url}/unicorn.rb.example"
    "gitlab/initializers/smtp_settings.rb.sample::${gitlab_config_url}/initializers/smtp_settings.rb.sample"
    "gitlab/environments/production.rb::${gitlab_config_url}/environments/production.rb"
    "gitaly/config.toml.example::${url}/gitaly/raw/v${gitaly_ver}/config.toml.example"
    "gitlab-shell/config.yml.example::${url}/gitlab-shell/raw/v${gitlab_shell_ver}/config.yml.example"
)

outdated=0

for index in "${array[@]}" ; do
    local="${index%%::*}"
    remote="${index##*::}"

    md5_local=$(cat "orig/${local}" | md5)
    md5_remote=$(wget -qO- "${remote}" | md5)

    echo "Checking ${local}"

    if [[ "${md5_local}" != "${md5_remote}" ]]; then
        echo "!!! OUTDATED"
        echo "SEE ${remote}"
        outdated=1
    else
        echo "OK"
    fi
done

[[ "${outdated}" == 0 ]] || exit 1