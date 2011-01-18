# == Schema Information
# Schema version: 20110117230142
#
# Table name: program_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProgramType < ActiveRecord::Base
  
  has_many :programs
end
