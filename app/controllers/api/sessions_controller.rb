class Api::SessionsController < Api::BaseController
  
  def create
    @user = ::User.authenticate(params[:session][:email], params[:session][:password])
    respond_to do |format|
      if @user.nil?
        format.json { render :json => { :errors => [ 'Email and password does not match.' ] }, :status => :unprocessable_entity }
      else
        sign_in(@user)
        format.json { render :json => { :session => { :api_token => @user.api_token } } }
      end
    end
  end
  
  def destroy
    sign_out
    head :ok
  end
  
end
