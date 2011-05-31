module SitesHelper

  def status_for(site)
    if site.up
      "OK"
    elsif site.down_count==1
      "WARN"
    else
      "Last Successful Attempt: " + (site.last_successful_attempt.nil? ? 'Never' : site.last_successful_attempt.to_s(:long))
    end
  end
  
end
