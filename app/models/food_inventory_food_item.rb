# == Schema Information
# Schema version: 20110213051823
#
# Table name: food_inventory_food_items
#
#  id                :integer         not null, primary key
#  food_inventory_id :integer
#  food_item_id      :integer
#  quantity          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class FoodInventoryFoodItem < ActiveRecord::Base
  attr_accessible :food_item_id, :quantity

  belongs_to :food_item
  belongs_to :food_inventory

  validates :food_inventory_id, :presence => true
  validates :food_item_id, :presence => true
  validates :quantity, :presence => true

  def validate_units
    begin
      self.quantity.unit
      errors.add(:quantity, "Base unit should be a unit of weight, volumn, or each") unless [:unitless, :mass, :volume].include? self.quantity.unit.kind
      errors.add(:quantity, "the units entered are a measure of #{self.size.unit.kind.to_s.humanize}, while #{self.food_item.name} requires a unit of #{self.food_item.base_unit.unit.kind.to_s.humanize} to convert") unless(self.food_item.nil? || self.food_item.base_unit.unit =~ self.size.unit)
    rescue
      errors.add(:quantity, "#{self.quantity} does not use recogized units")
    end
  end
end
