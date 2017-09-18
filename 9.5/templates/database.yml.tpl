production:
  adapter: {{ getenv "DB_ADAPTER" "postgresql" }}
  encoding: unicode
  database: {{ getenv "DB_NAME" "gitlab" }}
  pool: 10
  username: {{ getenv "DB_NAME" "gitlab" }}
  password: {{ getenv "DB_PASS" "gitlab" }}
  host: {{ getenv "DB_HOST" "postgres" }}
  port: {{ getenv "DB_PORT" "5432" }}
