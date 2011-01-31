# == Schema Information
# Schema version: 20110129214911
#
# Table name: vendors
#
#  id         :integer         not null, primary key
#  site_id    :integer         not null
#  name       :string(255)     not null
#  address    :string(255)     not null
#  city       :string(255)     not null
#  state      :string(255)     not null
#  zip        :string(255)     not null
#  contact    :string(255)     not null
#  phone      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Vendor < ActiveRecord::Base
  attr_accessible :name, :address, :city, :state, :zip, :contact, :phone
  
  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true, :length => {:is => 2}
  validates :zip, :presence => true, :length => { :is => 5 }, :format => { :with => /^[0-9]*$/ }
  validates :contact, :presence => true
  validates :phone, :length => { :is => 10 }

  
  belongs_to :site
  has_many :purchases

  def before_validation
    self.phone = phone.gsub(/[^0-9]/, "")
  end

end
