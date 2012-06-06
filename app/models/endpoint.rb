class Endpoint < ActiveRecord::Base
  
  belongs_to :domain
  
  attr_accessible :url, :email, :css_selector, :xpath, :retry_count, :retry_delay
  
  validates_presence_of :domain_id, :url, :email
  validates_format_of :url, :with => /http(s)?\:\/\/(.+)(\/)?(.*)/
  # validates_numericality_of :retry_count, minimum: 1, maximum: 5
  # validates_numericality_of :retry_delay, minimum: 10, maximum: 60

  before_create :generate_secret_key
  before_save :init_down_count
  before_destroy {|obj| Domain.delete(obj.domain_id) if obj.domain.endpoints.count==1}
  
  def generate_secret_key
    self.secret_key = Digest::SHA1.hexdigest("--#{email}--#{url}--")[0..9]
  end
  
  def init_down_count
    self.down_count = 0
  end
  
end