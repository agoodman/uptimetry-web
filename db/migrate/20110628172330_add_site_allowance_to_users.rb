class AddSiteAllowanceToUsers < ActiveRecord::Migration

  def self.up
    add_column :users, :site_allowance, :integer, :default => 0
  end

  def self.down
    remove_column :users, :site_allowance
  end
  
end
