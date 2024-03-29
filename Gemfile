source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 2.7.0"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "activerecord-pg_enum"
gem "ancestry"
gem "bootsnap", require: false
gem "delayed_job_active_record"
gem "diffy"
gem "high_voltage"
gem "hiredis"
gem "image_processing"
gem "inline_svg"
gem "jbuilder"
gem "kaminari"
gem "kramdown"
gem "lograge"
gem "omniauth"
gem "omniauth-github"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paper_trail"
gem "pg"
gem "puma"
gem "rails", "~> 6.1.3"
gem "redis"
gem "sass-rails"
gem "scenic"
gem "sentry-raven"
gem "sequenced"
gem "turbolinks"
gem "webpacker"

group :development, :test do
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "guard"
  gem "guard-livereload"
  gem "guard-minitest"
end

group :development do
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "json-schema"
  gem "minitest-ci"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :production do
  gem "appsignal"
  gem "google-cloud-storage", require: false
end
