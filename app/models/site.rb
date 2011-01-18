# == Schema Information
# Schema version: 20110117012157
#
# Table name: sites
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

class Site < ActiveRecord::Base
  attr_accessible :name, :state, :description

  validates :name, :presence =>true, :uniqueness =>true
  validates :state, :presence => true, :length => { :is => 2 }

  has_many :programs
end
