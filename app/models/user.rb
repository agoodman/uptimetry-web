class User < ActiveRecord::Base

  has_many :domains, dependent: :destroy, order: 'name asc'
  # has_many :endpoints, through: :domains, :order => 'down_count desc, url asc'
  has_many :devices, dependent: :destroy

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  validates_presence_of :first_name, :last_name
  
  before_create :set_default_allowance
  before_create :generate_api_token
  
  include Clearance::User

  def endpoints
    domains.map(&:endpoints).flatten
  end
  
  def set_default_allowance
    self.site_allowance = 0
  end

  def generate_api_token
    self.api_token = Digest::SHA1.hexdigest("--#{email}--#{Time.now}--")[0..9]
  end
  
  # functionally deprecated; users can always add endpoints; only paid users get monitoring
  def may_create_endpoints?
    true
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
    "com.uptimetry.manual.micro.month" => 3,
    "com.uptimetry.manual.small.month" => 5,
    "com.uptimetry.manual.medium.month" => 10,
    "com.uptimetry.manual.large.month" => 20,
    "com.uptimetry.manual.jumbo.month" => 50
  }
  
end
