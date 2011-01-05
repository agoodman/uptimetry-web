require 'net/http'
require 'uri'

#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    user.sites.each do |site|
      if monitor(site.url)
        site.update_attribute(:last_successful_attempt, Time.now)
      else
        # send email
        SiteMailer.notify(site).deliver
      end
    end
  end
    
end

def monitor(url,limit=10)
  return false if limit == 0
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'cron' })
  response = http.request(request)
  case response
  when Net::HTTPSuccess     then return true
  when Net::HTTPRedirection then return monitor(response['location'], limit - 1)
  else 
    return false
  end
rescue
  return false
end
