require 'enrollmint'

if Rails.env!='test' then
  Enrollmint.configure do |config|
    config.sandbox = true
    config.api_token = 'd04d10eb3a'
  end
end
