class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.integer :src_id
      t.integer :dst_id
      t.boolean :directed
      t.boolean :reversed

      t.timestamps
    end
    add_index :edges, [ :src_id ]
    add_index :edges, [ :dst_id ]
    add_index :edges, [ :src_id, :dst_id ]
  end
end
