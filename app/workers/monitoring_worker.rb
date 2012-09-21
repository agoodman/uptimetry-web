require 'net/https'
require 'uri'
require 'nokogiri'

def monitor(url,selector=nil,xpath=nil,limit=10)
  return false if limit == 0
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.port == 443
  request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
  response = http.request(request)
  case response
  when Net::HTTPSuccess     then return match(response.body, selector, xpath)
  when Net::HTTPRedirection then return monitor(response['location'], selector, xpath, limit - 1)
  else 
    return false
  end
rescue Exception => e
  puts "Error encountered: #{e}"
  return false
end

def match(body,css_selector,xpath)
  return true if (css_selector.nil? || css_selector.empty?) && (xpath.nil? || xpath.empty?)
  doc = Nokogiri::HTML(body)
  if ! (css_selector.nil? || css_selector.empty?)
    matches = doc.css(css_selector)
    if ! matches.empty?
      puts "Matched content by CSS selector"
      return true
    end
  end
  if ! (xpath.nil? || xpath.empty?)
    matches = doc.xpath(xpath)
    if ! matches.empty?
      puts "Matched content by XPath"
      return true
    end
  end
  puts "Unable to match content"
  return false
rescue Exception => e
  puts "Error encountered: #{e}"
  return false
end

def callback(up,secret_key)
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
    puts "Successfully called back to #{url}"
  else
    puts "Unable to call back to #{url}: received #{response}"
  end
end

puts params
if monitor(params[:url], params[:css_selector], params[:xpath])
  puts "Successfully retrieved #{params[:url]}"
  callback(true, params[:secret_key])
else
  puts "Unable to retrieve #{params[:url]}"
  callback(false, params[:secret_key])
end    

