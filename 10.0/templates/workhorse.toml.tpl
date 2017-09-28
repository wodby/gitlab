[redis]
URL = "tcp://{{ getenv "REDIS_HOST" "redis" }}:{{ getenv "REDIS_PORT" "6379" }}"
{{ if getenv "REDIS_PASS" }}
Password = "{{ getenv "REDIS_PASS" }}"
{{ end }}
