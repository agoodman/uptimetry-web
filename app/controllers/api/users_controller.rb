class Api::UsersController < Api::BaseController
  
  before_filter :authorize, :except => :create

  def show
    @user = current_user
    respond_to do |format|
      format.json { render :json => @user.to_json(:except => [:salt, :encrypted_password]) }
      format.xml  { render :xml => @user.to_xml(:except => [:salt, :encrypted_password]) }
    end
  end

  def create
    if signed_in?
      respond_to do |format|
        format.json { render :json => { :errors => [ 'You must be signed out to do that.' ] }, :status => :unprocessable_entity }
        format.xml  { render :xml => { :errors => [ 'You must be signed out to do that.' ] }, :status => :unprocessable_entity }
      end
    else
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          format.json { render :json => @user.to_json(:except => [:salt, :encrypted_password]) }
          format.xml  { render :xml => @user.to_xml(:except => [:salt, :encrypted_password]) }
        else
          format.json { render :json => { :errors => @user.errors.full_messages }, :status => :unprocessable_entity }
          format.xml  { render :xml => { :errors => @user.errors.full_messages }, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def update
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.json { head :ok }
        format.xml  { head :ok }
      else
        format.json { render :json => { :errors => current_user.errors.full_messages }, :status => :unprocessable_entity }
        format.xml  { render :xml => { :errors => current_user.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(current_user.id)
    sign_out
    @user.destroy
    respond_to do |format|
      format.json { head :ok }
      format.xml  { head :ok }
    end
  end

end
