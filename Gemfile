source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.00', '< 2.0'
# Use Puma as the app server
gem 'puma', '>= 4.0'
# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'bootstrap-sass', '>= 3.3', '< 4.0'
#fast, efficient pagination gem
gem 'pagy'
#Enables lazy-loading of images
gem 'lazyload-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.1.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '>= 5.2'
# Fast JSON serializer by Netflix
gem 'fast_jsonapi'
# Use ActiveModel has_secure_password
gem 'bcrypt', '>= 3.1.7'
#temporary
gem 'mtg_sdk'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'pry'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'seed_dump'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'faker'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem on Windows machines
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]