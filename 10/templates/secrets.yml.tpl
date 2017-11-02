production:
  db_key_base: {{ getenv "GITLAB_SECRETS_DB_KEY_BASE" }}
  secret_key_base: {{ getenv "GITLAB_SECRETS_SECRET_KEY_BASE" }}
  otp_key_base: {{ getenv "GITLAB_SECRETS_OTP_KEY_BASE" }}

development:
  db_key_base: development

test:
  db_key_base: test
