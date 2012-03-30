require 'test_helper'
require 'shoulda'

class EndpointsControllerTest < ActionController::TestCase
  
  context "with valid endpoint" do
    setup do
      @user = Factory(:user)
      @domain = Factory(:domain, user: @user)
    end
    
    context "with live url" do
      setup do
        @endpoint = Factory(:endpoint, domain: @domain, url: "http://uptimetry.com/sign_up", email: "info@example.com", down_count: 0, up: true)
      end
      
      context "on get up" do
        setup do
          get :up, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(assigns(:endpoint).down_count,0)}
        should ("assign up to true"){assert(assigns(:endpoint).up)}
      end
      
      context "on get down" do
        setup do
          get :down, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 1"){assert_equal(assigns(:endpoint).down_count,1)}
        should ("assign up to false"){assert(!assigns(:endpoint).up)}
      end
      
    end
    
    context "with down count of 1 and retry count of 3" do
      setup do
        @endpoint = Factory(:endpoint, domain: @domain, url: "http://uptimetry.com/sign_up", email: "info@example.com", down_count: 1, retry_count: 3, up: false)
      end
    
      context "on get up" do
        setup do
          get :up, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(assigns(:endpoint).down_count,0)}
        should ("assign up to true"){assert(assigns(:endpoint).up)}
        should_not have_sent_email
      end
      
      context "on get down" do
        setup do
          get :down, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 2"){assert_equal(assigns(:endpoint).down_count,2)}
        should ("assign up to false"){assert(!assigns(:endpoint).up)}
        should_not have_sent_email
      end
    end
   
    context "with down count of 3 and retry count of 3" do
      setup do
        @endpoint = Factory(:endpoint, domain: @domain, url: "http://uptimetry.com/sign_up", email: "info@example.com", down_count: 3, retry_count: 3, up: false)
      end
    
      context "on get up" do
        setup do
          get :up, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(assigns(:endpoint).down_count,0)}
        should ("assign up to true"){assert(assigns(:endpoint).up)}
        should_not have_sent_email
      end
      
      context "on get down" do
        setup do
          get :down, secret_key: @endpoint.secret_key
        end
      
        should respond_with :success
        should ("assign not increment down count"){assert_equal(assigns(:endpoint).down_count,3)}
        should ("assign up to false"){assert(!assigns(:endpoint).up)}
        should have_sent_email.to("info@example.com")
      end
    end
  end
  
end
