class BillingController < ApplicationController
  
  def post_back
    puts params.to_s
    head :ok
  end

end
