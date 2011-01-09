require 'shoulda'
require 'clearance'

class Api::SessionsControllerTest < ActionController::TestCase

  context "on post create" do
    setup do
      sign_out
      @user = Factory(:user, :email_confirmed => true)
      post :create, :format => 'json', :session => { :email => @user.email, :password => @user.password }
    end
    
    should respond_with :success
  end
  
  context "on delete destroy" do
    setup do
      @user = Factory(:user)
      sign_in_as(@user)
      delete :destroy, :format => 'json'
    end
    
    should respond_with :success
  end
  
end
