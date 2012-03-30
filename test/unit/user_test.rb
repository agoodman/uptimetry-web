require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should have_many :domains
  should have_many :endpoints
  
  should validate_presence_of :first_name
  should validate_presence_of :last_name
  
end