class AddLastAttemptToSites < ActiveRecord::Migration

  def self.up
    add_column :sites, :last_successful_attempt, :timestamp
  end

  def self.down
    remove_column :sites, :last_successful_attempt
  end
  
end
