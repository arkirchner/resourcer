source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 2.6.3"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "activerecord-pg_enum"
gem "ancestry"
gem "bootsnap", require: false
gem "delayed_job_active_record"
gem "diffy"
gem "image_processing"
gem "inline_svg"
gem "jbuilder"
gem "kaminari"
gem "kramdown"
gem "omniauth"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
gem "paper_trail"
gem "pg"
gem "puma"
gem "rails", "~> 6.0.2"
gem "sass-rails"
gem "turbolinks"
gem "webpacker"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
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
  gem "google-cloud-storage", require: false
  gem "stackdriver"
end
