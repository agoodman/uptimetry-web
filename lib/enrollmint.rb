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
    def self.find_by_email(email)
      find(Digest::SHA1.hexdigest("--#{email}--")[0..9])
    end
    
    def create_subscription(product_identifier,expiration_date)
      product = Product.find_by_identifier(product_identifier)
      sub = Subscription.new(expiration_date: expiration_date, product_id: product.id, customer_id: id)
      sub.save
      sub
    end
  end
  
  class Subscription < Base
    def self.find_by_customer_email_and_product_identifier(email,identifier)
      find(Digest::SHA1.hexdigest("--#{identifier}--#{email}--")[0..9])
    end
  end

  class Product < Base
    def self.all
      all
    end
    
    def self.find_by_identifier(identifier)
      find(Digest::SHA1.hexdigest("--#{identifier}--")[0..9])
    end
  end
  
end