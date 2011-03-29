# == Schema Information
# Schema version: 20110204030905
#
# Table name: purchases
#
#  id           :integer         not null, primary key
#  program_id   :integer
#  vendor_id    :integer
#  date         :date
#  purchaser_id :integer
#  total        :decimal(, )
#  created_at   :datetime
#  updated_at   :datetime
#  tax          :decimal(8, 2)
#

class Purchase < ActiveRecord::Base
  attr_accessible :date, :total, :tax

  validates :program_id, :presence => true
  validates :vendor_id, :presence => true
  validates :purchaser_id, :presence => true
  validates :total, :presence => true
  validates :tax, :presence => true
  validates :date, :presence => true
  
  belongs_to :program
  belongs_to :vendor
  belongs_to :purchaser, :class_name => "User"

  has_many :food_item_purchases
  has_many :food_items, :through => :food_item_purchases

  scope :for_program, lambda { |program| where(:program_id => program.id) }
  scope :after, lambda { |date| where('date > ?', date) }
  scope :before, lambda { |date| where('date <=', date) }

  default_scope :order => 'date ASC'

  def to_s
    "#{vendor.name} #{date}"
  end

  def accounted_for
    (food_item_purchases.map &:total_price_with_tax).sum
  end

  def unaccounted_for
    total - accounted_for
  end

  def food_item_total
    (food_item_purchases.map &:total_price_with_tax).sum
  end

  def effective_tax_rate
    tax / total
  end

  def actual_tax_rate
    total_taxable = (food_item_purchases.taxable.map &:total_price).sum
    unless total_taxable == 0
      tax / total_taxable 
    else
      0
    end
  end
  
 
end
