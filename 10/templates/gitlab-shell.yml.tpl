#
# If you change this file in a Merge Request, please also create
# a Merge Request on https://gitlab.com/gitlab-org/omnibus-gitlab/merge_requests
#

# GitLab user. git by default
user: git

# URL to GitLab instance, used for API calls. Default: http://localhost:8080.
# For relative URL support read http://doc.gitlab.com/ce/install/relative_url.html
# You only have to change the default if you have configured Unicorn
# to listen on a custom port, or if you have configured Unicorn to
# only listen on a Unix domain socket. For Unix domain sockets use
# "http+unix://<urlquoted-path-to-socket>", e.g.
# "http+unix://%2Fpath%2Fto%2Fsocket"
gitlab_url: "{{ getenv "GITLAB_SHELL_GITLAB_URL" "http://gitlab:8080" }}"

# See installation.md#using-https for additional HTTPS configuration details.
http_settings:
#  read_timeout: 300
#  user: someone
#  password: somepass
#  ca_file: /etc/ssl/cert.pem
#  ca_path: /etc/pki/tls/certs
  self_signed_cert: false

# File used as authorized_keys for gitlab user
auth_file: "/home/git/.ssh/authorized_keys"

# File that contains the secret key for verifying access to GitLab.
# Default is .gitlab_shell_secret in the gitlab-shell directory.
secret_file: "{{ getenv "GITLAB_DIR" }}/.gitlab_shell_secret"

# Parent directory for global custom hook directories (pre-receive.d, update.d, post-receive.d)
# Default is hooks in the gitlab-shell directory.
# custom_hooks_dir: "/home/git/gitlab-shell/hooks"

# Redis settings used for pushing commit notices to gitlab
redis:
  bin: /usr/bin/redis-cli
  host: {{ getenv "GITLAB_SHELL_REDIS_HOST" "redis" }}
  port: {{ getenv "GITLAB_SHELL_REDIS_PORT" "6379" }}
  {{ if getenv "REDIS_PASS" }}
  pass: {{ getenv "REDIS_PASS" }}
  {{ end }}
  database: 0
#  socket: /var/run/redis/redis.sock # Comment out this line if you want to use TCP or Sentinel
  namespace: resque:gitlab
  # sentinels:
  #   -
  #     host: 127.0.0.1
  #     port: 26380
  #   -
  #     host: 127.0.0.1
  #     port: 26381


# Log file.
# Default is gitlab-shell.log in the root directory.
log_file: "/home/git/gitlab-shell/gitlab-shell.log"
#log_file: "/proc/self/fd/2"

# Log level. INFO by default
log_level: {{ getenv "GITLAB_SHELL_LOG_LEVEL" "DEBUG" }}

# Audit usernames.
# Set to true to see real usernames in the logs instead of key ids, which is easier to follow, but
# incurs an extra API call on every gitlab-shell command.
audit_usernames: {{ getenv "GITLAB_SHELL_AUDIT_USERNAMES" "false" }}

# Git trace log file.
# If set, git commands receive GIT_TRACE* environment variables
# See https://git-scm.com/book/es/v2/Git-Internals-Environment-Variables#Debugging for documentation
# An absolute path starting with / – the trace output will be appended to that file.
# It needs to exist so we can check permissions and avoid to throwing warnings to the users.
#git_trace_log_file: "/proc/self/fd/2"
log_file: "/home/git/gitlab-shell/gitlab-shell.log"