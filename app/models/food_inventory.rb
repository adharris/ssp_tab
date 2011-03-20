# == Schema Information
# Schema version: 20110213051823
#
# Table name: food_inventories
#
#  id         :integer         not null, primary key
#  program_id :integer
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#

class FoodInventory < ActiveRecord::Base
  attr_accessible :date, :food_inventory_food_items_attributes

  belongs_to :program
  has_many :food_inventory_food_items
  has_many :food_items, :through => :food_inventory_food_items

  accepts_nested_attributes_for :food_inventory_food_items, :reject_if => proc { |attr| attr[:quantity].blank? }
  
  validates :program_id, :presence => true
  validates :date, :presence => true


  def total_spent
    (food_inventory_food_items.map &:total_price).sum
  end

end
