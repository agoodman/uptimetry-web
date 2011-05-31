class AddDownCountToSites < ActiveRecord::Migration

  def self.up
    add_column :sites, :down_count, :integer, :default => 0
  end

  def self.down
    remove_column :sites, :down_count
  end
  
end
