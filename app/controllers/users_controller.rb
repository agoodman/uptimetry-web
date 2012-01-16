class UsersController < Clearance::UsersController
  
  def new
    @user = User.new    
  end
  
  def update
    @user = current_user
    if ! @user.update_attributes(params[:user])
      flash[:error] = @user.errors.full_messages.join('<br/>')
    end
    redirect_to account_path
  end
  
  private

  def url_after_create
    plans_path
  end
  
  def flash_notice_after_create
    flash[:notice] = 'User successfully created. Please sign in'
  end
  
end
