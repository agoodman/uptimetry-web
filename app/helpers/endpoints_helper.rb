module EndpointsHelper

  def status_for(endpoint)
    if endpoint.up
      "OK"
    elsif endpoint.down_count==1
      "WARN"
    else
      "Last Successful Attempt: " + (endpoint.last_successful_attempt.nil? ? 'Never' : endpoint.last_successful_attempt.to_s(:long))
    end
  end
  
end
