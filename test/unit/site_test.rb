require 'test_helper'
require 'shoulda'

class SiteTest < ActiveSupport::TestCase

  should belong_to :user
  
  should validate_presence_of :user_id
  should validate_presence_of :url
  should validate_presence_of :email
  
end
