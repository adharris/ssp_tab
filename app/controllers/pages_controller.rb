class PagesController < ApplicationController
  
  def home
    @title = "Home"
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @program = Program.find(params[:program]) unless params[:program].blank?
    @program = current_user.current_program unless can?(:manage, Program) || current_user.nil?
    @purchases = @program.nil? ? Purchase.all : @program.purchases
    @inventories = @program.nil? ? FoodInventory.all : @program.food_inventories
    @items =  @inventories + @purchases 
  end

end
