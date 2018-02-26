user: git
gitlab_url: "{{ getenv "GITLAB_SHELL_GITLAB_URL" "http://gitlab:8080" }}"
http_settings:
  self_signed_cert: false
auth_file: "/home/git/.ssh/authorized_keys"
secret_file: "{{ getenv "GITLAB_DIR" }}/.gitlab_shell_secret"
log_file: "/proc/self/fd/2"
log_level: {{ getenv "GITLAB_SHELL_LOG_LEVEL" "WARN" }}
audit_usernames: {{ getenv "GITLAB_SHELL_AUDIT_USERNAMES" "false" }}
git_trace_log_file:
