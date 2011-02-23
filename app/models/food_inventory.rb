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
  attr_accessible :date

  belongs_to :program
  has_many :food_inventory_food_items
  
  validates :program_id, :presence => true
  validates :date, :presence => true
end
