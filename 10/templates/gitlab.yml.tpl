# # # # # # # # # # # # # # # # # #
# GitLab application config file  #
# # # # # # # # # # # # # # # # # #
#
###########################  NOTE  #####################################
# This file should not receive new settings. All configuration options #
# * are being moved to ApplicationSetting model!                       #
# If a setting requires an application restart say so in that screen.  #
# If you change this file in a Merge Request, please also create       #
# a MR on https://gitlab.com/gitlab-org/omnibus-gitlab/merge_requests  #
########################################################################
#
#
# How to use:
# 1. Copy file as gitlab.yml
# 2. Update gitlab -> host with your fully qualified domain name
# 3. Update gitlab -> email_from
# 4. If you installed Git from source, change git -> bin_path to /usr/local/bin/git
#    IMPORTANT: If Git was installed in a different location use that instead.
#    You can check with `which git`. If a wrong path of Git is specified, it will
#     result in various issues such as failures of GitLab CI builds.
# 5. Review this configuration file for other settings you may want to adjust

production: &base
  #
  # 1. GitLab app settings
  # ==========================

  ## GitLab settings
  gitlab:
    ## Web server settings (note: host is the FQDN, do not include http://)
    host: {{ getenv "GITLAB_HOST" "localhost" }}
    port: {{ getenv "GITLAB_PORT" "80" }} # Set to 443 if using HTTPS, see installation.md#using-https for additional HTTPS configuration details
    https: {{ getenv "GITLAB_HTTPS" "false" }} # Set to true if using HTTPS, see installation.md#using-https for additional HTTPS configuration details

    # Uncommment this line below if your ssh host is different from HTTP/HTTPS one
    # (you'd obviously need to replace ssh.host_example.com with your own host).
    # Otherwise, ssh host will be set to the `host:` value above
    # ssh_host: ssh.host_example.com

    # Relative URL support
    # WARNING: We recommend using an FQDN to host GitLab in a root path instead
    # of using a relative URL.
    # Documentation: http://doc.gitlab.com/ce/install/relative_url.html
    # Uncomment and customize the following line to run in a non-root path
    #
    # relative_url_root: /gitlab

    # Trusted Proxies
    # Customize if you have GitLab behind a reverse proxy which is running on a different machine.
    # Add the IP address for your reverse proxy to the list, otherwise users will appear signed in from that address.
    trusted_proxies:
      # Examples:
      #- 192.168.1.0/24
      #- 192.168.2.1
      #- 2001:0db8::/32

    # Uncomment and customize if you can't use the default user to run GitLab (default: 'git')
    # user: git

    ## Date & Time settings
    # Uncomment and customize if you want to change the default time zone of GitLab application.
    # To see all available zones, run `bundle exec rake time:zones:all RAILS_ENV=production`
    # time_zone: 'UTC'

    ## Email settings
    # Uncomment and set to false if you need to disable email sending from GitLab (default: true)
    # email_enabled: true
    # Email address used in the "From" field in mails sent by GitLab
    email_enabled: {{ getenv "GITLAB_EMAIL_ENABLED" "true" }}
    email_from: {{ getenv "GITLAB_EMAIL_FROM" "example@example.com" }}
    email_display_name: {{ getenv "GITLAB_EMAIL_DISPLAY_NAME" "GitLab" }}
    email_reply_to: {{ getenv "GITLAB_EMAIL_REPLY_TO" "noreply@example.com" }}
    email_subject_suffix: '{{ getenv "GITLAB_EMAIL_SUBJECT_SUFFIX" "" }}'

    # Email server smtp settings are in config/initializers/smtp_settings.rb.sample

    # default_can_create_group: false  # default: true
    # username_changing_enabled: false # default: true - User can change her username/namespace
    ## Default theme ID
    ##   1 - Indigo
    ##   2 - Dark
    ##   3 - Light
    ##   4 - Blue
    ##   5 - Green
    # default_theme: 1 # default: 1

    ## Automatic issue closing
    # If a commit message matches this regular expression, all issues referenced from the matched text will be closed.
    # This happens when the commit is pushed or merged into the default branch of a project.
    # When not specified the default issue_closing_pattern as specified below will be used.
    # Tip: you can test your closing pattern at http://rubular.com.
    # issue_closing_pattern: '((?:[Cc]los(?:e[sd]?|ing)|[Ff]ix(?:e[sd]|ing)?|[Rr]esolv(?:e[sd]?|ing)|[Ii]mplement(?:s|ed|ing)?)(:?) +(?:(?:issues? +)?%{issue_ref}(?:(?:, *| +and +)?)|([A-Z][A-Z0-9_]+-\d+))+)'

    ## Default project features settings
    default_projects_features:
      issues: true
      merge_requests: true
      wiki: true
      snippets: true
      builds: true
      container_registry: true

    ## Webhook settings
    # Number of seconds to wait for HTTP response after sending webhook HTTP POST request (default: 10)
    # webhook_timeout: 10

    ## Repository downloads directory
    # When a user clicks e.g. 'Download zip' on a project, a temporary zip file is created in the following directory.
    # The default is 'shared/cache/archive/' relative to the root of the Rails app.
    # repository_downloads_path: shared/cache/archive/

  ## Reply by email
  # Allow users to comment on issues and merge requests by replying to notification emails.
  # For documentation on how to set this up, see http://doc.gitlab.com/ce/administration/reply_by_email.html
  incoming_email:
    enabled: {{ getenv "GITLAB_INCOMING_EMAIL" "false" }}

    # The email address including the `%{key}` placeholder that will be replaced to reference the item being replied to.
    # The placeholder can be omitted but if present, it must appear in the "user" part of the address (before the `@`).
    address: "{{ getenv "GITLAB_INCOMING_EMAIL_ADDRESS" "gitlab-incoming+%{key}@gmail.com" }}"

    # Email account username
    # With third party providers, this is usually the full email address.
    # With self-hosted email servers, this is usually the user part of the email address.
    user: "{{ getenv "GITLAB_INCOMING_EMAIL_USER" "gitlab-incoming@gmail.com" }}"
    # Email account password
    password: "{{ getenv "GITLAB_INCOMING_EMAIL_PASSWORD" "[REDACTED]" }}"

    # IMAP server host
    host: "{{ getenv "GITLAB_INCOMING_EMAIL_HOST" "imap.gmail.com" }}"
    # IMAP server port
    port: {{ getenv "GITLAB_INCOMING_EMAIL_PORT" "993" }}
    # Whether the IMAP server uses SSL
    ssl: {{ getenv "GITLAB_INCOMING_EMAIL_SSL" "true" }}
    # Whether the IMAP server uses StartTLS
    start_tls: {{ getenv "GITLAB_INCOMING_EMAIL_START_TLS" "false" }}

    # The mailbox where incoming mail will end up. Usually "inbox".
    mailbox: "{{ getenv "GITLAB_INCOMING_EMAIL_MAILBOX" "inbox" }}"
    # The IDLE command timeout.
    idle_timeout: {{ getenv "GITLAB_INCOMING_EMAIL_IDLE_TIMEOUT" "60" }}

  ## Build Artifacts
  artifacts:
    enabled: {{ getenv "GITLAB_ARTIFACTS_ENABLED" "true" }}
    # The location where build artifacts are stored (default: shared/artifacts).
    # path: shared/artifacts

  ## Git LFS
  lfs:
    enabled: {{ getenv "GITLAB_LFS_ENABLED" "true" }}
    # The location where LFS objects are stored (default: shared/lfs-objects).
    # storage_path: shared/lfs-objects

  ## GitLab Pages
  pages:
    enabled: {{ getenv "GITLAB_PAGES_ENABLED" "false" }}
    # The location where pages are stored (default: shared/pages).
    # path: shared/pages

    # The domain under which the pages are served:
    # http://group.example.com/project
    # or project path can be a group page: group.example.com
    host: {{ getenv "GITLAB_PAGES_HOST" "example.com" }}
    port: {{ getenv "GITLAB_PAGES_PORT" "80" }} # Set to 443 if you serve the pages with HTTPS
    https: {{ getenv "GITLAB_PAGES_HTTPS" "false" }} # Set to true if you serve the pages with HTTPS
    # external_http: ["1.1.1.1:80", "[2001::1]:80"] # If defined, enables custom domain support in GitLab Pages
    # external_https: ["1.1.1.1:443", "[2001::1]:443"] # If defined, enables custom domain and certificate support in GitLab Pages

  ## Mattermost
  ## For enabling Add to Mattermost button
  mattermost:
    enabled: false
    host: 'https://mattermost.example.com'

  ## Gravatar
  ## For Libravatar see: http://doc.gitlab.com/ce/customization/libravatar.html
  gravatar:
    # gravatar urls: possible placeholders: %{hash} %{size} %{email} %{username}
    # plain_url: "http://..."     # default: http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon
    # ssl_url:   "https://..."    # default: https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon

  ## Auxiliary jobs
  # Periodically executed jobs, to self-heal Gitlab, do external synchronizations, etc.
  # Please read here for more information: https://github.com/ondrejbartas/sidekiq-cron#adding-cron-job
  cron_jobs:
    # Flag stuck CI jobs as failed
    stuck_ci_jobs_worker:
      cron: "0 * * * *"
    # Execute scheduled triggers
    pipeline_schedule_worker:
      cron: "19 * * * *"
    # Remove expired build artifacts
    expire_build_artifacts_worker:
      cron: "50 * * * *"
    # Periodically run 'git fsck' on all repositories. If started more than
    # once per hour you will have concurrent 'git fsck' jobs.
    repository_check_worker:
      cron: "20 * * * *"
    # Send admin emails once a week
    admin_email_worker:
      cron: "0 0 * * 0"

    # Remove outdated repository archives
    repository_archive_cache_worker:
      cron: "0 * * * *"

  registry:
    # enabled: true
    # host: registry.example.com
    # port: 5005
    # api_url: http://localhost:5000/ # internal address to the registry, will be used by GitLab to directly communicate with API
    # key: config/registry.key
    # path: shared/registry
    # issuer: gitlab-issuer

  #
  # 2. GitLab CI settings
  # ==========================

  gitlab_ci:
    # Default project notifications settings:
    #
    # Send emails only on broken builds (default: true)
    # all_broken_builds: true
    #
    # Add pusher to recipients list (default: false)
    # add_pusher: true

    # The location where build traces are stored (default: builds/). Relative paths are relative to Rails.root
    # builds_path: builds/

  #
  # 3. Auth settings
  # ==========================

  ## LDAP settings
  # You can test connections and inspect a sample of the LDAP users with login
  # access by running:
  #   bundle exec rake gitlab:ldap:check RAILS_ENV=production
  ldap:
    enabled: false
    servers:
      ##########################################################################
      #
      # Since GitLab 7.4, LDAP servers get ID's (below the ID is 'main'). GitLab
      # Enterprise Edition now supports connecting to multiple LDAP servers.
      #
      # If you are updating from the old (pre-7.4) syntax, you MUST give your
      # old server the ID 'main'.
      #
      ##########################################################################
      main: # 'main' is the GitLab 'provider ID' of this LDAP server
        ## label
        #
        # A human-friendly name for your LDAP server. It is OK to change the label later,
        # for instance if you find out it is too large to fit on the web page.
        #
        # Example: 'Paris' or 'Acme, Ltd.'
        label: 'LDAP'

        # Example: 'ldap.mydomain.com'
        host: '_your_ldap_server'
        # This port is an example, it is sometimes different but it is always an integer and not a string
        port: 389 # usually 636 for SSL
        uid: 'sAMAccountName' # This should be the attribute, not the value that maps to uid.

        # Examples: 'america\\momo' or 'CN=Gitlab Git,CN=Users,DC=mydomain,DC=com'
        bind_dn: '_the_full_dn_of_the_user_you_will_bind_with'
        password: '_the_password_of_the_bind_user'

        # Encryption method. The "method" key is deprecated in favor of
        # "encryption".
        #
        #   Examples: "start_tls" or "simple_tls" or "plain"
        #
        #   Deprecated values: "tls" was replaced with "start_tls" and "ssl" was
        #   replaced with "simple_tls".
        #
        encryption: 'plain'

        # Enables SSL certificate verification if encryption method is
        # "start_tls" or "simple_tls". Defaults to true.
        verify_certificates: true

        # Specifies the path to a file containing a PEM-format CA certificate,
        # e.g. if you need to use an internal CA.
        #
        #   Example: '/etc/ca.pem'
        #
        ca_file: ''

        # Specifies the SSL version for OpenSSL to use, if the OpenSSL default
        # is not appropriate.
        #
        #   Example: 'TLSv1_1'
        #
        ssl_version: ''

        # Set a timeout, in seconds, for LDAP queries. This helps avoid blocking
        # a request if the LDAP server becomes unresponsive.
        # A value of 0 means there is no timeout.
        timeout: 10

        # This setting specifies if LDAP server is Active Directory LDAP server.
        # For non AD servers it skips the AD specific queries.
        # If your LDAP server is not AD, set this to false.
        active_directory: true

        # If allow_username_or_email_login is enabled, GitLab will ignore everything
        # after the first '@' in the LDAP username submitted by the user on login.
        #
        # Example:
        # - the user enters 'jane.doe@example.com' and 'p@ssw0rd' as LDAP credentials;
        # - GitLab queries the LDAP server with 'jane.doe' and 'p@ssw0rd'.
        #
        # If you are using "uid: 'userPrincipalName'" on ActiveDirectory you need to
        # disable this setting, because the userPrincipalName contains an '@'.
        allow_username_or_email_login: false

        # To maintain tight control over the number of active users on your GitLab installation,
        # enable this setting to keep new users blocked until they have been cleared by the admin
        # (default: false).
        block_auto_created_users: false

        # Base where we can search for users
        #
        #   Ex. 'ou=People,dc=gitlab,dc=example' or 'DC=mydomain,DC=com'
        #
        base: ''

        # Filter LDAP users
        #
        #   Format: RFC 4515 https://tools.ietf.org/search/rfc4515
        #   Ex. (employeeType=developer)
        #
        #   Note: GitLab does not support omniauth-ldap's custom filter syntax.
        #
        #   Example for getting only specific users:
        #   '(&(objectclass=user)(|(samaccountname=momo)(samaccountname=toto)))'
        #
        user_filter: ''

        # LDAP attributes that GitLab will use to create an account for the LDAP user.
        # The specified attribute can either be the attribute name as a string (e.g. 'mail'),
        # or an array of attribute names to try in order (e.g. ['mail', 'email']).
        # Note that the user's LDAP login will always be the attribute specified as `uid` above.
        attributes:
          # The username will be used in paths for the user's own projects
          # (like `gitlab.example.com/username/project`) and when mentioning
          # them in issues, merge request and comments (like `@username`).
          # If the attribute specified for `username` contains an email address,
          # the GitLab username will be the part of the email address before the '@'.
          username: ['uid', 'userid', 'sAMAccountName']
          email:    ['mail', 'email', 'userPrincipalName']

          # If no full name could be found at the attribute specified for `name`,
          # the full name is determined using the attributes specified for
          # `first_name` and `last_name`.
          name:       'cn'
          first_name: 'givenName'
          last_name:  'sn'

      # GitLab EE only: add more LDAP servers
      # Choose an ID made of a-z and 0-9 . This ID will be stored in the database
      # so that GitLab can remember which LDAP server a user belongs to.
      # uswest2:
      #   label:
      #   host:
      #   ....


  ## OmniAuth settings
  omniauth:
    # Allow login via Twitter, Google, etc. using OmniAuth providers
    enabled: false

    # Uncomment this to automatically sign in with a specific omniauth provider's without
    # showing GitLab's sign-in page (default: show the GitLab sign-in page)
    # auto_sign_in_with_provider: saml

    # Sync user's profile from the specified Omniauth providers every time the user logs in (default: empty).
    # Define the allowed providers using an array, e.g. ["cas3", "saml", "twitter"],
    # or as true/false to allow all providers or none.
    # sync_profile_from_provider: []

    # Select which info to sync from the providers above. (default: email).
    # Define the synced profile info using an array. Available options are "name", "email" and "location"
    # e.g. ["name", "email", "location"] or as true to sync all available.
    # This consequently will make the selected attributes read-only.
    # sync_profile_attributes: true

    # CAUTION!
    # This allows users to login without having a user account first. Define the allowed providers
    # using an array, e.g. ["saml", "twitter"], or as true/false to allow all providers or none.
    # User accounts will be created automatically when authentication was successful.
    allow_single_sign_on: ["saml"]

    # Locks down those users until they have been cleared by the admin (default: true).
    block_auto_created_users: true
    # Look up new users in LDAP servers. If a match is found (same uid), automatically
    # link the omniauth identity with the LDAP account. (default: false)
    auto_link_ldap_user: false

    # Allow users with existing accounts to login and auto link their account via SAML
    # login, without having to do a manual login first and manually add SAML
    # (default: false)
    auto_link_saml_user: false

    # Set different Omniauth providers as external so that all users creating accounts
    # via these providers will not be able to have access to internal projects. You
    # will need to use the full name of the provider, like `google_oauth2` for Google.
    # Refer to the examples below for the full names of the supported providers.
    # (default: [])
    external_providers: []

    ## Auth providers
    # Uncomment the following lines and fill in the data of the auth provider you want to use
    # If your favorite auth provider is not listed you can use others:
    # see https://github.com/gitlabhq/gitlab-public-wiki/wiki/Custom-omniauth-provider-configurations
    # The 'app_id' and 'app_secret' parameters are always passed as the first two
    # arguments, followed by optional 'args' which can be either a hash or an array.
    # Documentation for this is available at http://doc.gitlab.com/ce/integration/omniauth.html
    providers:
      # See omniauth-cas3 for more configuration details
      # - { name: 'cas3',
      #     label: 'cas3',
      #     args: {
      #             url: 'https://sso.example.com',
      #             disable_ssl_verification: false,
      #             login_url: '/cas/login',
      #             service_validate_url: '/cas/p3/serviceValidate',
      #             logout_url: '/cas/logout'} }
      # - { name: 'authentiq',
      #     # for client credentials (client ID and secret), go to https://www.authentiq.com/developers
      #     app_id: 'YOUR_CLIENT_ID',
      #     app_secret: 'YOUR_CLIENT_SECRET',
      #     args: {
      #             scope: 'aq:name email~rs address aq:push'
      #             # callback_url parameter is optional except when 'gitlab.host' in this file is set to 'localhost'
      #             # callback_url: 'YOUR_CALLBACK_URL'
      #           }
      #   }
      # - { name: 'github',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET',
      #     url: "https://github.com/",
      #     verify_ssl: true,
      #     args: { scope: 'user:email' } }
      # - { name: 'bitbucket',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET' }
      # - { name: 'gitlab',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET',
      #     args: { scope: 'api' } }
      # - { name: 'google_oauth2',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET',
      #     args: { access_type: 'offline', approval_prompt: '' } }
      # - { name: 'facebook',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET' }
      # - { name: 'twitter',
      #     app_id: 'YOUR_APP_ID',
      #     app_secret: 'YOUR_APP_SECRET' }
      #
      # - { name: 'saml',
      #     label: 'Our SAML Provider',
      #     groups_attribute: 'Groups',
      #     external_groups: ['Contractors', 'Freelancers'],
      #     args: {
      #             assertion_consumer_service_url: 'https://gitlab.example.com/users/auth/saml/callback',
      #             idp_cert_fingerprint: '43:51:43:a1:b5:fc:8b:b7:0a:3a:a9:b1:0f:66:73:a8',
      #             idp_sso_target_url: 'https://login.example.com/idp',
      #             issuer: 'https://gitlab.example.com',
      #             name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
      #           } }
      #
      # - { name: 'crowd',
      #     args: {
      #       crowd_server_url: 'CROWD SERVER URL',
      #       application_name: 'YOUR_APP_NAME',
      #       application_password: 'YOUR_APP_PASSWORD' } }
      #
      # - { name: 'auth0',
      #     args: {
      #       client_id: 'YOUR_AUTH0_CLIENT_ID',
      #       client_secret: 'YOUR_AUTH0_CLIENT_SECRET',
      #       namespace: 'YOUR_AUTH0_DOMAIN' } }

    # SSO maximum session duration in seconds. Defaults to CAS default of 8 hours.
    # cas3:
    #   session_duration: 28800

  # Shared file storage settings
  shared:
    # path: /mnt/gitlab # Default: shared

  # Gitaly settings
  gitaly:
    # Path to the directory containing Gitaly client executables.
    client_path: {{ getenv "GITALY_DIR" }}
    # Default Gitaly authentication token. Can be overriden per storage. Can
    # be left blank when Gitaly is running locally on a Unix socket, which
    # is the normal way to deploy Gitaly.
    token:

  #
  # 4. Advanced settings
  # ==========================

  ## Repositories settings
  repositories:
    # Paths where repositories can be stored. Give the canonicalized absolute pathname.
    # IMPORTANT: None of the path components may be symlink, because
    # gitlab-shell invokes Dir.pwd inside the repository path and that results
    # real path not the symlink.
    storages: # You must have at least a `default` storage path.
      default:
        path: {{ getenv "GITLAB_REPOS_DIR" }}
#        gitaly_address: unix:/home/git/gitlab/tmp/sockets/private/gitaly.socket # TCP connections are supported too (e.g. tcp://host:port)
        gitaly_address: tcp://gitaly:9999
        # gitaly_token: 'special token' # Optional: override global gitaly.token for this storage.
        failure_count_threshold: 10 # number of failures before stopping attempts
        failure_wait_time: 30 # Seconds after an access failure before allowing access again
        failure_reset_time: 1800 # Time in seconds to expire failures
        storage_timeout: 30 # Time in seconds to wait before aborting a storage access attempt


  ## Backup settings
  backup:
    path: {{ getenv  "GITLAB_BACKUP_DIR" }}   # Relative paths are relative to Rails.root (default: tmp/backups/)
    archive_permissions: {{ getenv "GITLAB_BACKUP_ARCHIVE_PERMISSION" "0640" }} # Permissions for the resulting backup.tar file (default: 0600)
    keep_time: {{ getenv "GITLAB_BACKUP_KEEP_TIME" "604800" }}   # default: 0 (forever) (in seconds)
    pg_schema: {{ getenv "GITLAB_BACKUP_PG_SCHEMA" "public" }}     # default: nil, it means that all schemas will be backed up
{{ $provider := (getenv "GITLAB_BACKUP_UPLOAD_PROVIDER") }}
{{ if ($provider == "AWS") || ($provider == "Google") }}
    upload:
      # Fog storage connection settings, see http://fog.io/storage/ .
      connection:
        provider: {{ $provider }}
  {{ if $provider == "AWS" }}
        region: {{ getenv "GITLAB_BACKUP_UPLOAD_REGION" "eu-west-1" }}
        aws_access_key_id: {{ getenv "GITLAB_BACKUP_UPLOAD_ACCESS_KEY_ID" "key id" }}
        aws_secret_access_key: {{ getenv "GITLAB_BACKUP_UPLOAD_SECRET_ACCESS_KEY" "access key" }}
  {{ else if $provider == "Google" }}
        google_storage_access_key_id: {{ getenv "GITLAB_BACKUP_UPLOAD_ACCESS_KEY_ID" "key id" }}
        google_storage_secret_access_key: {{ getenv "GITLAB_BACKUP_UPLOAD_SECRET_ACCESS_KEY" "access key" }}
  {{ end }}
      # The remote 'directory' to store your backups. For S3, this would be the bucket name.
      remote_directory: {{ getenv "GITLAB_BACKUP_UPLOAD_REMOTE_DIRECTORY" "remote_dir" }}
      # Use multipart uploads when file size reaches 100MB, see
      #  http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
      multipart_chunk_size: {{ getenv "GITLAB_BACKUP_UPLOAD_MULTIPART_CHUNK_SIZE" "104857600" }}
      # Turns on AWS Server-Side Encryption with Amazon S3-Managed Keys for backups, this is optional
      encryption: {{ getenv "GITLAB_BACKUP_UPLOAD_ENCRYPTION" "AES256" }}
      # Specifies Amazon S3 storage class to use for backups, this is optional
      storage_class: {{ getenv "GITLAB_BACKUP_UPLOAD_STORAGE_CLASS" "STANDARD" }}
{{ end }}

  ## GitLab Shell settings
  gitlab_shell:
    path: {{ getenv "GITLAB_SHELL_DIR" }}
    hooks_path: {{ getenv "GITLAB_SHELL_DIR" }}/hooks/

    # File that contains the secret key for verifying access for gitlab-shell.
    # Default is '.gitlab_shell_secret' relative to Rails.root (i.e. root of the GitLab app).
    secret_file: {{ getenv "GITLAB_DIR" }}/.gitlab_shell_secret

    # Git over HTTP
    upload_pack: true
    receive_pack: true

    # Git import/fetch timeout
    # git_timeout: 800

    # If you use non-standard ssh port you need to specify it
    ssh_port: {{ getenv "GITLAB_SHELL_SSH_PORT" "22" }}

  workhorse:
    # File that contains the secret key for verifying access for gitlab-workhorse.
    # Default is '.gitlab_workhorse_secret' relative to Rails.root (i.e. root of the GitLab app).
    secret_file: {{ getenv "GITLAB_DIR" }}/.gitlab_workhorse_secret

  ## Git settings
  # CAUTION!
  # Use the default values unless you really know what you are doing
  git:
    bin_path: /usr/bin/git

  ## Webpack settings
  # If enabled, this will tell rails to serve frontend assets from the webpack-dev-server running
  # on a given port instead of serving directly from /assets/webpack. This is only indended for use
  # in development.
  webpack:
    # dev_server:
    #   enabled: true
    #   host: localhost
    #   port: 3808

  ## Monitoring
  # Built in monitoring settings
  monitoring:
    # Time between sampling of unicorn socket metrics, in seconds
    # unicorn_sampler_interval: 10
    # IP whitelist to access monitoring endpoints
    ip_whitelist:
      - 127.0.0.0/8

    # Sidekiq exporter is webserver built in to Sidekiq to expose Prometheus metrics
    sidekiq_exporter:
    #  enabled: true
    #  address: localhost
    #  port: 3807

  #
  # 5. Extra customization
  # ==========================

  extra:
    ## Google analytics. Uncomment if you want it
    # google_analytics_id: '_your_tracking_id'

    ## Piwik analytics.
    # piwik_url: '_your_piwik_url'
    # piwik_site_id: '_your_piwik_site_id'

  rack_attack:
    git_basic_auth:
      # Rack Attack IP banning enabled
      # enabled: true
      #
      # Whitelist requests from 127.0.0.1 for web proxies (NGINX/Apache) with incorrect headers
      # ip_whitelist: ["127.0.0.1"]
      #
      # Limit the number of Git HTTP authentication attempts per IP
      # maxretry: 10
      #
      # Reset the auth attempt counter per IP after 60 seconds
      # findtime: 60
      #
      # Ban an IP for one hour (3600s) after too many auth attempts
      # bantime: 3600
