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
#  total        :decimal(8, 2)
#  created_at   :datetime
#  updated_at   :datetime
#  tax          :decimal(, )
#

class Purchase < ActiveRecord::Base
  attr_accessible :date, :total

  validates :program_id, :presence => true
  validates :vendor_id, :presence => true
  validates :purchaser_id, :presence => true
  validates :total, :presence => true
  validates :date, :presence => true
  
  belongs_to :program
  belongs_to :vendor
  belongs_to :purchaser, :class_name => "User"
end
