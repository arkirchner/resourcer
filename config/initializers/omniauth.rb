OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
end
