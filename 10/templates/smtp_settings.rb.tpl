# To enable smtp email delivery for your GitLab instance do the following:
# 1. Rename this file to smtp_settings.rb
# 2. Edit settings inside this file
# 3. Restart GitLab instance
#
# For full list of options and their values see http://api.rubyonrails.org/classes/ActionMailer/Base.html
#
# If you change this file in a Merge Request, please also create a Merge Request on https://gitlab.com/gitlab-org/omnibus-gitlab/merge_requests

{{ if getenv "GITLAB_SMTP_ADDRESS" }}
if Rails.env.production?
  Rails.application.config.action_mailer.delivery_method = :smtp

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: "{{ getenv "GITLAB_SMTP_ADDRESS" }}",
    port: {{ getenv "GITLAB_SMTP_PORT" "25" }},
    {{ if (getenv "GITLAB_SMTP_USER") }}user_name: "{{ getenv "GITLAB_SMTP_USER" "" }}",{{ end }}
    {{ if (getenv "GITLAB_SMTP_PASSWORD") }}password: "{{ getenv "GITLAB_SMTP_PASSWORD" "" }}",{{ end }}
    {{ if (getenv "GITLAB_SMTP_DOMAIN") }}domain: "{{ getenv "GITLAB_SMTP_DOMAIN" "gitlab.company.com" }}",{{ end }}
    {{ if (getenv "GITLAB_SMTP_USER") }}authentication: :login,{{ end }}
    enable_starttls_auto: true,
    openssl_verify_mode: 'peer' # See ActionMailer documentation for other possible options
  }
end
{{ end }}
