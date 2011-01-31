class PurchasesController < ApplicationController
  load_and_authorize_resource :program
  load_and_authorize_resource :purchase, :through => :program, :shallow => true

  def index
    @title = "Purchases"
  end

  def new
    @title = "New Purchase"
    @purchase.program = @program
  end

  def create
    @purchase.vendor_id = params[:purchase][:vendor_id]
    @purchase.purchaser_id = params[:purchase][:purchaser_id]
    if @purchase.save
      flash[:success] = "Puchase created"
      redirect_to @purchase
    else
      @title = "New purchase"
      render :new
    end
  end

end
