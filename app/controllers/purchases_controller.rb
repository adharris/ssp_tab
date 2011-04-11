class PurchasesController < ApplicationController
  load_and_authorize_resource :program
  load_and_authorize_resource :purchase, :through => :program, :shallow => true

  def index
    redirect_to program_purchases_path(current_user.current_program) if (@program.nil? && cannot?(:manage, Purchase))
    @title = @program.nil? ? "Purchases" : "Purchases for #{@program}"
    unless @program.nil?
      @menu_actions = [{:name => "New Purchase", :path => new_program_purchase_path(@program)}]
      @purchases = @program.purchases.accessible_by(current_ability, :index).paginate :page => params[:page], :per_page =>5
    else
      @purchases = Purchase.accessible_by(current_ability, :index).paginate :page => params[:page]
    end
  end

  def new
    @title = "New Purchase"
    @purchase.program = @program
    @menu_actions = [{:name => "Cancel", :path => program_purchases_path(@program)}]
    if @program.site.vendors.empty?
      flash[:notice] = "There are no vendors for #{@program.site.name}, please create one before creating a new purchase"
      redirect_to new_site_vendor_path(@program.site) 
    end
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

  def show
    @title = "#{@purchase.vendor.name} #{@purchase.date}"
    if( @purchase.program.food_inventories.where(:date => @purchase.date).count != 0)
      flash.now[:notice] = "An inventory already exists for this date.  Any items added to this purchase will be treated as being purchased after the inventory was taken"
    end
  end

end
