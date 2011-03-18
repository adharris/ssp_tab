require 'faker'

namespace :db do
  desc "Fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_sites
    make_programs
    assign_jobs
    make_weeks
    make_vendors
    make_food_items
    make_purchases
  end
end

def make_users
  admin = User.create!(:username => "admin",
                       :email => "adharris@gmail.com",
                       :name => "Admin User",
                       :password => "foobar")
  admin.toggle!(:admin)
  30.times do |n|
    User.create!(:username => "normal#{n}",
                 :email => "normal#{n}@examle.com",
                 :name => Faker::Name.name,
                 :password => "normal")
  end
end

def make_sites
  8.times do |n|
    Site.create!(:name => Faker::Address.city,
                 :state => Faker::Address.us_state_abbr,
                 :description => Faker::Lorem.paragraph)
  end
end

def make_vendors
  Site.all.each do |site|
    (1 + rand(4)).times do |n|
      vendor = Vendor.new(:name => Faker::Company.name,
                              :address => Faker::Address.street_name,
                              :city => Faker::Address.city,
                              :state => Faker::Address.us_state_abbr,
                              :zip => Faker::Address.zip_code,
                              :contact => Faker::Name.name,
                              :phone => Faker::PhoneNumber.phone_number)
      vendor.site = site
      vendor.save!
    end
  end
end


def make_programs
  summer = ProgramType.find_by_name("Summer")
  spring = ProgramType.find_by_name("Spring Break")

  Site.all.each do |site|
    Program.create!(:site_id => site.id,
                    :program_type_id => summer.id,
                    :start_date => Date.today - 1.weeks,
                    :end_date => Date.today + 6.weeks,
                    :food_budget => (4000..6000).to_a.rand)
  end
end

def make_jobs
  ["Site Director", "Chef"].each do |pos|
    Job.create!(:name => pos)
  end
end

def assign_jobs
  sd = Job.find_by_name("Site Director")
  c = Job.find_by_name("Chef")
  Program.all.each do |program|
    program.program_users.create!(:user_id =>(User.not_admin - User.current_staff)[0].id, :job_id => sd.id)
    (User.not_admin - User.current_staff)[0..1].each do |user|
      program.program_users.create!(:user_id => user.id, :job_id => c.id)
    end
  end
end

def make_weeks
#  WeekType.create!(:name => "Sr. High")
#  WeekType.create!(:name => "Jr. High")
  Program.all.each do |program|
    6.times do |i|
      program.weeks.create!(:start_date => Date.today + (i-1).weeks, :end_date => Date.today + i.week, :week_type_id => 1)
    end
  end
end

def make_food_items
  50.times do
    FoodItem.create(:name => Faker::Lorem.words(1),
                    :base_unit => ['lb', 'oz', 'g', 'each', 'doz', 'floz', 'gal', 'l'].rand,
                    :default_taxed => false,
                    :food_item_category_id => FoodItemCategory.all.rand.id)
  end
end

def make_purchases
  Program.all.each do |program|
    15.times do 
      purchase = program.purchases.build(:date => (program.start_date..program.end_date).to_a.rand,
                                         :total => (50..750).to_a.rand,
                                         :tax => 0);
      purchase.vendor = program.site.vendors.rand
      purchase.purchaser = program.users.rand
      purchase.save!
    end
  end
end
