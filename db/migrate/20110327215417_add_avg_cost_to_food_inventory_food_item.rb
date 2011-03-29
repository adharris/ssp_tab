class AddAvgCostToFoodInventoryFoodItem < ActiveRecord::Migration
  def self.up
    add_column :food_inventory_food_items, :average_cost, :decimal
    FoodInventoryFoodItem.reset_column_information
    FoodInventoryFoodItem.all.each do |i|
      i.average_cost = i.food_item.cost_of(i.food_inventory.program, i.food_inventory.date, i.consumed_units, i.quantity)
      i.save
    end
  end

  def self.down
    remove_column :food_inventory_food_items, :average_cost
  end
end
