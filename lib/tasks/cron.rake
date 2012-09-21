#
# Hourly cron task
#
# Usage: rake cron
#
task :cron => :environment do

  User.all.each do |user| 
    endpoints = user.endpoints.sort {|x,y| x.created_at<=>y.created_at}.take(user.site_allowance)
    client = IronWorkerNG::Client.new
    for endpoint in endpoints
      attrs = { 
        url: endpoint.url, 
        secret_key: endpoint.secret_key, 
        css_selector: endpoint.css_selector,
        xpath: endpoint.xpath
        }
      client.tasks.create('monitor', attrs)
    end
  end
    
end
