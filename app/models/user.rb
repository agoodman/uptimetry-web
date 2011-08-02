class User < ActiveRecord::Base
  
  has_many :sites, :dependent => :destroy, :order => 'down_count desc, url asc'

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :site_allowance
  validates_presence_of :first_name, :last_name
  
  before_create :set_default_allowance
  
  include Clearance::User

  def set_default_allowance
    self.site_allowance = 0
  end
  
  # expects Enrollmint::Subscription
  def update_with_subscription(subscription)
    if subscription.expiration_date<Time.now
      puts "subscription expired"
      self.update_attributes(:site_allowance => 0)
    else
      allowance = SUBSCRIPTION_PLANS[subscription.product.identifier]
      if allowance
        puts "subscription active: #{subscription.product.identifier}, allowance: #{allowance}"
        self.update_attributes(:site_allowance => allowance)
      else
        puts "unknown identifier: #{subscription.product.identifier}"
        self.update_attributes(:site_allowance => 0)
      end
    end
  end

  # expects Enrollmint::Customer
  def update_with_customer(customer)
    new_allowance = 0
    customer.subscriptions.each do |subscription|
      if subscription.expiration_date<Time.now
        puts "subscription expired: #{subscription.product_identifier}, allowance: +0"
      else
        allowance = SUBSCRIPTION_PLANS[subscription.product_identifier]
        if allowance
          puts "subscription active: #{subscription.product_identifier}, allowance: +#{allowance}"
          new_allowance += allowance
        else
          puts "unknown identifier: #{subscription.product_identifier}, allowance: +0"
        end
      end
    end
    self.update_attributes(:site_allowance => new_allowance)
    puts "customer: #{customer.email} allowance: #{site_allowance}"
  end
  
  SUBSCRIPTION_PLANS = {
    "com.uptimetry.subscription.micro" => 3,
    "com.uptimetry.subscription.small" => 5,
    "com.uptimetry.subscription.medium" => 10,
    "com.uptimetry.subscription.large" => 20,
    "com.uptimetry.subscription.jumbo" => 50
  }
  
end
