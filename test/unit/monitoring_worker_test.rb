require 'test_helper'

class MonitoringWorkerTest < ActiveSupport::TestCase

  context "for http://uptimetry.com/sign_up" do
    setup do
      @user = Factory(:user)
      @site = Site.new(:user_id => @user.id, :url => "http://uptimetry.com/sign_up", :email => "info@example.com", :css_selector => "#user_email")
      @worker = MonitoringWorker.new
      @worker.url = @site.url
      @worker.secret_key = @site.secret_key
      @worker.css_selector = @site.css_selector if @site.css_selector
      @worker.xpath = @site.xpath if @site.xpath
    end
    
    should "monitor successfully" do
      assert(@worker.monitor(@site.url))
    end
  end
  
end
