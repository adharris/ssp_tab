# == Schema Information
# Schema version: 20110126012451
#
# Table name: weeks
#
#  id               :integer         not null, primary key
#  program_id       :integer         not null
#  start_date       :date            not null
#  end_date         :date            not null
#  week_type_id     :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#  scheduled_adults :integer         default(0)
#  scheduled_youth  :integer         default(0)
#  actual_adults    :integer
#  actual_youth     :integer
#

class Week < ActiveRecord::Base
  attr_accessible :program_id, :start_date, :end_date, :week_type_id, :scheduled_adults, :scheduled_youth, :actual_adults, :actual_youth

  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :week_type_id, :presence => true

  belongs_to :program
  belongs_to :week_type

  default_scope :order => :start_date

  def to_s
    name
  end

  def name 
    "Week #{Week.where("program_id = ? AND start_date < ?", self.program_id, self.start_date).count + 1}"
  end

  def adults
    actual_adults || scheduled_adults
  end

  def youth
    actual_youth || scheduled_youth
  end

  def total
    adults + youth
  end

  def scheduled_total
    scheduled_adults + scheduled_youth
  end

  def actual_total
    actual_adults + actual_youth
  end

  def purchased_during
    program.purchases.where('date >= ? AND date < ?', start_date, end_date).inject(0) { |t, p| t += p.total }
  end
end
