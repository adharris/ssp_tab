class AddDefaultToFoodItemsDefaultTaxed < ActiveRecord::Migration
  def self.up
    change_column_default :food_items, :default_taxed, false
  end

  def self.down
    change_column_default :food_items, :default_taxed, nil
  end
end
