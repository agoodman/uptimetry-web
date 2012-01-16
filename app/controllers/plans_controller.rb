class PlansController < ApplicationController

  before_filter :retrieve_plans, :only => :index
  
  def index
  end
  
  def retrieve_plans
    @plans = Stripe::Plan.all.data
  end
  
end
