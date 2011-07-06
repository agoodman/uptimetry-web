require 'enrollmint'

if Rails.env!='test' then
  Enrollmint.configure do |config|
    config.sandbox = true
    config.api_token = 'd04d10eb3a'
    config.bundle_identifier = 'com.uptimetry'
  end
end
