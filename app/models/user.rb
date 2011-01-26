# == Schema Information
# Schema version: 20110117012157
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  first_name           :string(255)
#  last_name            :string(255)
#  username             :string(255)
#  admin                :boolean
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :username

  validates :username, :presence =>true, :uniqueness =>true

  has_many :program_users, :dependent => :restrict
  has_many :programs, :through => :program_users
  
  scope :admin, where(:admin => true)
  scope :not_admin, where(:admin => false)

  scope :current_staff, joins(:programs).where('programs.end_date >= ?', Time.now)


  def current_program
    self.programs.where("end_date >= ?", Time.now).order('start_date ASC').first
  end

  def current_job
    self.program_users.find_by_program_id(self.current_program).job.name
  end

  def full_name 
    "#{self.first_name} #{self.last_name}"
  end

  def site_director_for?(program)
    self.program_users.joins(:job).where(:program_id=>program.id, :job_id => Job.find_by_name("Site Director").id).count == 1
  end

end
