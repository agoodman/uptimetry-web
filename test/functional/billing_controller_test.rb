require 'test_helper'

class BillingControllerTest < ActionController::TestCase
  test "should get post_back" do
    get :post_back
    assert_response :success
  end

end
