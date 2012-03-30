#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    endpoints = user.endpoints.sort {|x,y| x.created_at<=>y.created_at}.take(user.site_allowance)
    for endpoint in endpoints
      monitoring_worker = MonitoringWorker.new
      monitoring_worker.url = endpoint.url
      monitoring_worker.secret_key = endpoint.secret_key
      monitoring_worker.css_selector = endpoint.css_selector if endpoint.css_selector
      monitoring_worker.xpath = endpoint.xpath if endpoint.xpath
      monitoring_worker.queue
    end
  end
    
end
