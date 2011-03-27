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
  validate :validate_units
  # validates :quantity, :presence => true

  scope :for_item, lambda {|food_item| where('food_item_id = ?', food_item.id) }
  scope :for_program, lambda { |program|
    joins(:food_inventory).where('food_inventories.program_id = ?', program.id) }

  # action callbacks
  before_save :update_base_units

  def validate_units
    begin
      self.quantity.unit
      errors.add(:quantity, "Base unit should be a unit of weight, volumn, or each") unless [:unitless, :mass, :volume].include? self.quantity.unit.kind
      errors.add(:quantity, "the units entered are a measure of #{self.quantity.unit.kind.to_s.humanize}, while #{self.food_item.name} requires a unit of #{self.food_item.base_unit.unit.kind.to_s.humanize} to convert") unless(self.food_item.nil? || self.food_item.base_unit.unit =~ self.quantity.unit)
    rescue Exception => e
      #errors.add(:quantity, e.message)
      errors.add(:quantity, "#{self.quantity} does not use recogized units")
    end
  end

  def in_inventory
    food_item.in_inventory_for_program_at(food_inventory.program, food_inventory.date)
  end

  def consumed
    in_inventory - quantity.unit
  end

  def average_price
    food_item.cost_of(food_inventory.program, food_inventory.date, consumed, quantity).abs
  end

  def total_price
    average_price * consumed.abs
  end

  protected

  def update_base_units
    self.in_base_units = self.quantity.u.to(self.food_item.base_unit).abs
  end

end
