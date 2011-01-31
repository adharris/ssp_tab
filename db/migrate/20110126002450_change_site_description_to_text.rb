class ChangeSiteDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :sites, :description, :text
  end

  def self.down
    change_column :sites, :description, :string
  end
end
