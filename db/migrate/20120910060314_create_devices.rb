class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
