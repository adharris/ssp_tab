class FoodInventoriesController < ApplicationController
  load_and_authorize_resource :program
  load_and_authorize_resource :food_inventory, :through => :program, :shallow => true

  def index
    authorize! :see_food_inventories_for, @program unless @program.nil?
    redirect_to program_food_inventories_path(current_user.current_program) if ( @program.nil? && cannot?(:manage, FoodInventory))
    @title = @program.nil? ? "Food Inventories" : "Food Inventories for #{@program}"
  end

  def show
    @title = "#{@food_inventory.date} Food Inventory"
  end

  def new
    @title = "New Food Inventory"
  end

  def create
    if @food_inventory.save
      flash[:success] = "Food inventory created successfully"
      redirect_to @food_inventory
    else
      @title = "New Food Inventory"
      render :new
    end
  end

  def edit
    @title = "Editing #{@food_inventory.date} Food Inventory"
    @program = @food_inventory.program
  end

  def update
    if @food_inventory.update_attributes(params[:food_inventory])
      flash[:success] = "Food inventory updated successfully"
      redirect_to @food_inventory
    else
      @title = "Editing #{@food_inventory.date} Food Inventory"
      render :edit
    end
  end
      


end
