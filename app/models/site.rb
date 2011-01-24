class Site < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :user_id, :url, :email, :up
  
  validates_presence_of :user_id, :url, :email
  
end
