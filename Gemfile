source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use sqlite3 as the database for Active Record
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

gem 'sqlite3'
gem 'pg', '~> 0.20'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails'
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
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platform: :mri
  gem 'minitest-spec-rails'
  gem 'pry-byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'griddler'
gem 'rails_layout'
gem 'bootstrap-sass'
# gem 'high_voltage'
# gem 'jquery-ace-rails'

gem 'kaminari'
# gem 'victor'
gem 'devise'
# gem 'smart_listing'
# gem 'css3-progress-bar-rails'
gem 'bootstrap_form'
gem 'simple_form'
gem 'rubypants-unicode'
gem 'carrierwave'
gem "font-awesome-rails"
# gem 'rmagick'
gem 'seed_dump'
gem "browser"

gem 'sinatra', '~> 2.0.1'
gem 'rest-client'
gem 'faker'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'ransack'
gem 'rubyzip', '>= 1.0.0'
gem 'zip-zip'
gem 'mechanize'
# gem "iconv", "~> 1.0.3"
gem 'whenever'
# gem 'pgreset', '~> 0.1.1'
gem 'friendly_id', '~> 5.2', '>= 5.2.4'

gem 'simplecov', require: false, group: :test

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2', require: false
  gem 'database_cleaner', '~> 1.7'
  # gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rails-controller-testing'
end

gem 'bullet', group: 'development'
# gem 'rack-cors', require: 'rack/cors'

gem 'rails-assets-trix', source: 'https://rails-assets.org'
gem 'jquery-datatables'
gem 'ajax-datatables-rails'
gem 'sidekiq'