# == Schema Information
# Schema version: 20110211183716
#
# Table name: food_item_purchases
#
#  id           :integer         not null, primary key
#  food_item_id :integer         not null
#  purchase_id  :integer         not null
#  quantity     :decimal(6, 2)
#  size         :string(255)
#  price        :decimal(8, 2)
#  taxable      :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

class FoodItemPurchase < ActiveRecord::Base
  attr_accessible :food_item_id, :purchase_id, :quantity, :size, :price, :taxable


  belongs_to :food_item
  belongs_to :purchase

  validates :food_item_id, :presence => true
  validates :purchase_id, :presence => true
  validates :quantity, :presence => true
  validates :price, :presence => true
  validates :taxable, :inclusion => [true, false]
  validates :size, :presence => true

  validate :validate_units
  
  before_save :update_base_units, :unless => :skip_calculations?
  after_save :update_derived_fields, :unless => Proc.new { skip_calculations? || skip_derivations? }
  after_destroy :update_derived_fields, :unless => Proc.new { skip_calculations? || skip_derivations? }
  
  
  scope :taxable, where(:taxable => true)

  def size_in_base_units
    size.u >> food_item.base_unit
  end

  def total_size
    size.u * quantity
  end

  def total_size_in_base_units
    size_in_base_units * quantity
  end

  def total_price
    price * quantity
  end

  def total_price_with_tax
    taxable? ? price * quantity * (1 + purchase.actual_tax_rate) : price * quantity
  end

  def price_per_base_unit
    price / size_in_base_units
  end

  def skip_calculations=(skip)
    @_skip = true
  end

  def skip_calculations?
    @_skip
  end

  def skip_derivations=(skip)
    @skip_der = skip
  end

  def skip_derivations?
    @skip_der
  end

  private

  def update_base_units
    self.total_base_units = (self.quantity * self.size.u).to(self.food_item.base_unit).abs
  end

  def update_derived_fields
    FoodInventoryFoodItem.for_item(food_item).for_program(purchase.program).after(purchase.date).each do |item|
      item.save
    end
  end

  def validate_units
    begin
      self.size.unit
      errors.add(:size, "Base unit should be a unit of weight, volumn, or each") unless [:unitless, :mass, :volume].include? self.size.unit.kind
      errors.add(:size, "the units entered are a measure of #{self.size.unit.kind.to_s.humanize}, while #{self.food_item.name} requires a unit of #{self.food_item.base_unit.unit.kind.to_s.humanize} to convert") unless self.food_item.base_unit.unit =~ self.size.unit
    rescue
      errors.add(:size, "#{self.size} does not use recogized units")
    end
  end

end
