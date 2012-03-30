class AddRetryDelayToEndpoints < ActiveRecord::Migration
  def self.up
    add_column :endpoints, :retry_delay, :integer, default: 30
  end

  def self.down
    remove_column :endpoints, :retry_delay
  end
end
