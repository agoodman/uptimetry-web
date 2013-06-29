require 'test_helper'

class EdgeTest < ActiveSupport::TestCase

  should belong_to :src
  should belong_to :dst
  
  should validate_presence_of :src
  should validate_presence_of :dst
  
end
