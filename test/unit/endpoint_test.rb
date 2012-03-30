require 'test_helper'

class EndpointTest < ActiveSupport::TestCase

  should belong_to :domain
  
  should validate_presence_of :domain_id
  should validate_presence_of :url
  should validate_presence_of :email
  should validate_numericality_of :retry_count

  context "with valid url" do
    setup do
      @user = Factory(:user)
      @domain = Factory(:domain, user: @user)
      @endpoint = Endpoint.new(url: "http://valid.url/path/to/resource", email: "info@example.com", domain_id: @domain.id)
    end
    
    should "validate successfully" do
      assert(!@endpoint.invalid?)
    end
  end
  
  context "with invalid url" do
    setup do
      @user = Factory(:user)
      @domain = Factory(:domain, user: @user)
      @endpoint = Endpoint.new(url: "jimmy", email: "info@example.com", domain_id: @domain.id)
    end
    
    should "not validate successfully" do
      assert(@endpoint.invalid?)
    end
  end
  
end
