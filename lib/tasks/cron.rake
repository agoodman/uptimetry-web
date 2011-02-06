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
        site.update_attributes(:last_successful_attempt => Time.now, :up => true)
      else
        # send email only if site was up at last attempt
        if site.up
          site.update_attributes(:up => false)
          SiteMailer.notify(site).deliver
        end
      end
    end
  end
    
end

def monitor(url,limit=10)
  return false if limit == 0
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
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
