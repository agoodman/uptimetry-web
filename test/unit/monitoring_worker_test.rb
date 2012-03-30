require 'test_helper'

class MonitoringWorkerTest < ActiveSupport::TestCase

  context "for http://uptimetry.com/sign_up" do
    setup do
      @user = Factory(:user)
      @domain = Factory(:domain, user: @user)
      @endpoint = Endpoint.new(domain_id: @domain.id, url: "http://uptimetry.com/sign_up", email: "info@example.com", css_selector: "#user_email")
      @worker = MonitoringWorker.new
      @worker.url = @endpoint.url
      @worker.secret_key = @endpoint.secret_key
      @worker.css_selector = @endpoint.css_selector if @endpoint.css_selector
      @worker.xpath = @endpoint.xpath if @endpoint.xpath
    end
    
    should "monitor successfully" do
      assert(@worker.monitor(@endpoint.url))
    end
  end
  
end
