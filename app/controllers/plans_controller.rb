class PlansController < ApplicationController

  before_filter :authorize, :only => [ :create, :select ]
  before_filter :retrieve_plans, :only => :index
  
  def index
  end

  def create
    customer = Stripe::Customer.create(email: current_user.email, plan: params[:plan][:id], card: params[:plan][:token])

    current_user.site_allowance = User::SUBSCRIPTION_PLANS[params[:plan][:id]]

    current_user.customer_reference = customer.id
    current_user.card_last_four = customer.active_card.last4
    current_user.card_exp_month = customer.active_card.exp_month
    current_user.card_exp_year = customer.active_card.exp_year
    current_user.card_exp_month = customer.active_card.exp_month
    current_user.save
      
    redirect_to sites_path, :notice => "Your subscription is ready to use"
  rescue Stripe::InvalidRequestError => e
    redirect_to plans_path, :alert => e.message
  end
  
  def select
    allowance = User::SUBSCRIPTION_PLANS[params[:plan][:id]] or 0
    if allowance >= current_user.sites.count
      customer = Stripe::Customer.retrieve(current_user.customer_reference)
      customer.update_subscription(plan: params[:plan][:id], prorate: true)

      current_user.site_allowance = allowance
      current_user.save

      redirect_to plans_path, :notice => "Your subscription has been updated."
    else
      redirect_to plans_path, :alert => "You have too many URLs for that plan."
    end
  end
  
  private
  
  def retrieve_plans
    @plans = Stripe::Plan.all.data.sort {|x,y| x.amount <=> y.amount}
  end
  
end
