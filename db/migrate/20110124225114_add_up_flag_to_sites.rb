class AddUpFlagToSites < ActiveRecord::Migration

  def self.up
    add_column :sites, :up, :boolean, :default => true
  end

  def self.down
    remove_column :sites, :up
  end
  
end
