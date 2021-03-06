class ReportsController < ApplicationController

  before_filter :get_program, :except => :list

  def list
    @title = "Reports"
    @programs = Program.accessible_by(current_ability, :report)
  end

  def inventory
    @title = "Inventory Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today

    @food_items = FoodItem.all_for_program(@program)
  end

  def budget
    @title = "Budget Report: #{@program}"
    @weeks = @program.weeks
  end

  def consumption
    @title = "Consumption Report: #{@program}"
    @food_items  = @program.purchased_items
    @inventories = @program.food_inventories
  end

  def week
    @title = "Weekly Costs: #{@program}"
  end

  protected

  def get_program
    @program = current_user.current_program || 
      (Program.find(params[:id]) if params[:id]) || 
      Program.current.first
    authorize! :report, @program
  end

end
