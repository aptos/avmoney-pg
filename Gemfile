source 'https://rubygems.org'

ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

gem 'pg'

gem 'foreman'
# server
gem 'unicorn'

# authentication
gem 'omniauth'
gem 'omniauth-google-oauth2'

# Abort requests that are taking too long; a Rack::Timeout::Error will be raised.
# unicorn or other thread-safe server must be used.
gem "rack-timeout"

# cache
gem 'rack-cache'
gem 'dalli'
gem 'memcachier'

# static config file support
gem 'global'

# javascript assets
gem 'underscore-rails'
gem 'jquery-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'quiet_assets', :group => :development

# icon fonts
gem "font-awesome-rails", '~> 4.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Serve up precompiled compressed assets.
group :production, :staging do
  gem 'rails_12factor'
end

# PDF print support
gem 'wisepdf'
gem 'wkhtmltopdf-binary'

group :test, :development do
	gem "rspec-rails", "~> 2.14"
	gem "factory_girl_rails", "~> 4.0"
  gem 'database_cleaner'
	gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'pry'
  gem 'pry-byebug'
end