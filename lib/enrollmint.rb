require 'digest/sha1'

module EnrollMint
  
  class << self
    attr_accessor :api_token, :sandbox

    def configure
      yield self
      
      Base.user = api_token
      Base.password = 'x'
      if sandbox
        Base.site ||= "https://sandbox.enrollmint.com"
      else
        Base.site ||= "https://api.enrollmint.com"
      end
      Base.format = :json
    end
  end
  
  class Base < ActiveResource::Base
  end
  
  class Customer < Base
  end
  
  class Subscription < Base
  end

  class Product < Base
  end
  
end