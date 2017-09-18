#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

# Check if db initialized.
case "${DB_ADAPTER}" in
    mysql2)
      QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = '${DB_NAME}';"
      COUNT=$(mysql -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} ${DB_PASS:+-p$DB_PASS} -ss -e "${QUERY}")
      ;;
    postgresql)
      QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';"
      COUNT=$(PGPASSWORD="${DB_PASS}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -Atw -c "${QUERY}")
      ;;
esac

if [[ -z "${COUNT}" || "${COUNT}" -eq 0 ]]; then
    echo "Setting up GitLab for the first run. Please be patient, this could take a while..."
    force=yes bundle exec rake gitlab:setup GITLAB_ROOT_PASSWORD="${GITLAB_ROOT_PASSWORD}" GITLAB_ROOT_EMAIL="${GITLAB_ROOT_EMAIL}" >/dev/null
fi

# Migrate database if gitlab version has changed.
if [[ -f "${GITLAB_TEMP_DIR}/VERSION" ]]; then
    CACHE_VERSION=$(cat "${GITLAB_TEMP_DIR}/VERSION")
fi

if [[ "${GITLAB_VERSION}" != "${CACHE_VERSION}" ]]; then
    if [[ -n "${CACHE_VERSION}" && $(vercmp "${GITLAB_VERSION}" "${CACHE_VERSION}") -lt 0 ]]; then
        echo
        echo "ERROR: "
        echo "  Cannot downgrade from GitLab version ${CACHE_VERSION} to ${GITLAB_VERSION}."
        echo "  Only upgrades are allowed. Please use ${CACHE_VERSION} or higher."
        echo "  Cannot continue. Aborting!"
        echo
        return 1
    fi

    echo "Migrating database..."
    bundle exec rake db:migrate >/dev/null

    if [[ "${DB_ADAPTER}" == mysql2 ]]; then
        bundle exec rake add_limits_mysql >/dev/null
    fi

    echo "${GITLAB_VERSION}" > "${GITLAB_TEMP_DIR}/VERSION"
fi