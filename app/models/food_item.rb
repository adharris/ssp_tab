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

  scope :master, where(:program_id => nil)
  scope :all_for_program, lambda {|program| where('program_id IS NULL OR program_id = ?', program.id) }

  scope :search_by_name, lambda { |q|
    (q ? where(["name Like ?", '%' + q + '%']) : {} )
  }

  def to_s
    name
  end

  protected

  def validate_units
    begin
      self.base_unit.unit
      errors.add(:base_unit, "Please enter only the units portion of the measurement") unless self.base_unit.unit.units == self.base_unit
      errors.add(:base_unit, "Base unit should be a unit of weight, volumn, or each") unless [:unitless, :mass, :volume].include? self.base_unit.unit.kind
    rescue
      errors.add(:base_unit, "#{base_unit} is not a recognized unit")
    end
  end 
end
