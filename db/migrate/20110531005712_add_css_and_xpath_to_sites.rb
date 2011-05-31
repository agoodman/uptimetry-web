class AddCssAndXpathToSites < ActiveRecord::Migration

  def self.up
    add_column :sites, :css_selector, :string
    add_column :sites, :xpath, :string
  end

  def self.down
    remove_column :sites, :css_selector
    remove_column :sites, :xpath
  end
  
end
