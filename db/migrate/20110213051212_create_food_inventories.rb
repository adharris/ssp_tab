class CreateFoodInventories < ActiveRecord::Migration
  def self.up
    create_table :food_inventories do |t|
      t.integer :program_id
      t.date :date

      t.timestamps
    end

    add_index :food_inventories, :program_id
  end

  def self.down
    drop_table :food_inventories
  end
end
