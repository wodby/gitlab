# # Optional: listen on a TCP socket. This is insecure (no authentication)
listen_addr = "0.0.0.0:9999"
#

# # Optional: export metrics via Prometheus
# prometheus_listen_addr = "localhost:9236"
#

# # Git executable settings
[git]
bin_path = "/usr/bin/git"

[[storage]]
name = "default"
path = "{{ getenv "GITLAB_REPOS_DIR" }}"

# # You can optionally configure more storages for this Gitaly instance to serve up
#
# [[storage]]
# name = "other_storage"
# path = "/mnt/other_storage/repositories"
#

# # You can optionally configure Gitaly to output JSON-formatted log messages to stdout
# [logging]
# format = "json"
# # Additionally exceptions can be reported to Sentry
# sentry_dsn = "https://<key>:<secret>@sentry.io/<project>"

# # You can optionally configure Gitaly to record histogram latencies on GRPC method calls
# [prometheus]
# grpc_latency_buckets = [0.001, 0.005, 0.025, 0.1, 0.5, 1.0, 10.0, 30.0, 60.0, 300.0, 1500.0]

[gitaly-ruby]
# The directory where gitaly-ruby is installed
dir = "/home/git/gitaly-ruby"

[gitlab-shell]
# The directory where gitlab-shell is installed
dir = "{{ getenv "GITLAB_SHELL_DIR" }}"