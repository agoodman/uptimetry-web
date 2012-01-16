class AddBillingDetailsToUsers < ActiveRecord::Migration

  def self.up
    add_column :users, :customer_reference, :string
    add_column :users, :card_last_four, :string
    add_column :users, :card_exp_month, :string
    add_column :users, :card_exp_year, :string
    add_column :users, :card_type, :string
    add_column :users, :next_invoice_date, :date
  end

  def self.down
    remove_column :users, :customer_reference
    remove_column :users, :card_last_four
    remove_column :users, :card_exp_month
    remove_column :users, :card_exp_year
    remove_column :users, :card_type
    remove_column :users, :next_invoice_date
  end
  
end
