class AddFoodBudgetToProgram < ActiveRecord::Migration
  def self.up
    add_column :programs, :food_budget, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :programs, :food_budget
  end
end
