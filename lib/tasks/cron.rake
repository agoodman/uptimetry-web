#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    user.sites.each do |site|
      monitoring_worker = MonitoringWorker.new
      monitoring_worker.url = site.url
      monitoring_worker.secret_key = site.secret_key
      monitoring_worker.queue
    end
  end
    
end
