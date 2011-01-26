# == Schema Information
# Schema version: 20110123183256
#
# Table name: week_types
#
#  id         :integer         not null, primary key
#  week_id    :integer         not null
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class WeekType < ActiveRecord::Base
  attr_accessible :name, :week_id

  has_many :weeks
end
