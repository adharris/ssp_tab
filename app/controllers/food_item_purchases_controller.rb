class FoodItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :food_item_purchase, :through => :purchase, :shallow => true

  def new
    @title = "New Food Item"
  end

  def create
    if @food_item_purchase.save
      respond_to do |format|
        format.html do 
          flash[:success] = "Added food Item"
          redirect_to @food_item_purchase.purchase
        end
        format.js
      end
    else
      @title = "Purchase Food Item"
      render :new
    end
  end

  def destroy
    if @food_item_purchase.destroy
      flash[:success] = "#{@food_item_purchase.food_item} removed successfully"
    else
      flash[:error] = "Could not remove #{@food_item_purchase.food_item}"
    end
    respond_to do |format|
      format.html { redirect_to @food_item_purchase.purchase }
      format.js { flash.discard }
    end
  end
end
