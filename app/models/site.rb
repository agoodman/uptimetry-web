class Site < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :url, :email
  
end
