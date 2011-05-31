require 'test_helper'
require 'shoulda'

class SitesControllerTest < ActionController::TestCase
  
  context "with valid site" do
    setup do
      @user = Factory(:user)
    end
    
    context "with live url" do
      setup do
        @site = Factory(:site, :user => @user, :url => "http://uptimetry.com/sign_up", :email => "info@example.com", :down_count => 0, :up => true)
      end
      
      context "on get up" do
        setup do
          get :up, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(@site.down_count,0)}
        should ("assign up to true"){assert(@site.up)}
      end
      
      context "on get down" do
        setup do
          get :down, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 1"){assert_equal(@site.down_count,1)}
        should ("assign up to false"){assert(!@site.up)}
      end
      
    end
    
    context "with down count of 1" do
      setup do
        @site = Factory(:site, :user => @user, :url => "http://uptimetry.com/sign_up", :email => "info@example.com", :down_count => 1, :up => false)
      end
    
      context "on get up" do
        setup do
          get :up, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(@site.down_count,0)}
        should ("assign up to true"){assert(@site.up)}
      end
      
      context "on get down" do
        setup do
          get :down, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 2"){assert_equal(@site.down_count,2)}
        should ("assign up to false"){assert(!@site.up)}
        should have_sent_email.to("info@example.com")
      end
    end

    context "with down count of 2" do
      setup do
        @site = Factory(:site, :user => @user, :url => "http://uptimetry.com/sign_up", :email => "info@example.com", :down_count => 2, :up => false)
      end
    
      context "on get up" do
        setup do
          get :up, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 0"){assert_equal(@site.down_count,0)}
        should ("assign up to true"){assert(@site.up)}
      end
      
      context "on get down" do
        setup do
          get :down, :secret_key => @site.secret_key
        end
      
        should respond_with :success
        should ("assign down count to 3"){assert_equal(@site.down_count,3)}
        should ("assign up to false"){assert(!@site.up)}
        should_not have_sent_email
      end
    end
  end
  
end
