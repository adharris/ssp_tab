# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

program_types = ["Summer", "Spring Break"]
program_types.each do |type|
  ProgramType.create!(:name => type)
end

jobs = ["Site Director", "Spiritual Life Coordinator", "Home Repair Coordinator", "Construction Coordinator", "Supply Coordinator", "Chef"]
jobs.each do |job|
  Job.create!(:name => job)
end

week_types = ["Sr. High", "Jr. High"]
week_types.each do |type|
  WeekType.create!(:name => type)
end

food_item_categories = ["Produce", "Meat", "Spices", "Dairy", "Dry Goods", "Non-Food"]
food_item_categories.each do |cat|
  FoodItemCategory.create!(:name => cat)
end
