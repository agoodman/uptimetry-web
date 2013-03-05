source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'
gem 'nokogiri'
gem 'clearance', '0.12.0', :git => 'git://github.com/agoodman/clearance.git'
gem 'haml'
gem 'iron_worker_ng'
gem 'stripe'
gem 'jquery-rails'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'grocer'
gem 'httparty'
gem 'delayed_job_active_record'
gem 'newrelic_rpm'
gem 'json'
gem 'hirefireapp'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :production do
  gem 'thin'
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :test do
  gem 'factory_girl_rails', '1.4.0'
  gem 'shoulda'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end
