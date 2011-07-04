require 'enrollmint'

if Rails.env!='test' then
  EnrollMint.configure do |config|
    config.sandbox = true
    config.api_token = '806ce0cdd2'
  end
end
