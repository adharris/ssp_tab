class RenameFoodItemCategoryColumn < ActiveRecord::Migration
  def self.up
    rename_column :food_items, :food_category_id, :food_item_category_id
  end

  def self.down
    rename_column :food_items, :food_item_category_id, :food_category_id
  end
end
