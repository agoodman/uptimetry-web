require 'test_helper'
require 'shoulda'
require 'clearance'
require 'factory_girl'

class AccountsControllerTest < ActionController::TestCase

  context "when not signed in" do
    setup do
      @user = Factory(:user)
      sign_out
    end

    context "on get show" do
      setup { get :show }
      should ('redirect to sign in'){redirect_to sign_in_path}
    end
  end
  
  context "when signed in" do
    setup do
      @user = Factory(:user)
      sign_in_as @user
    end
    
    context "on get show" do
      setup { get :show }
      should respond_with :success
      should assign_to :user
      should render_template :show
    end
  end
  
end
