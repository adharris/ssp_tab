# == Schema Information
# Schema version: 20110331025929
#
# Table name: sites
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :text
#

class Site < ActiveRecord::Base
  attr_accessible :name, :state, :description, :abbr

  validates :name, :presence =>true, :uniqueness =>true
  validates :state, :presence => true, :length => { :is => 2 }
  validates :abbr, :length => {:maximum => 5}

  has_many :programs
  has_many :vendors

  scope :current_sites, joins(:programs).where('programs.end_date >= ?', Time.now)

  def current_program
    programs.order('start_date desc').first
  end
end
