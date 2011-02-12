class CreateFoodItemPurchases < ActiveRecord::Migration
  def self.up
    create_table :food_item_purchases do |t|
      t.integer :food_item_id, :null => false
      t.integer :purchase_id, :null => false
      t.decimal :quantity, :precision => 6, :scale => 2
      t.string :size
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :taxable, :default => false

      t.timestamps
    end

    add_index :food_item_purchases, :food_item_id
    add_index :food_item_purchases, :purchase_id
  end

  def self.down
    remove_index :food_item_purchases, :food_item_id
    remove_index :food_item_purchases, :purchase_id
    drop_table :food_item_purchases
  end
end
