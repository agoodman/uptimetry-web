require 'net/http'

class Heroku
  
  PLANS = { 'micro' => 3, 
    'small' => 5, 
    'medium' => 10, 
    'large' => 20, 
    'jumbo' => 50 }

  def self.nav
    @@nav_cache ||= nav_from_remote
    @@nav_cache
  end
  
  def self.nav_from_remote
    puts "fetching heroku nav"
    uri = URI.parse('http://nav.heroku.com/v1/providers/header')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.port == 443
    request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent' => 'Mozilla/5.0 (Linux) Gecko/20101203 Firefox/3.6.13' })
    response = http.request(request)
    response.body
  end

end
