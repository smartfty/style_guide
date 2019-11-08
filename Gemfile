# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use sqlite3 as the database for Active Record
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

gem 'pg', '~> 0.20'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platform: :mri
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'minitest-spec-rails'
  gem 'pry-byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0' 
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'annotate'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


gem 'griddler'

# gem 'high_voltage'
# gem 'jquery-ace-rails'
# gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap_form'
gem 'carrierwave', "~> 1.2.3"
gem 'rest-client'
gem 'simple_form', '~> 4.0.1'
gem 'sinatra', '~> 2.0.1'

gem 'bootstrap-kaminari-views'
gem 'bootstrap-sass'
gem 'browser'
gem 'devise'
gem 'devise-i18n'
gem 'faker'
gem 'font-awesome-rails'
gem 'hexapdf'
gem 'kaminari'
gem 'rails_layout'
gem 'ransack'
gem 'rubypants-unicode'
gem 'seed_dump'
gem 'whenever'

gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'mechanize'
gem 'momentjs-rails', '>= 2.9.0'
gem 'rubyzip', '>= 1.0.0'
gem 'zip-zip'
# gem 'pgreset', '~> 0.1.1'
gem 'friendly_id', '~> 5.2', '>= 5.2.4'
gem 'simplecov', require: false, group: :test

group :development, :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2', require: false
  # gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rails-controller-testing'
end

# gem 'bullet', group: 'development'
# gem 'rack-cors', require: 'rack/cors'

gem 'ajax-datatables-rails'
gem 'jquery-datatables'
gem 'rails-assets-trix', source: 'https://rails-assets.org'

gem 'ancestry'
gem 'happymapper'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'stateful_enum'
gem 'sucker_punch'

gem 'guard'
gem 'guard-rake'
gem 'guard-shell'
gem 'guard-remote-sync', '~> 0.1.0'

# gem 'rlayout', :path => "/Users/mskim/Development/ruby/gems/rlayout"

gem 'image_processing', '~> 1.2'
gem 'simple_calendar', '~> 2.0'

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
