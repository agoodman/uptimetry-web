require 'enrollmint'

class BillingController < ApplicationController
  
  protect_from_forgery :except => :post_back
  
  def post_back
    puts params[:json].to_s
    response = JSON.parse(params[:json])
    if response['payment']['success']
      subscriptions = response['invoice']['lines']['subscriptions']
      # product_identifiers = subscriptions.collect {|s| s['plan']['id']}
      user = User.find_by_customer_reference(response['customer'])
      if user
        begin
          customer = Enrollmint::Customer.find_by_email(user.email)
        rescue ActiveResource::RecordNotFound
          customer = Enrollmint::Customer.create(email: user.email)
        end
        existing_identifiers = customer.subscriptions.map(&:product).compact.uniq.map(&:identifier).compact.uniq
        for subscription in subscriptions
          identifier = subscription.plan.id
          expiration_date = Time.at(subscription.period.end)
          if existing_identifiers.include?(identifier)
            sub = customer.subscriptions.select {|s| s.product.identifier==identifier}.first
            sub.expiration_date = expiration_date
            sub.save
          else
            product = Enrollmint::Product.find_by_identifier(identifier)
            sub = customer.create_subscription(product.id, expiration_date)
          end
        end
      end
    else
      puts "TODO: handle payment failure"
    end
    
    head :ok
  end

end
