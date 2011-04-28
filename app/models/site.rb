class Site < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :user_id, :url, :email, :up, :last_successful_attempt
  
  validates_presence_of :user_id, :url, :email
  validates_format_of :url, :with => /http(s)?\:\/\/(.+)(\/)?(.*)/

  before_create :generate_secret_key
  
  def generate_secret_key
    self.secret_key = Digest::SHA1.hexdigest("--#{email}--#{url}--")[0..9]
  end
  
end
