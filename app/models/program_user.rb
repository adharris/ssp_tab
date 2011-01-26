# == Schema Information
# Schema version: 20110123183256
#
# Table name: program_users
#
#  id         :integer         not null, primary key
#  program_id :integer
#  user_id    :integer
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProgramUser < ActiveRecord::Base
  attr_accessible :user_id, :program_id, :job_id

  belongs_to :user
  belongs_to :program
  belongs_to :job
end
