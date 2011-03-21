class ReportsController < ApplicationController

  before_filter :get_program, :except => :list

  def list
    @title = "Reports"
  end

  def inventory
    @title = "Inventory Report"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today

    @food_items = FoodItem.all_for_program(@program)
  end

  def budget
    @title = "Budget Report: #{@program}"
    @weeks = @program.weeks
  end


  protected

  def get_program
    @program = current_user.current_program || 
      (Program.find(params[:program]) if params[:program]) || 
      Program.current.first
  end

end