class AddConsumedToFoodInventoryFoodItem < ActiveRecord::Migration
  def self.up
    add_column :food_inventory_food_items, :in_inventory, :decimal
    FoodInventoryFoodItem.reset_column_information
    FoodInventoryFoodItem.all.each do |i|
      i.update_attribute :in_inventory, i.food_item.in_inventory_for_program_at(i.food_inventory.program, i.food_inventory.date)
    end
  end

  def self.down
    remove_column :food_inventory_food_items, :in_inventory
  end
end
