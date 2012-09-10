require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  
  should belong_to :user
  
  should validate_presence_of :user_id
  should validate_presence_of :token
  
end
