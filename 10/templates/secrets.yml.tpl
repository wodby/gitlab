production:
  db_key_base: {{ getenv "GITLAB_SECRETS_DB_KEY_BASE" }}
  secret_key_base: {{ getenv "GITLAB_SECRETS_SECRET_KEY_BASE" }}
  otp_key_base: {{ getenv "GITLAB_SECRETS_OTP_KEY_BASE" }}
  openid_connect_signing_key: {{ getenv "GITLAB_SECRETS_OPENID_CONNECT_SIGNING_KEY" }}

development:
  db_key_base: development

test:
  db_key_base: test
