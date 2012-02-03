#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    sites = user.sites.sort {|x,y| x.created_at<=>y.created_at}.take(user.site_allowance)
    sites.each do |site|
      monitoring_worker = MonitoringWorker.new
      monitoring_worker.url = site.url
      monitoring_worker.secret_key = site.secret_key
      monitoring_worker.css_selector = site.css_selector if site.css_selector
      monitoring_worker.xpath = site.xpath if site.xpath
      monitoring_worker.queue
    end
  end
    
end
