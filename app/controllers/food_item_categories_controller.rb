class FoodItemCategoriesController < ApplicationController
  load_and_authorize_resource :food_item_category

  def prioritize
    authorize! :prioritize, FoodItemCategory
    FoodItemCategory.all.each do |cate|
      cate.update_attributes(:position => params['food_item_category'].index(cate.id.to_s) + 1)
    end
    render :nothing => true
  end
  
  def create
    @food_item_category.position = (FoodItemCategory.all.map &:position).max + 1

    if @food_item_category.save
      respond_to do |format|
        format.html do 
          flash[:success] = "Added Program Type"
          redirect_to options_path
        end
        format.js
      end
    end
  end

  def destroy
    @food_item_category.destroy
    respond_to do |format|
      format.js
    end
  end
end
