require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  should belong_to :user
  should have_many :nodes
  
  should validate_presence_of :user_id
  should validate_presence_of :url
  should validate_presence_of :max_crawls

end
