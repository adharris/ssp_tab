# == Schema Information
# Schema version: 20110202043723
#
# Table name: food_items
#
#  id                    :integer         not null, primary key
#  program_id            :integer
#  name                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  base_unit             :string(255)
#  default_taxed         :boolean
#  food_item_category_id :integer
#

class FoodItem < ActiveRecord::Base
  attr_accessible :name, :base_unit, :default_taxed, :food_item_category_id, :program_id

  validates :name, :presence => true, :uniqueness => true
  validates :base_unit, :presence => true
  validates :default_taxed, :inclusion => [true, false]
  validates :food_item_category_id, :presence => true
  
  validate :validate_units

  belongs_to :program
  belongs_to :food_item_category

  has_many :food_item_purchases
  has_many :food_inventory_food_items

  scope :master, where(:program_id => nil)
  scope :all_for_program, lambda {|program| where('program_id IS NULL OR program_id = ?', program.id) }

  scope :search_by_name, lambda { |q|
    (q ? where(["name Like ?", '%' + q + '%']) : {} )
  }

  def to_s
    name
  end

  def last_inventory_for_program_at_date(program, date)
    food_inventory_food_items.joins(:food_inventory).where('food_inventories.program_id = ? and food_inventories.date < ?', program.id, date).order('food_inventories.date DESC').first
  end
    
  def last_inventory_for(program)
    last_inventory_for_program_at_date(program, Date.today)
  end

  def purchases_between(program, start_date, end_date)
    food_item_purchases.joins(:purchase).where('purchases.program_id = ? AND purchases.date >= ? AND purchases.date <= ?', program.id, start_date, end_date)
  end

  def in_inventory_for(program)
   in_inventory_for_program_at(program, Date.today) 
  end

  def in_inventory_for_program_at(program, date)
    last_inventory = last_inventory_for_program_at_date(program, date)
    if last_inventory.nil?
      (purchases_between(program, program.purchases.first.date, date).map &:total_size_in_base_units).sum
    else
      last_inventory.quantity.unit + (purchases_between(program, last_inventory.food_inventory.date, date).map &:total_size_in_base_units).sum
    end
  end

  protected

  def before_save
    strip_units_scalar
  end

  def validate_units
    self.base_unit.downcase!
    begin
      self.base_unit.unit
      errors.add(:base_unit, "Base unit should be a unit of weight, volumn, or each") unless [:unitless, :mass, :volume].include? self.base_unit.unit.kind
    rescue
      errors.add(:base_unit, "#{base_unit} is not a recognized unit")
    end
  end 

  def strip_units_scalar
    self.base_unit = self.base_unit.unit.units
  end
end
