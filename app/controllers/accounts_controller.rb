class AccountsController < ApplicationController

  before_filter :authenticate
  
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if ! @user.update_attributes(params[:user])
      flash[:error] = @user.errors.full_messages.join('<br/>')
    end
    redirect_to account_path
  end
  
end
