class ChangeVendorEmailZipToString < ActiveRecord::Migration
  def self.up
    change_column :vendors, :zip, :string
    change_column :vendors, :phone, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
