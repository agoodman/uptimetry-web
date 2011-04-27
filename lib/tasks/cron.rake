#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    user.sites.each do |site|
      monitoring_worker = MonitoringWorker.new(:url => site.url, :secret_key => site.secret_key)
      monitoring_worker.queue
    end
  end
    
end
