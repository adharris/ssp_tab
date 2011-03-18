# == Schema Information
# Schema version: 20110213051823
#
# Table name: programs
#
#  id              :integer         not null, primary key
#  site_id         :integer
#  start_date      :date
#  end_date        :date
#  program_type_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  food_budget     :decimal(8, 2)
#

class Program < ActiveRecord::Base
  attr_accessible :site_id, :start_date, :end_date, :program_type_id, :food_budget

  belongs_to :site
  belongs_to :program_type

  has_many :program_users
  has_many :users, :through => :program_users
  has_many :weeks
  has_many :purchases
  has_many :food_item_purchases, :through => :purchases
  has_many :food_items
  has_many :food_inventories

  scope :current, where("end_date >= ?", Time.now)
  scope :past, where("end_date < ?", Time.now)
 
  default_scope :include => :site, :order => 'end_date DESC, sites.name ASC'

  def name
    "#{site.name} #{program_type.name} #{start_date.year}"
  end

  def short_name
    "#{program_type.name} #{start_date.year}"
  end
  
  def smart_name
    elements = []
    elements << self.site.name 
    elements << self.program_type.name if Program.current.where(:site_id => self.site_id).count > 1
    elements << self.start_date.year if Program.current.where(:site_id => self.site_id, :program_type_id => self.program_type_id).count > 1
    elements.join(" ")
  end

  def to_s
    smart_name
  end

  def adults
    (self.weeks.map &:adults).sum
  end

  def youth
    (self.weeks.map &:youth).sum
  end

  def food_budget_spent
    (self.purchases.map &:total).sum
  end

  def food_budget_remaining
    food_budget - food_budget_spent
  end

  def purchased_items
    (food_item_purchases.collect &:food_item).uniq
  end
    
end
