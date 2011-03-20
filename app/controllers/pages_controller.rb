class PagesController < ApplicationController
  
  def home
    @title = "Home"
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @program = Program.find(params[:program]) unless params[:program].blank?
    @purchases = @program.nil? ? Purchase.all : @program.purchases
    @inventories = @program.nil? ? FoodInventory.all : @program.food_inventories
    @items = @purchases + @inventories

  end

end
