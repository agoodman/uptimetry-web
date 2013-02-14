source 'http://rubygems.org'

gem 'rails', '3.1.11'
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
gem 'sass'
gem 'coffee-script'
gem 'json'
gem 'uglifier'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :production do
  gem 'thin'
  gem 'pg'
  gem 'hirefireapp'
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :test do
  gem 'factory_girl_rails', '1.4.0'
  gem 'shoulda'
end

