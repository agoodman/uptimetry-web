class SessionsController < Clearance::SessionsController
  
  private
  
  def url_after_create
    sites_path
  end
  
  def url_after_destroy
    root_path
  end
  
  def flash_success_after_create
    flash[:notice] = 'User signed in.'
  end
  
  def flash_failure_after_create
    flash[:alert] = 'Bad email or password.'
  end
  
  def flash_success_after_destroy
    flash[:notice] = 'User signed out.'
  end
  
end
