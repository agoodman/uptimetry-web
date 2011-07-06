require 'digest/sha1'

module Enrollmint
  
  class << self
    attr_accessor :api_token, :sandbox, :bundle_identifier

    def configure
      yield self
      
      Base.user = api_token
      Base.password = 'x'
      if sandbox
        Base.site = "https://sandbox.enrollmint.com/apps/#{bundle_identifier}"
      else
        Base.site = "https://api.enrollmint.com/apps/#{bundle_identifier}"
      end
      # Customer.format = :json
      # Subscription.format = :json
      # Product.format = :json
    end
  end
  
  class Base < ActiveResource::Base
    # self.format = :json
    
    def self.element_name
      name.split(/::/).last.underscore
    end
  end
  
  class Customer < Base
  end
  
  class Subscription < Base
  end

  class Product < Base
  end
  
end