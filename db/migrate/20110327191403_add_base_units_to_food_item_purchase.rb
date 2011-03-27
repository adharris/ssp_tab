class AddBaseUnitsToFoodItemPurchase < ActiveRecord::Migration
  def self.up
    add_column :food_item_purchases, :total_base_units, :decimal
    FoodItemPurchase.reset_column_information
    FoodItemPurchase.all.each do |f|
      f.update_attribute :total_base_units, (f.quantity * f.size.u).to(f.food_item.base_unit).abs
    end
  end

  def self.down
    remove_column :food_item_purchases, :in_base_units
  end
end
