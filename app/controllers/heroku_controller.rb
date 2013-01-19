class HerokuController < ApplicationController

  before_filter :authenticate_heroku_user, except: [ :sso ]
  skip_before_filter :verify_authenticity_token
  
  # POST /heroku/resources
  def resources
    user = User.create!(first_name: "heroku", last_name: "user", email: "heroku#{rand*1000000}@uptimetry.com", password: Digest::SHA1.hexdigest("--#{Time.now}--"))
    respond_to do |format|
      format.json { render json: { id: user.id, config: { "UPTIMETRY_URL" => user_url(user) } }, status: :ok }
    end
  end
  
  # DELETE /heroku/resources/:id
  def destroy
    user = User.find(params[:id])
    user.destroy
    head :ok
  end
  
  # POST /heroku/sso
  def sso
    token = Digest::SHA1.hexdigest("#{params[:id]}:pPu2hXzTzTYX0RiJ:#{params[:timestamp]}")
    head 403 and return unless token==params[:token]
    head 403 and return if params[:timestamp].to_i < (Time.now - 5*60).to_i
    
    user = User.find(params[:id])
    head 404 and return unless user
    
    sign_in user
    response.set_cookie('heroku-nav-data', :value => params['nav-data'], :path => '/')
    redirect_to endpoints_path
  end
  
  private
    
  def authenticate_heroku_user
    deny_access and return unless authenticate_or_request_with_http_basic do |u,p|
      u=='uptimetry' && p=='8lsadeR5vL3y133c'
    end
  end
  
end
