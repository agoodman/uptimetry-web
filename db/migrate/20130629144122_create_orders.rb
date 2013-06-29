class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :url
      t.integer :max_crawls

      t.timestamps
    end
    add_index :orders, [ :user_id ]
    add_index :orders, [ :url ]
  end
end
