class WelcomeController < ApplicationController

  before_filter :check_signed_in
  
  def index
  end

  private
  
  def check_signed_in
    redirect_to domains_path and return false if signed_in?
  end
  
end
