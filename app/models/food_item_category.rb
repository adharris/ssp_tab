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
  attr_accessible :name, :position

  validates :name, :presence => true

  has_many :food_items

  acts_as_list

  default_scope :order => :position

  before_destroy :reassign_category

  private

  def reassign_category
    other = FoodItemCategory.find_by_name("Other")
    food_items.each do |item|
      item.update_attributes(:food_item_category_id => other.id)
    end
  end
end
