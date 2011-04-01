class AddPositionToFoodItemCategories < ActiveRecord::Migration
  def self.up
    add_column :food_item_categories, :position, :integer
  end

  def self.down
    remove_column :food_item_categories, :position
  end
end
