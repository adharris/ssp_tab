class RemoveBrandFromFoodItem < ActiveRecord::Migration
  def self.up
    remove_column :food_items, :brand
    add_column :food_items, :base_unit, :string
    add_column :food_items, :default_taxed, :boolean
    add_column :food_items, :food_category_id, :integer
    rename_column :food_items, :site_id, :program_id
  end

  def self.down
    add_column :food_items, :brand, :string
    remove_column :food_items, :base_unit
    remove_column :food_items, :default_taxed
    remove_column :food_items, :food_category_id
    rename_column :food_items, :program_id, :site_id
  end
end
