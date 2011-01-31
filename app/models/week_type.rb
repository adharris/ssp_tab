# == Schema Information
# Schema version: 20110126012451
#
# Table name: week_types
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class WeekType < ActiveRecord::Base
  attr_accessible :name, :week_id

  has_many :weeks
end
