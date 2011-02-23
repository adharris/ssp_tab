class FoodInventoriesController < ApplicationController
  load_and_authorize_resource :program
  load_and_authorize_resource :food_inventory, :through => :program, :shallow => true

  def index
    authorize! :see_food_inventories_for, @program unless @program.nil?
    redirect_to program_food_inventories_path(current_user.current_program) if ( @program.nil? && cannot?(:manage, FoodInventory))
    @title = @program.nil? ? "Food Inventories" : "Food Inventories for #{@program}"
  end

end
