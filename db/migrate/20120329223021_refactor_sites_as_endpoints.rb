class RefactorSitesAsEndpoints < ActiveRecord::Migration

  def self.up
    rename_table :sites, :endpoints
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end
