listen_addr = "0.0.0.0:9999"
bin_dir = "{{ getenv "GITALY_DIR" }}"

[git]
bin_path = "/usr/bin/git"

[[storage]]
name = "default"
path = "{{ getenv "GITLAB_REPOS_DIR" }}"

[gitaly-ruby]
dir = "{{ getenv "GITALY_DIR" }}/ruby"

[gitlab-shell]
dir = "{{ getenv "GITLAB_SHELL_DIR" }}"