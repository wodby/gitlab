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
    email_from: {{ getenv "GITLAB_EMAIL_FROM" "example@example.com" }}
    email_display_name: {{ getenv "GITLAB_EMAIL_DISPLAY_NAME" "GitLab" }}
    email_reply_to: {{ getenv "GITLAB_EMAIL_REPLY_TO" "noreply@example.com" }}
    email_subject_suffix: '{{ getenv "GITLAB_EMAIL_SUBJECT_SUFFIX" "" }}'

    # Email server smtp settings are in config/initializers/smtp_settings.rb.sample

    # default_can_create_group: false  # default: true
    # username_changing_enabled: false # default: true - User can change her username/namespace

    ## Automatic issue closing
    # If a commit message matches this regular expression, all issues referenced from the matched text will be closed.
    # This happens when the commit is pushed or merged into the default branch of a project.
    # When not specified the default issue_closing_pattern as specified below will be used.
    # Tip: you can test your closing pattern at http://rubular.com.
    # issue_closing_pattern: '((?:[Cc]los(?:e[sd]?|ing)|[Ff]ix(?:e[sd]|ing)?|[Rr]esolv(?:e[sd]?|ing))(:?) +(?:(?:issues? +)?%{issue_ref}(?:(?:, *| +and +)?)|([A-Z][A-Z0-9_]+-\d+))+)'

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
  # You can inspect a sample of the LDAP users with login access by running:
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

        host: '_your_ldap_server'
        port: 389
        uid: 'sAMAccountName'
        method: 'plain' # "tls" or "ssl" or "plain"
        bind_dn: '_the_full_dn_of_the_user_you_will_bind_with'
        password: '_the_password_of_the_bind_user'

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
        #   Ex. ou=People,dc=gitlab,dc=example
        #
        base: ''

        # Filter LDAP users
        #
        #   Format: RFC 4515 http://tools.ietf.org/search/rfc4515
        #   Ex. (employeeType=developer)
        #
        #   Note: GitLab does not support omniauth-ldap's custom filter syntax.
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

    # Sync user's email address from the specified Omniauth provider every time the user logs
    # in (default: nil). And consequently make this field read-only.
    # sync_email_from_provider: cas3

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
      #     # for client credentials (client ID and secret), go to https://www.authentiq.com/
      #     app_id: 'YOUR_CLIENT_ID',
      #     app_secret: 'YOUR_CLIENT_SECRET',
      #     args: {
      #             scope: 'aq:name email~rs address aq:push'
      #             # redirect_uri parameter is optional except when 'gitlab.host' in this file is set to 'localhost'
      #             # redirect_uri: 'YOUR_REDIRECT_URI'
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
    # Default Gitaly authentication token. Can be overriden per storage. Can
    # be left blank when Gitaly is running locally on a Unix socket, which
    # is the normal way to deploy Gitaly.
     enabled: true

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

  ## Backup settings
  backup:
    path: "tmp/backups"   # Relative paths are relative to Rails.root (default: tmp/backups/)
    # archive_permissions: 0640 # Permissions for the resulting backup.tar file (default: 0600)
    # keep_time: 604800   # default: 0 (forever) (in seconds)
    # pg_schema: public     # default: nil, it means that all schemas will be backed up
    # upload:
    #   # Fog storage connection settings, see http://fog.io/storage/ .
    #   connection:
    #     provider: AWS
    #     region: eu-west-1
    #     aws_access_key_id: AKIAKIAKI
    #     aws_secret_access_key: 'secret123'
    #   # The remote 'directory' to store your backups. For S3, this would be the bucket name.
    #   remote_directory: 'my.s3.bucket'
    #   # Use multipart uploads when file size reaches 100MB, see
    #   #  http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
    #   multipart_chunk_size: 104857600
    #   # Turns on AWS Server-Side Encryption with Amazon S3-Managed Keys for backups, this is optional
    #   # encryption: 'AES256'
    #   # Specifies Amazon S3 storage class to use for backups, this is optional
    #   # storage_class: 'STANDARD'

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
    # The next value is the maximum memory size grit can use
    # Given in number of bytes per git object (e.g. a commit)
    # This value can be increased if you have very large commits
    max_size: 20971520 # 20.megabytes
    # Git timeout to read a commit, in seconds
    timeout: 10

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
      - 172.17.0.0/16

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