class CreateFoodItemCategories < ActiveRecord::Migration
  def self.up
    create_table :food_item_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :food_item_categories
  end
end
