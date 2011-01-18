class AddDescriptionToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :description, :string
  end

  def self.down
    remove_column :sites, :description
  end
end
