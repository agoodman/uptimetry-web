require 'net/http'
require 'uri'

class MonitoringWorker < SimpleWorker::Base

  attr_accessor :url, :secret_key
  
  def run
    if monitor(url)
      log "Successfully retrieved #{url}"
      callback(true)
    else
      log "Unable to retrieve #{url}"
      callback(false)
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
  
  def callback(up)
    if up
      url = "http://uptimetry.com/sites/#{secret_key}/up"
    else
      url = "http://uptimetry.com/sites/#{secret_key}/down"
    end
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
    response = http.request(request)
    if response != Net::HTTPSuccess
      log "Unable to call back to #{url}"
    end
  end
  
end
