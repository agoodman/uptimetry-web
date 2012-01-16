class PlansController < ApplicationController

  before_filter :authorize, :only => :select
  before_filter :retrieve_plans, :only => :index
  
  def index
  end

  def select
    redirect_to sites_path
  end
  
  private
  
  def retrieve_plans
    @plans = Stripe::Plan.all.data.sort {|x,y| x.amount <=> y.amount}
  end
  
end
