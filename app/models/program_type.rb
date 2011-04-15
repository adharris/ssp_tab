# == Schema Information
# Schema version: 20110331025929
#
# Table name: program_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class ProgramType < ActiveRecord::Base
  
  attr_accessible :position, :name

  has_many :programs

  acts_as_list

  default_scope :order => :position

  before_destroy :reassign_programs

  def abbr_name
    (name.split.collect { |i| i[0..1] }).join
  end

  private

  def reassign_programs
    other = ProgramType.find_by_name("Other")
    programs.each {|p| p.update_attributes(:program_type_id => other.id) }
  end
end
