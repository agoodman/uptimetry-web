class Api::ApiController < ApplicationController
  
  private
  
  def deny_access
    respond_to do |format|
      format.json { render :json => { :errors => [ 'You are not authorized to do that.' ] }, :status => :unauthorized }
    end
  end

  def upgrade_required
    respond_to do |format|
      format.json { render :json => { :errors => [ 'You must upgrade your subscription to add more sites.' ] }, :status => :payment_required }
    end
  end
  
end
