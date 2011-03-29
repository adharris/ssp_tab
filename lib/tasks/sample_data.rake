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
    make_food_item_purchases
    make_food_inventories
    make_food_inventory_food_items
  end
end

def make_users
  puts "making users...."
  admin = User.create!(:username => "admin",
                       :email => "adharris@gmail.com",
                       :name => "Admin User",
                       :password => "foobar")
  admin.toggle!(:admin)
  15.times do |n|
    User.create!(:username => "normal#{n}",
                 :email => "normal#{n}@examle.com",
                 :name => Faker::Name.name,
                 :password => "normal")
  end
end

def make_sites
  puts "making sites..."
  2.times do |n|
    Site.create!(:name => Faker::Address.city,
                 :state => Faker::Address.us_state_abbr,
                 :description => Faker::Lorem.paragraph)
  end
end

def make_vendors
  puts "making vendors..."
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
  puts "making programs..."
  summer = ProgramType.find_by_name("Summer")
  spring = ProgramType.find_by_name("Spring Break")

  Site.all.each do |site|
    Program.create!(:site_id => site.id,
                    :program_type_id => summer.id,
                    :start_date => Date.today,
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
  puts "assinging jobs..."
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
  puts "making weeks..."
#  WeekType.create!(:name => "Sr. High")
#  WeekType.create!(:name => "Jr. High")
  Program.all.each do |program|
    6.times do |i|
      program.weeks.create!(:start_date => Date.today + (i-1).weeks, 
                            :end_date => Date.today + i.week, 
                            :week_type_id => 1,
                            :scheduled_adults => (5..15).to_a.rand,
                            :scheduled_youth => (20..60).to_a.rand)
    end
  end
end

def make_food_items
  puts "making food items..."
  50.times do
    FoodItem.create(:name => Faker::Lorem.words(1),
                    :base_unit => ['lb', 'oz', 'g', 'each', 'doz', 'floz', 'gal', 'l'].rand,
                    :default_taxed => false,
                    :food_item_category_id => FoodItemCategory.all.rand.id)
  end
end

def make_purchases
  puts "making purchases..."
  Program.all.each do |program|
    7.times do 
      purchase = program.purchases.build(:date => (program.start_date..program.end_date).to_a.rand,
                                         :total => (50..750).to_a.rand,
                                         :tax => 0);
      purchase.vendor = program.site.vendors.rand
      purchase.purchaser = program.users.rand
      purchase.save!
    end
  end
end

def make_food_item_purchases
  puts "making food item purchases..."
  Purchase.all.each do |purchase|
    puts "   -- #{purchase}"
    while purchase.unaccounted_for > 0 do
      u = purchase.unaccounted_for
      p = purchase.food_item_purchases.build()
      p.food_item = FoodItem.all.rand
      p.quantity = (1..15).to_a.rand
      p.price = [((1..20).to_a.rand * purchase.total / 100 ), u].min / p.quantity
      p.size = "#{(1..20).to_a.rand} #{p.food_item.base_unit}"
      p.save!
    end   
  end
end

def make_food_inventories
  puts "making food inventories"
  Program.all.each do |program|
    puts "  -- #{program}"
    7.times do
      inventory = program.food_inventories.build(:date => (program.start_date..program.end_date).to_a.rand).save
    end
  end
end

def make_food_inventory_food_items
  puts "making food inventory food items"
  FoodInventory.all.each do |inventory|
    program = inventory.program
    puts "  |- #{program} #{inventory.date}"
    program.purchased_items.each do |item|
      amt = item.in_inventory_for_program_at(program, inventory.date).abs
      if(amt > 0)
        qt = "#{(0..100).to_a.rand * amt / 100} #{item.base_unit}"
        inventory.food_inventory_food_items.build(:food_item_id => item.id, :quantity => qt).save
      end
    end
  end
end
