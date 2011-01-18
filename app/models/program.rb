# == Schema Information
# Schema version: 20110117171731
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
#

class Program < ActiveRecord::Base
  attr_accessible :site_id, :start_date, :end_date, :program_type_id

  belongs_to :site
  belongs_to :program_type

  def name
    "#{site.name} #{program_type.name} #{start_date.year}"
  end
end
