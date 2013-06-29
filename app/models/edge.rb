class Edge < ActiveRecord::Base

  belongs_to :src, class_name: 'Node'
  belongs_to :dst, class_name: 'Node'
  
  validates_presence_of :src_id, :dst_id
  
  attr_accessible :directed, :dst_id, :reversed, :src_id
  
  before_validation :default_direction
  
  def default_direction
    self.directed = false if directed.blank?
    self.reversed = false if reversed.blank?
    true
  end
  
end
