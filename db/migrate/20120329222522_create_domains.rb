class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    
    add_index :domains, [ :user_id ]
    add_index :domains, [ :name ]
  end

  def self.down
    drop_table :domains
  end
end
