source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "rails", "~> 6.0.2"
gem "sqlite3"
gem "puma"
gem "sass-rails"
gem "webpacker"
gem "turbolinks"
gem "jbuilder"
gem "image_processing"
gem "bootsnap", require: false

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda"
  gem "webdrivers"
end
