class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :order_id
      t.string :url
      t.integer :code
      t.string :content_type

      t.timestamps
    end
    add_index :nodes, [ :order_id ]
    add_index :nodes, [ :url ]
  end
end
