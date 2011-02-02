class FoodItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @title = "Food Items"
  end

  def new
    @title = "New Food Item"
  end

  def create
    @food_item.update_attributes(params[:food_item])
    if @food_item.save
      flash[:success] = "#{@food_item.name} created successfully"
      redirect_to @food_item
    else
      @title = "New Food Item"
      render :new
    end
  end

end
