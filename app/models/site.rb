class Site < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :url, :email, :css_selector, :xpath
  
  validates_presence_of :user_id, :url, :email
  validates_format_of :url, :with => /http(s)?\:\/\/(.+)(\/)?(.*)/

  before_create :generate_secret_key
  before_create :init_down_count
  
  def generate_secret_key
    self.secret_key = Digest::SHA1.hexdigest("--#{email}--#{url}--")[0..9]
  end
  
  def init_down_count
    self.down_count = 0 unless down_count
  end
  
end
