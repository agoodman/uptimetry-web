class AccountsController < ApplicationController

  before_filter :authorize
  
  def show
    @user = current_user
  end

end
