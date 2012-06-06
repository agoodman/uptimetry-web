require 'net/https'
require 'uri'
require 'nokogiri'

class MonitoringWorker < IronWorker::Base

  attr_accessor :url, :secret_key, :css_selector, :xpath
  
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
    http.use_ssl = true if uri.port == 443
    request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
    response = http.request(request)
    case response
    when Net::HTTPSuccess     then return match(response.body)
    when Net::HTTPRedirection then return monitor(response['location'], limit - 1)
    else 
      return false
    end
  rescue Exception => e
    log "Error encountered: #{e}"
    return false
  end
  
  def match(body)
    return true if css_selector.nil? && xpath.nil?
    doc = Nokogiri::HTML(body)
    if ! css_selector.blank?
      matches = doc.css(css_selector)
      if ! matches.empty?
        log "Matched content by CSS selector"
        return true
      end
    end
    if ! xpath.blank?
      matches = doc.xpath(xpath)
      if ! matches.empty?
        log "Matched content by XPath"
        return true
      end
    end
    log "Unable to match content"
    return false
  rescue Exception => e
    log "Error encountered: #{e}"
    return false
  end
  
  def callback(up)
    if up
      url = "http://uptimetry.com/endpoints/#{secret_key}/up"
    else
      url = "http://uptimetry.com/endpoints/#{secret_key}/down"
    end
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      log "Successfully called back to #{url}"
    else
      log "Unable to call back to #{url}: received #{response}"
    end
  end
  
end
