class FoodItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @title = "Food Items"
    @menu_actions = [{:name => "New", :path => new_food_item_path}] if can? :create, FoodItem
    @food_items = @food_items.order('name ASC')
  end

  def new
    @title = "New Food Item"
  end

  def create
    if @food_item.save
      flash[:success] = "#{@food_item.name} created successfully"
      redirect_to @food_item
    else
      @title = "New Food Item"
      render :new
    end
  end

  def edit
    @title = "Editing #{@food_item.name}"
  end

  def update
    @food_item.attributes = params[:food_item]
    authorize! :update, @food_item 
    if(@food_item.save)
      flash[:success] = "#{@food_item.name} successfully updated"
      redirect_to food_item_path(@food_item)
    else
      @title = "Editing #{@food_item.name}"
      render :edit
    end
  end

  def show
    @title = @food_item.name
    @menu_actions = [{:name => "edit", :path => edit_food_item_path(@food_item)}] if can? :edit, @food_item
  end

  def destroy
    if @food_item.destroy
      flash[:success] = "#{@food_item.name} deleted"
    end
    redirect_to food_items_path
  end

end
