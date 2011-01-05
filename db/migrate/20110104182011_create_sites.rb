class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :user_id
      t.string :url
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
