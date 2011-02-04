class AddTaxToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :tax, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :purchases, :tax
  end
end
