class Api::SessionsController < Api::ApiController
  
  def create
    @user = ::User.authenticate(params[:session][:email], params[:session][:password])
    respond_to do |format|
      if @user
        format.json { render :json => @user.to_json(:only => [:user_id, :remember_token])}
      else
        format.json { render :json => { :errors => [ 'Email and password does not match.' ] }, :status => :unprocessible_entity }
      end
    end
  end
  
  def destroy
    sign_out
    head :ok
  end
  
end
