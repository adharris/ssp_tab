class CreateFoodInventoryFoodItems < ActiveRecord::Migration
  def self.up
    create_table :food_inventory_food_items do |t|
      t.integer :food_inventory_id
      t.integer :food_item_id
      t.string :quantity

      t.timestamps
    end

    add_index :food_inventory_food_items, :food_item_id
    add_index :food_inventory_food_items, :food_inventory_id
  end

  def self.down
    drop_table :food_inventory_food_items
  end
end
