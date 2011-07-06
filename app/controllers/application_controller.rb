class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery

  def valid_subscription?
    upgrade_required unless current_user.site_allowance>current_user.sites.count
  end

end
