class Device < ActiveRecord::Base

  belongs_to :user
  
  validates_presence_of :user_id, :token
  validates_uniqueness_of :token, scope: :user_id
  
  attr_accessible :user_id, :token

end
