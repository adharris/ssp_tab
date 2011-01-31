class ChangeVendorZipToString < ActiveRecord::Migration
  def self.up
    change_column :vendors, :zip, :string
  end

  def self.down
    change_column :vendors, :zip, :integer
  end
end
