# frozen_string_literal: true

source 'https://rubygems.org'
gem 'rails', '~> 8.0.2', '>= 8.0.2.1'

gem 'active_type'
gem 'bootsnap', require: false
gem 'bugsnag'
gem 'devise', '~> 4.9'
gem 'dotenv'
gem 'faker'
gem 'fivemat'
gem 'infinum_json_api_setup'
gem 'jsonapi_parameters'
gem 'jsonapi-query_builder'
gem 'json_schemer'
gem 'kamal', require: false
gem 'memoist'
gem 'pagy', '~> 8.6'
gem 'pg'
gem 'propshaft'
gem 'pry-byebug'
gem 'pry-rails'
gem 'puma', '>= 5.0'
gem 'pundit', '~> 2.5'
gem 'rack', '2.2.17'
gem 'responders'
gem 'secrets_cli'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'strong_migrations'
gem 'thruster', require: false

group :development, :test do
  gem 'debug', platforms: [:mri, :windows], require: 'debug/prelude'
  gem 'factory_bot_rails'
end

group :development do
  gem 'annotaterb'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'overcommit', require: false
  gem 'thor', require: false
end

group :test do
  gem 'capybara'
  gem 'dox', require: false
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
end

group :ci do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'license_finder', require: false
  gem 'rubocop-infinum', require: false
end
