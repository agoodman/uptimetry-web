class AddSecretKeyToSites < ActiveRecord::Migration

  def self.up
    add_column :sites, :secret_key, :string
  end

  def self.down
    remove_column :sites, :secret_key
  end
  
end
