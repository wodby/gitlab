# GitLab CE Docker Container Image 

[![Build Status](https://travis-ci.org/wodby/gitlab.svg?branch=master)](https://travis-ci.org/wodby/gitlab)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/gitlab.svg)](https://hub.docker.com/r/wodby/gitlab)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/gitlab.svg)](https://hub.docker.com/r/wodby/gitlab)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

* All images are based on Alpine Linux
* Base image: [wodby/ruby](https://github.com/wodby/ruby)
* [Travis CI builds](https://travis-ci.org/wodby/gitlab) 
* [Docker Hub](https://hub.docker.com/r/wodby/gitlab)

For better reliability we release images with stability tags (`wodby/gitlab:10.1-X.X.X`) which correspond to git tags. We **strongly recommend** using images only with stability tags. Below listed basic tags:

| Image tag (Dockerfile)                                                              | GitLab |
| ----------------------------------------------------------------------------------- | ------ |
| [10, 10.2, 10.2.2 (latest)](https://github.com/wodby/gitlab/tree/master/Dockerfile) | 10.2.2 |
| [10, 10.1, 10.1.4](https://github.com/wodby/gitlab/tree/master/Dockerfile)          | 10.1.4 |

## Environment Variables

| Variable                                  | Default Value                         | Description  |
| ----------------------------------------- | ------------------------------------- | ------------ |
| DB_ADAPTER                                | postgresql                            |              |
| DB_HOST                                   | postgres                              |              |
| DB_NAME                                   | gitlab                                |              |
| DB_PASS                                   | gitlab                                |              |
| DB_PORT                                   | 5432                                  |              |
| DB_USER                                   | gitlab                                |              |
| GITLAB_ARTIFACTS_ENABLED                  | true                                  |              |
| GITLAB_BACKUP_ARCHIVE_PERMISSION          | 0640                                  |              |
| GITLAB_BACKUP_AWS_UPLOAD_REGION           | eu-west-1                             |              |
| GITLAB_BACKUP_KEEP_TIME                   | 604800                                |              |
| GITLAB_BACKUP_PG_SCHEMA                   | public                                |              |
| GITLAB_BACKUP_UPLOAD_ACCESS_KEY_ID        |                                       |              |
| GITLAB_BACKUP_UPLOAD_ENCRYPTION           | AES256                                |              |
| GITLAB_BACKUP_UPLOAD_MULTIPART_CHUNK_SIZE | 104857600                             |              |
| GITLAB_BACKUP_UPLOAD_PROVIDER             |                                       | AWS / Google |
| GITLAB_BACKUP_UPLOAD_REMOTE_DIRECTORY     |                                       |              |
| GITLAB_BACKUP_UPLOAD_SECRET_ACCESS_KEY    |                                       |              |
| GITLAB_BACKUP_UPLOAD_STORAGE_CLASS        | STANDARD                              |              |
| GITLAB_CDN_HOST                           |                                       |              |
| GITLAB_CI_ADD_PUSHER                      | true                                  |              |
| GITLAB_CI_ALL_BROKEN_BUILDS               | true                                  |              |
| GITLAB_CI_BUILDS_PATH                     | builds/                               |              |
| GITLAB_EMAIL_DISPLAY_NAME                 | GitLab                                |              |
| GITLAB_EMAIL_ENABLED                      | true                                  |              |
| GITLAB_EMAIL_FROM                         | gitlab@example.com                    |              |
| GITLAB_EMAIL_REPLY_TO                     | noreply@example.com                   |              |
| GITLAB_EMAIL_SUBJECT_SUFFIX               |                                       |              |
| GITLAB_HOST                               | localhost                             |              |
| GITLAB_HTTPS                              | false                                 |              |
| GITLAB_INCOMING_EMAIL                     | false                                 |              |
| GITLAB_INCOMING_EMAIL_ADDRESS             | gitlab-incoming+%{key}@gmail.com      |              |
| GITLAB_INCOMING_EMAIL_HOST                | imap.gmail.com                        |              |
| GITLAB_INCOMING_EMAIL_IDLE_TIMEOUT        | 60                                    |              |
| GITLAB_INCOMING_EMAIL_MAILBOX             | inbox                                 |              |
| GITLAB_INCOMING_EMAIL_PASSWORD            |                                       |              |
| GITLAB_INCOMING_EMAIL_PORT                | 993                                   |              |
| GITLAB_INCOMING_EMAIL_SSL                 | true                                  |              |
| GITLAB_INCOMING_EMAIL_START_TLS           | false                                 |              |
| GITLAB_INCOMING_EMAIL_USER                | gitlab-incoming@gmail.com             |              |
| GITLAB_LDAP_ACTIVE_DIRECTORY              | true                                  |              |
| GITLAB_LDAP_ALLOW_USERNAME_OR_EMAIL_LOGIN | false                                 |              |
| GITLAB_LDAP_BASE                          |                                       |              |
| GITLAB_LDAP_BIND_DN                       |                                       |              |
| GITLAB_LDAP_BLOCK_AUTO_CREATED_USERS      | false                                 |              |
| GITLAB_LDAP_CA_FILE                       |                                       |              |
| GITLAB_LDAP_ENABLED                       | false                                 |              |
| GITLAB_LDAP_ENCRYPTION                    | plain                                 |              |
| GITLAB_LDAP_HOST                          |                                       |              |
| GITLAB_LDAP_LABEL                         | LDAP                                  |              |
| GITLAB_LDAP_PASSWORD                      |                                       |              |
| GITLAB_LDAP_PORT                          | 389                                   |              |
| GITLAB_LDAP_SSL_VERSION                   |                                       |              |
| GITLAB_LDAP_TIMEOUT                       | 10                                    |              |
| GITLAB_LDAP_UID                           | sAMAccountName                        |              |
| GITLAB_LDAP_USER_FILTER                   |                                       |              |
| GITLAB_LDAP_VERIFY_CERTIFICATES           | true                                  |              |
| GITLAB_LFS_ENABLED                        | true                                  |              |
| GITLAB_LOG_LEVEL                          | info                                  |              |
| GITLAB_PAGES_ENABLED                      | false                                 |              |
| GITLAB_PAGES_EXTERNAL_HTTP                |                                       |              |
| GITLAB_PAGES_EXTERNAL_HTTPS               |                                       |              |
| GITLAB_PAGES_HOST                         |                                       |              |
| GITLAB_PAGES_HTTPS                        | false                                 |              |
| GITLAB_PAGES_PORT                         | 80                                    |              |
| GITLAB_REGISTRY_API_URL                   | http://docker-registry:5000/          |              |
| GITLAB_REGISTRY_ENABLED                   | false                                 |              |
| GITLAB_REGISTRY_HOST                      |                                       |              |
| GITLAB_REGISTRY_ISSUER                    | gitlab-issuer                         |              |
| GITLAB_REGISTRY_KEY                       | /mnt/data/certs/registry-auth.key     |              |
| GITLAB_REGISTRY_PATH                      | shared/registry                       |              |
| GITLAB_REGISTRY_PORT                      | 80                                    |              |
| GITLAB_ROOT_EMAIL                         |                                       |              |
| GITLAB_ROOT_PASSWORD                      | 80                                    |              |
| GITLAB_SECRETS_DB_KEY_BASE                |                                       |              |
| GITLAB_SECRETS_OTP_KEY_BASE               |                                       |              |
| GITLAB_SECRETS_SECRET_KEY_BASE            |                                       |              |
| GITLAB_SECRETS_SHELL                      |                                       |              |
| GITLAB_SECRETS_WORKHORSE                  |                                       |              |
| GITLAB_SHELL_AUDIT_USERNAMES              | false                                 |              |
| GITLAB_SHELL_GITLAB_URL                   | gitlab                                |              |
| GITLAB_SHELL_LOG_LEVEL                    | INFO                                  |              |
| GITLAB_SHELL_SSH_PORT                     | 22                                    |              |
| GITLAB_SMTP_ADDRESS                       |                                       |              |
| GITLAB_SMTP_DOMAIN                        | gitlab.company.com                    |              |
| GITLAB_SMTP_PASSWORD                      |                                       |              |
| GITLAB_SMTP_PORT                          | 25                                    |              |
| GITLAB_SMTP_USER                          |                                       |              |
| GITLAB_UNICORN_TIMEOUT                    | 60                                    |              |
| GITLAB_UNICORN_WORKER_PROCESSES           | 3                                     |              |
| REDIS_HOST                                | redis                                 |              |
| REDIS_PASS                                |                                       |              |
| REDIS_PORT                                | 6379                                  |              |
| SSHD_LOG_LEVEL                            | VERBOSE                               |              |
| SSHD_PASSWORD_AUTHENTICATION              | no                                    |              |
| SSHD_PERMIT_USER_ENV                      | yes                                   |              |
| SSHD_USE_DNS                              | no                                    |              |

## Orchestration actions

Usage:
```
make COMMAND [params ...]

commands:
    init-data-dir 
    init-db
    backup [skip]
    restore timestamp
    check-ready [host max_try wait_seconds delay_seconds]
    gitlab-readiness [host max_try wait_seconds delay_seconds]
    gitlab-liveness [host max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

## Deployment

Deploy GitLab to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
