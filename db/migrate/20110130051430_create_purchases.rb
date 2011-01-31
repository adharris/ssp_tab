class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.integer :program_id
      t.integer :vendor_id
      t.date :date
      t.integer :purchaser_id
      t.decimal :total, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
