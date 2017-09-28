production:
  {{ if getenv "REDIS_PASS" }}
  url: redis://:{{ getenv "REDIS_PASS" }}@{{ getenv "REDIS_HOST" "redis" }}:{{ getenv "REDIS_PORT" "6379" }}
  {{ else }}
  url: redis://{{ getenv "REDIS_HOST" "redis" }}:{{ getenv "REDIS_PORT" "6379" }}
  {{ end }}