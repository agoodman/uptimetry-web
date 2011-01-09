require 'test_helper'
require 'shoulda'

class WelcomeControllerTest < ActionController::TestCase

  context "on get index" do
    setup { get :index }
    should respond_with :success
  end
  
end
