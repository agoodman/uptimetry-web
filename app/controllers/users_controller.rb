class UsersController < Clearance::UsersController
  
  def new
    @user = User.new    
  end
  
  private
  
  def url_after_create
    sites_path
  end
  
end
