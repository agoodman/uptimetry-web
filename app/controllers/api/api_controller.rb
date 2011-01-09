class Api::ApiController < ApplicationController
  
  private
  
  def deny_access
    respond_to do |format|
      format.json { render :json => { :errors => [ 'You are not authorized to do that.' ] }, :status => :unauthorized }
    end
  end
  
end
