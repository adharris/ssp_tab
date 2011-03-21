class ReportsController < ApplicationController

  def list
    @title = "Reports"
  end

  def inventory
    @title = "Inventory Report"
    @program = current_user.current_program || 
      (Program.find(params[:program]) if params[:program]) || 
      Program.current.first
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today

    @food_items = FoodItem.all_for_program(@program)

  end

end
