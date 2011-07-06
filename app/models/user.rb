class User < ActiveRecord::Base
  
  has_many :sites, :dependent => :destroy

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :site_allowance
  validates_presence_of :first_name, :last_name
  
  include Clearance::User

  # expects EnrollMint::Subscription
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

  SUBSCRIPTION_PLANS = {
    "com.uptimetry.subscription.micro" => 3,
    "com.uptimetry.subscription.small" => 5,
    "com.uptimetry.subscription.medium" => 10,
    "com.uptimetry.subscription.large" => 20,
    "com.uptimetry.subscription.jumbo" => 50
  }
  
end
