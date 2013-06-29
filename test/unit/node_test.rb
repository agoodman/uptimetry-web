require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  should belong_to :order
  should have_many :edges
  
  should validate_presence_of :order_id
  should validate_presence_of :url
  
end
