class AddHerokuToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :heroku_id, :string
    add_column :users, :heroku_callback_url, :string
  end

  def self.down
    remove_column :users, :heroku_callback_url
    remove_column :users, :heroku_id
  end
end
