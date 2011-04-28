class AddIndexToSites < ActiveRecord::Migration

  def self.up
    add_index :sites, :secret_key
  end

  def self.down
    remove_index :sites, :secret_key
  end
  
end
