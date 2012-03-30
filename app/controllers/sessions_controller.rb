class SessionsController < Clearance::SessionsController

  layout 'users'
  
  private
  
  def url_after_create
    domains_path
  end
  
  def url_after_destroy
    root_path
  end
  
  def flash_success_after_create
  end
  
  def flash_failure_after_create
    flash[:alert] = 'Bad email or password.'
  end
  
  def flash_success_after_destroy
  end
  
end
