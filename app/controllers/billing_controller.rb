class BillingController < ApplicationController
  
  protect_from_forgery :except => :post_back
  
  def post_back
    puts params[:json].to_s
    head :ok
  end

end
