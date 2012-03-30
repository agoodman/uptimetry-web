class Domain < ActiveRecord::Base

  belongs_to :user
  has_many :endpoints
  
  validates_presence_of :user_id, :name
  validates_uniqueness_of :name, scope: :user_id
  
  def self.for_url(url,user_id)
    domain_name = URI.parse(url).host
    re = /^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$/i
    root_domain = domain_name.gsub(re, '\1').strip
    find_or_create_by_user_id_and_name(user_id, root_domain)  
  end
  
end
