source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 2.6.3"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "acts_as_tree"
gem "omniauth"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
gem "rails", "~> 6.0.2"
gem "pg"
gem "puma"
gem "sass-rails"
gem "webpacker"
gem "turbolinks"
gem "jbuilder"
gem "image_processing"
gem "inline_svg"
gem "bootsnap", require: false

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "guard"
  gem "guard-livereload"
  gem "guard-minitest"
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
end

group :test do
  gem "capybara"
  gem "json-schema"
  gem "minitest-ci"
  gem "selenium-webdriver"
  gem "webdrivers"
end
