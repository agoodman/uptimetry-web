class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery

  def valid_subscription?
    upgrade_required unless current_user.site_allowance>=current_user.endpoints.count
  end

  def upgrade_required
    redirect_to plans_path, :alert => "You must upgrade to continue" and return
  end
  
end
