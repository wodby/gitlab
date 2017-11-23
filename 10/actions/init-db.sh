#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

_ver_compare () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

compare_versions () {
    _ver_compare $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ "${op}" != $3 ]]; then
        echo 1
    else
        echo 0
    fi
}

# Check if db initialized.
case "${DB_ADAPTER}" in
    mysql2)
      query="SELECT count(*) FROM information_schema.tables WHERE table_schema = '${DB_NAME}';"
      count=$(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" "${DB_PASS:+-p$DB_PASS}" -ss -e "${query}")
      ;;
    postgresql)
      query="SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';"
      count=$(PGPASSWORD="${DB_PASS}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -Atw -c "${query}")
      ;;
esac

# DB init for the first run.
if [[ -z "${count}" || "${count}" -eq 0 ]]; then
    echo "Setting up GitLab for the first run..."
    force=yes bundle exec rake gitlab:setup GITLAB_ROOT_PASSWORD="${GITLAB_ROOT_PASSWORD}" GITLAB_ROOT_EMAIL="${GITLAB_ROOT_EMAIL}" >/dev/null
fi

cached_gitlab_ver=

# Migrate database if gitlab version has changed.
if [[ -f "${GITLAB_TEMP_DIR}/VERSION" ]]; then
    cached_gitlab_ver=$(cat "${GITLAB_TEMP_DIR}/VERSION")
fi

if [[ "${GITLAB_VER}" != "${cached_gitlab_ver}" ]]; then
    if [[ -n "${cached_gitlab_ver}" ]]; then
        res=$(compare_versions "${GITLAB_VER}" "${cached_gitlab_ver}" "<")

        if [[ "${res}" == 0 ]]; then
            echo
            echo "ERROR: "
            echo "  Cannot downgrade from GitLab version ${cached_gitlab_ver} to ${GITLAB_VER}."
            echo "  Only upgrades are allowed. Please use ${cached_gitlab_ver} or higher."
            echo "  Cannot continue. Aborting!"
            echo

            exit 1
        else
            echo "Migrating database..."
            bundle exec rake db:migrate >/dev/null
        fi
    fi

    if [[ "${DB_ADAPTER}" == mysql2 ]]; then
        bundle exec rake add_limits_mysql >/dev/null
    fi

    echo "${GITLAB_VER}" > "${GITLAB_TEMP_DIR}/VERSION"
fi