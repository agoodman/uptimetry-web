require 'enrollmint'

class SubscriptionsController < ApplicationController

  # enrollmint postback
  # POST /subscriptions/post_back.json
  def post_back
    for subscription_id in params[:_json]
      puts "retrieving subscription from EnrollMint for id=#{subscription_id}"
      begin
        subscription = EnrollMint::Subscription.find(subscription_id.to_i)
        unless subscription.nil?
          user = User.find_by_email(subscription.customer.email)
          user.update_with_subscription(subscription) unless user.nil?
        end
      rescue ActiveResource::ResourceNotFound
        puts "invalid susbcription id: #{subscription_id}"
      end
    end
    head :ok
  end

end