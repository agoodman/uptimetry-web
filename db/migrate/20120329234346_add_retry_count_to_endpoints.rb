class AddRetryCountToEndpoints < ActiveRecord::Migration

  def self.up
    add_column :endpoints, :retry_count, :integer, default: 3
    Endpoint.update_all(retry_count: 3)
  end

  def self.down
    remove_column :endpoints, :retry_count
  end

end
