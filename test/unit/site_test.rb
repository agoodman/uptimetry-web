require 'test_helper'

class SiteTest < ActiveSupport::TestCase

  should belong_to :user
  
  should validate_presence_of :user_id
  should validate_presence_of :url
  should validate_presence_of :email

  context "with valid url" do
    setup do
      @user = Factory(:user)
      @site = Site.new(:user_id => @user.id, :url => "http://valid.url/path/to/resource", :email => "info@example.com")
    end
    
    should "validate successfully" do
      assert(!@site.invalid?)
    end
  end
  
  context "with invalid url" do
    setup do
      @user = Factory(:user)
      @site = Site.new(:user_id => @user.id, :url => "jimmy", :email => "info@example.com")
    end
    
    should "not validate successfully" do
      assert(@site.invalid?)
    end
  end
  
end
