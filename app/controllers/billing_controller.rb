class BillingController < ApplicationController
  
  def post_back
    puts params[:json].to_s
    head :ok
  end

end
