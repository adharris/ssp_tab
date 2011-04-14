class FoodItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @title = "Food Items"
    @menu_actions = []
    @menu_actions << {:name => "New", :path => new_food_item_path} if can? :create, FoodItem
    @food_items = FoodItem.accessible_by(current_ability).joins(:food_item_category).order('food_item_categories.position ASC, name ASC').paginate :page => params[:page]
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
    @menu_actions = []
    @menu_actions << {:name => "edit", :path => edit_food_item_path(@food_item)} if can? :edit, @food_item
    @purchases = @food_item.food_item_purchases.accessible_by(current_ability).includes(:purchase).order('purchases.date ASC')
    num = (@purchases.map {|p| p.total_base_units * p.price_per_base_unit.abs }).sum
    denom = (@purchases.map &:total_base_units).sum
    @avg_price = num / denom if denom != 0
    @inventories = @food_item.food_inventory_food_items.accessible_by(current_ability).includes(:food_inventory => :program).order('food_inventories.date ASC')
  end

  def destroy
    if @food_item.destroy
      flash[:success] = "#{@food_item.name} deleted"
    end
    redirect_to food_items_path
  end

end
