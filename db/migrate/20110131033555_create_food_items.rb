class CreateFoodItems < ActiveRecord::Migration
  def self.up
    create_table :food_items do |t|
      t.integer :site_id
      t.string :name
      t.string :brand

      t.timestamps
    end
  end

  def self.down
    drop_table :food_items
  end
end
