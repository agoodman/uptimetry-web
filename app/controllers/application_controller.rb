class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery

  def valid_subscription?
    upgrade_required unless current_user.site_allowance>=current_user.endpoints.count
  end

  def upgrade_required
    redirect_to plans_path, :alert => "You must upgrade to continue" and return
  end

  def deny_access
    respond_to do |format|
      format.html { redirect_to sign_in_path }
      format.json { render json: { errors: [ "You are not authorized" ] }, status: :unauthorized }
    end
  end
  
end
