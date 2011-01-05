class User < ActiveRecord::Base
  
  has_many :sites
  
  validates_presence_of :first_name, :last_name
  
  include Clearance::User

end
