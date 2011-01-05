require 'shoulda'

class UserTest < ActiveSupport::TestCase
  
  should have_many :sites
  
  should validate_presence_of :first_name
  should validate_presence_of :last_name
  
end