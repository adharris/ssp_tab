class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.integer :site_id, :null => false
      t.string :name, :null => false
      t.string :address, :null => false
      t.string :city, :null => false
      t.string :state, :null => false
      t.integer :zip, :null => false
      t.string :contact, :null => false
      t.string :phone, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
