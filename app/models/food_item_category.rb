# == Schema Information
# Schema version: 20110202025751
#
# Table name: food_item_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FoodItemCategory < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :food_items
end
