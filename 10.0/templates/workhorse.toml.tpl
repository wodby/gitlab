[redis]
URL = "{{ getenv "REDIS_URL" "tcp://redis:6379" }}"
Password = "{{ getenv "REDIS_PASSWORD" }}"
