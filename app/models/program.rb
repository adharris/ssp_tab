# == Schema Information
# Schema version: 20110331025929
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
#  food_budget     :decimal(, )
#  active          :boolean         default(TRUE)
#

class Program < ActiveRecord::Base
  attr_accessible :site_id, :start_date, :end_date, :program_type_id, :food_budget, :active, :name

  belongs_to :site
  belongs_to :program_type

  has_many :program_users
  has_many :users, :through => :program_users
  has_many :weeks
  has_many :purchases
  has_many :food_item_purchases, :through => :purchases
  has_many :food_items
  has_many :food_inventories

  validates :name, :presence => true
  validates :short_name, :presence => true
  validates :site_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :program_type_id, :presence => true
  validates :food_budget, :presence => true, :numericality => true
  validates :active, :inclusion => [true, false]

  scope :current, where(:active => true)  
  scope :past, where(:active => false)  

  default_scope :include => :site, :order => 'end_date DESC, sites.name ASC'

  before_validation :set_name

  def smart_name
    elements = []
    elements << self.site.name 
    elements << self.program_type.name if Program.current.where(:site_id => self.site_id).count > 1
    elements << self.start_date.year if Program.current.where(:site_id => self.site_id, :program_type_id => self.program_type_id).count > 1
    less = Program.current.where('site_id = ? AND program_type_id = ? AND programs.id <= ?', site_id, program_type_id, id)
    elements << less.count if less.count > 1
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

  private

  def smart_name
    elements = []
    elements << self.site.name 
    elements << self.program_type.name 
    elements << self.start_date.year 
    less = Program.current.where('site_id = ? AND program_type_id = ? AND programs.id <= ?', site_id, program_type_id, id)
    elements << less.count if less.count > 1
    elements.join(" ")
  end

  def smart_short_name
    elements = []
    elements << self.site.abbr 
    elements << self.program_type.abbr_name 
    elements << self.start_date.year % 100 
    less = Program.current.where('site_id = ? AND program_type_id = ? AND programs.id <= ?', site_id, program_type_id, id)
    elements << less.count if less.count > 1
    elements.join(" ")
  end

  def set_name
    self.name = smart_name
    self.short_name = smart_short_name
  end
    
end
