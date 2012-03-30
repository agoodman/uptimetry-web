require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  should belong_to :user
  should have_many :endpoints
  
  should validate_presence_of :user_id
  should validate_presence_of :name
  should validate_uniqueness_of :name
  
end
