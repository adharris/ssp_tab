class AddInBaseUnitsToFoodInventoryFoodItems < ActiveRecord::Migration
  def self.up
    add_column :food_inventory_food_items, :in_base_units, :decimal
    FoodInventoryFoodItem.reset_column_information
    FoodInventoryFoodItem.all.each do |f|
      f.update_attribute :in_base_units, f.quantity.u.to(f.food_item.base_unit).abs
    end
  end

  def self.down
    remove_column :food_inventory_food_items, :in_base_units
  end
end
