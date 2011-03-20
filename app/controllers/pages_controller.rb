class PagesController < ApplicationController
  
  def home
    @title = "Home"
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @purchases = Purchase.all
    @inventories = FoodInventory.all
  end

end
