class User < ActiveRecord::Base
  
  has_many :sites, :dependent => :destroy, :order => 'down_count desc, url asc'

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  validates_presence_of :first_name, :last_name
  
  include Clearance::User

end
