production: &base
  gitlab:
    host: {{ getenv "GITLAB_HOST" "localhost" }}
    port: {{ getenv "GITLAB_PORT" "80" }}
    https: {{ getenv "GITLAB_HTTPS" "false" }}
    trusted_proxies:
      - 172.17.0.0/16
    email_enabled: {{ getenv "GITLAB_EMAIL_ENABLED" "true" }}
    email_from: {{ getenv "GITLAB_EMAIL_FROM" "gitlab@example.com" }}
    email_display_name: {{ getenv "GITLAB_EMAIL_DISPLAY_NAME" "GitLab" }}
    email_reply_to: {{ getenv "GITLAB_EMAIL_REPLY_TO" "noreply@example.com" }}
    email_subject_suffix: {{ getenv "GITLAB_EMAIL_SUBJECT_SUFFIX" }}
    default_projects_features:
      issues: true
      merge_requests: true
      wiki: true
      snippets: true
      builds: true
      container_registry: true
    repository_downloads_path: {{ getenv "GITLAB_DOWNLOADS_DIR" }}

  incoming_email:
    enabled: {{ getenv "GITLAB_INCOMING_EMAIL" "false" }}
    address: {{ getenv "GITLAB_INCOMING_EMAIL_ADDRESS" "gitlab-incoming+%{key}@gmail.com" }}
    user: {{ getenv "GITLAB_INCOMING_EMAIL_USER" "gitlab-incoming@gmail.com" }}
    password: {{ getenv "GITLAB_INCOMING_EMAIL_PASSWORD" "[REDACTED]" }}
    host: {{ getenv "GITLAB_INCOMING_EMAIL_HOST" "imap.gmail.com" }}
    port: {{ getenv "GITLAB_INCOMING_EMAIL_PORT" "993" }}
    ssl: {{ getenv "GITLAB_INCOMING_EMAIL_SSL" "true" }}
    start_tls: {{ getenv "GITLAB_INCOMING_EMAIL_START_TLS" "false" }}
    mailbox: {{ getenv "GITLAB_INCOMING_EMAIL_MAILBOX" "inbox" }}
    idle_timeout: {{ getenv "GITLAB_INCOMING_EMAIL_IDLE_TIMEOUT" "60" }}

  artifacts:
    enabled: {{ getenv "GITLAB_ARTIFACTS_ENABLED" "true" }}
    path: {{ getenv "GITLAB_ARTIFACTS_DIR" }}

  lfs:
    enabled: {{ getenv "GITLAB_LFS_ENABLED" "true" }}

  pages:
    enabled: {{ getenv "GITLAB_PAGES_ENABLED" "false" }}
    path: {{ getenv "GITLAB_PAGES_DIR" }}
    host: {{ getenv "GITLAB_PAGES_HOST" "pages.example.com" }}
    port: {{ getenv "GITLAB_PAGES_PORT" "80" }}
    https: {{ getenv "GITLAB_PAGES_HTTPS" "false" }}
    artifacts_server: true

  mattermost:
    enabled: false
    host: https://mattermost.example.com

  gravatar:

  cron_jobs:
    stuck_ci_jobs_worker:
      cron: "0 * * * *"
    pipeline_schedule_worker:
      cron: "19 * * * *"
    expire_build_artifacts_worker:
      cron: "50 * * * *"
    repository_check_worker:
      cron: "20 * * * *"
    admin_email_worker:
      cron: "0 0 * * 0"

    repository_archive_cache_worker:
      cron: "0 * * * *"

  registry:
    enabled: {{ getenv "GITLAB_REGISTRY_ENABLED" "false" }}
    host: {{ getenv "GITLAB_REGISTRY_HOST" }}
    port: {{ getenv "GITLAB_REGISTRY_PORT" "443" }}
    api_url: {{ getenv "GITLAB_REGISTRY_API_URL" "http://docker-registry:5000/" }}
    key: {{ getenv "GITLAB_REGISTRY_KEY" "/mnt/data/certs/registry-auth.key" }}
    path: {{ getenv "GITLAB_REGISTRY_PATH" "shared/registry" }}
    issuer: {{ getenv "GITLAB_REGISTRY_ISSUER" "gitlab-issuer" }}

  gitlab_ci:
     all_broken_builds: {{ getenv "GITLAB_CI_ALL_BROKEN_BUILDS" "true" }}
     add_pusher: {{ getenv "GITLAB_CI_ADD_PUSHER" "true" }}
     builds_path: {{ getenv "GITLAB_CI_BUILDS_PATH" "builds/" }}

  ldap:
    enabled: {{ getenv "GITLAB_LDAP_ENABLED" "false" }}
    servers:
      main:
        label: '{{ getenv "GITLAB_LDAP_LABEL" "LDAP" }}'
        host: '{{ getenv "GITLAB_LDAP_HOST" }}'
        port: {{ getenv "GITLAB_LDAP_PORT" "389" }}
        uid: '{{ getenv "GITLAB_LDAP_UID" "sAMAccountName" }}'
        bind_dn: '{{ getenv "GITLAB_LDAP_BIND_DN" }}'
        password: '{{ getenv "GITLAB_LDAP_PASSWORD" }}'
        encryption: '{{ getenv "GITLAB_LDAP_ENCRYPTION" "plain" }}'
        verify_certificates: {{ getenv "GITLAB_LDAP_VERIFY_CERTIFICATES" "true" }}
        ca_file: '{{ getenv "GITLAB_LDAP_CA_FILE" }}'
        ssl_version: '{{ getenv "GITLAB_LDAP_SSL_VERSION" }}'
        timeout: {{ getenv "GITLAB_LDAP_TIMEOUT" "10" }}
        active_directory: {{ getenv "GITLAB_LDAP_ACTIVE_DIRECTORY" "true" }}
        allow_username_or_email_login: {{ getenv "GITLAB_LDAP_ALLOW_USERNAME_OR_EMAIL_LOGIN" "false" }}
        block_auto_created_users: {{ getenv "GITLAB_LDAP_BLOCK_AUTO_CREATED_USERS" "false" }}
        base: '{{ getenv "GITLAB_LDAP_BASE" }}'
        user_filter: '{{ getenv "GITLAB_LDAP_USER_FILTER" }}'
        attributes:
          username: ['uid', 'userid', 'sAMAccountName']
          email:    ['mail', 'email', 'userPrincipalName']
          name:       'cn'
          first_name: 'givenName'
          last_name:  'sn'

  omniauth:
    enabled: false
    allow_single_sign_on: ["saml"]
    block_auto_created_users: true
    auto_link_ldap_user: false
    auto_link_saml_user: false
    external_providers: []
    providers:

  shared:

  gitaly:
    client_path: {{ getenv "GITALY_DIR" }}
    token:

  repositories:
    storages:
      default:
        path: {{ getenv "GITLAB_REPOS_DIR" }}
        gitaly_address: tcp://gitaly:9999
        # gitaly_token: 'special token'

  backup:
    path: {{ getenv  "GITLAB_BACKUP_DIR" }}
    archive_permissions: {{ getenv "GITLAB_BACKUP_ARCHIVE_PERMISSION" "0640" }}
    keep_time: {{ getenv "GITLAB_BACKUP_KEEP_TIME" "604800" }}
    pg_schema: {{ getenv "GITLAB_BACKUP_PG_SCHEMA" "public" }} backed up
{{ $provider := (getenv "GITLAB_BACKUP_UPLOAD_PROVIDER") }}
{{ if (eq $provider "AWS") or (eq $provider "Google") }}
    upload:
      connection:
        provider: {{ $provider }}
  {{ if eq $provider "AWS" }}
        region: {{ getenv "GITLAB_BACKUP_AWS_UPLOAD_REGION" "eu-west-1" }}
        aws_access_key_id: {{ getenv "GITLAB_BACKUP_UPLOAD_ACCESS_KEY_ID" }}
        aws_secret_access_key: {{ getenv "GITLAB_BACKUP_UPLOAD_SECRET_ACCESS_KEY" }}
  {{ else if eq $provider "Google" }}
        google_storage_access_key_id: {{ getenv "GITLAB_BACKUP_UPLOAD_ACCESS_KEY_ID" }}
        google_storage_secret_access_key: {{ getenv "GITLAB_BACKUP_UPLOAD_SECRET_ACCESS_KEY" }}
  {{ end }}
      remote_directory: {{ getenv "GITLAB_BACKUP_UPLOAD_REMOTE_DIRECTORY" }}
      multipart_chunk_size: {{ getenv "GITLAB_BACKUP_UPLOAD_MULTIPART_CHUNK_SIZE" "104857600" }}
      encryption: {{ getenv "GITLAB_BACKUP_UPLOAD_ENCRYPTION" "AES256" }}
      storage_class: {{ getenv "GITLAB_BACKUP_UPLOAD_STORAGE_CLASS" "STANDARD" }}
{{ end }}

  gitlab_shell:
    path: {{ getenv "GITLAB_SHELL_DIR" }}
    hooks_path: {{ getenv "GITLAB_SHELL_DIR" }}/hooks/
    secret_file: {{ getenv "GITLAB_DIR" }}/.gitlab_shell_secret
    upload_pack: true
    receive_pack: true
    ssh_port: {{ getenv "GITLAB_SHELL_SSH_PORT" "22" }}

  workhorse:
    secret_file: {{ getenv "GITLAB_DIR" }}/.gitlab_workhorse_secret

  git:
    bin_path: /usr/bin/git

  webpack:

  monitoring:
    ip_whitelist:
      - 127.0.0.0/8
      - 172.17.0.0/16

    sidekiq_exporter:

  extra:

  rack_attack:
    git_basic_auth:
