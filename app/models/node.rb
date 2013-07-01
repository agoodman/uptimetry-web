class Node < ActiveRecord::Base
  
  belongs_to :order
  has_many :edges, foreign_key: 'src_id', dependent: :destroy
  has_many :linking_edges, foreign_key: 'dst_id', class_name: 'Edge', dependent: :destroy
  
  validates_presence_of :order_id, :url
  validates_uniqueness_of :url, scope: :order_id
  
  attr_accessible :url, :code, :content_type
  
  after_create :crawl
  
  # Graph traversal mechanism
  # 
  # 1. HTTP GET url
  # 2. Find any urls in response body
  # 3. Create nodes for any urls that don't already exist
  # 4. Create edges from this node to each of the new nodes
  def crawl
    rsp = HTTParty.head(url)
    
    self.update_attributes(code: rsp.code, content_type: rsp.content_type)
    
    if rsp.code!=200
      puts "error: #{rsp.code}"
      return
    end
    
    if rsp.content_type!="text/html"
      puts "ignoring content type #{rsp.content_type}"
      return
    end
    
    if order.reached_max_crawls?
      puts "max crawls reached attempting #{url}"
      return
    end      
    
    puts "crawling #{url}"
    rsp = HTTParty.get(url)
    
    doc = Nokogiri::HTML(rsp.body)
    
    hrefs = doc.xpath("//*/@href") + doc.xpath("//*/@src")
    
    urls = hrefs.map(&:value)
    
    puts "found urls:\n\t#{urls.join("\n\t")}"
    
    source_uri = URI.parse(url)
    for linked_url in urls
      uri = URI.parse(linked_url)
      if uri.host && !uri.host.match(source_uri.host)
        puts "ignoring external link #{linked_url}"
      else
        if uri.path && uri.path[0]=='/'
          formatted_url = "#{uri.scheme || source_uri.scheme}://#{uri.host || source_uri.host}#{uri.path}"
        else
          formatted_url = "#{uri.scheme || source_uri.scheme}://#{uri.host || source_uri.host}#{source_uri.path[0..source_uri.path.rindex('/')] rescue '/'}#{uri.path}"
        end
        node = order.nodes.find_or_create_by_url(formatted_url)
        edge = edges.create(dst_id: node.id, directed: true)
        puts "found edge to #{formatted_url}"
      end
    end
    
  rescue => e
    puts "caught exception: #{e}"
    true
  end
  
  handle_asynchronously :crawl
  
end
