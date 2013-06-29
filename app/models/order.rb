class Order < ActiveRecord::Base
  
  belongs_to :user
  has_many :nodes, dependent: :destroy
  has_many :edges, through: :nodes
  has_many :linking_edges, through: :nodes
  
  validates_presence_of :user_id, :url, :max_crawls
  
  attr_accessible :max_crawls, :url, :user_id
  
  before_validation :default_max_crawls
  after_create :fulfill
  
  def default_max_crawls
    self.max_crawls = 100 if max_crawls.blank?
  end
  
  def fulfill
    nodes.create(url: url)
  end
  
  def reached_max_crawls?
    nodes.count>=max_crawls
  end
  
end
