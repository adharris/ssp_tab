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
  scope :for_program, lambda { |program| includes(:food_inventory).where('food_inventories.program_id = ?', program.id) }
  scope :after, lambda { |date| includes(:food_inventory).where('food_inventories.date >= ?', date) }

  # action callbacks
  before_save :update_calculated_fields, :unless => :skip_calculations?
  after_save :update_derived_fields, :unless => Proc.new {|item| item.skip_calculations? || item.skip_derivations? }
  after_destroy :update_derived_fields, :unless => Proc.new {|item| item.skip_calculations? || item.skip_derivations? }

  def consumed
    in_inventory - in_base_units
  end

  def consumed_units
    "#{consumed} #{food_item.base_unit}"
  end
  
  def in_inventory_units
    "#{in_inventory} #{food_item.base_unit}"
  end

  def total_price
    average_cost * consumed
  end

  def update_calculated_fields
    update_base_units
    update_in_inventory
    update_average_cost
  end

  def update_derived_fields
    FoodInventoryFoodItem.for_item(food_item).for_program(food_inventory.program).after(food_inventory.date).each do |item|
      unless item.id == self.id
        item.skip_derivations = true
        item.save
      end
    end
  end

  def update_in_inventory
    self.in_inventory = food_item.in_inventory_for_program_at(food_inventory.program, food_inventory.date)
  end


  def skip_derivations=(skip)
    @skip_derivations = skip
  end

  def skip_derivations?
    @skip_derivations
  end

  def skip_calculations=(skip)
    @skip_calculations = skip
  end

  def skip_calculations?
    @skip_calculations
  end

  private

  def update_base_units
    self.in_base_units = self.quantity.u.to(self.food_item.base_unit).abs
  end

  def update_average_cost
    self.average_cost = food_item.cost_of(food_inventory.program, food_inventory.date, consumed_units, quantity)
  end

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


end
