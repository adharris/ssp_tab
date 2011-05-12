class ProgramsController < ApplicationController
  load_and_authorize_resource

  autocomplete :user, :name, :full => true, :scopes => [:current_staff]

  #def autocomplete_user_name
  #  @program = Program.find(params[:program_id])
  #  @users = (User.not_admin.search_by_name(params[:term]) - @program.users)
  #  render :json => json_for_autocomplete(@users, :name, nil)
  #end

  def autocomplete_food_item
    @program = Program.find(params[:program_id])
    @food_items = FoodItem.all_for_program(@program).search_by_name(params[:term])
    render :json => json_for_autocomplete(@food_items, :name, nil)
  end

  def activation
    @program = Program.find(params[:program_id])
    authorize! :activate, @program
    @program.toggle!(:active)
    flash[:success] = "#{@program} successfully #{@program.active? ? 'activated' : 'deactivated'}"
    redirect_to programs_path
  end

  def index
    @title = "Programs"
    @active_programs = Program.current
    @inactive_programs = Program.past
    @menu_actions = [{:name => "New", :path => new_program_path(@program)}] if can? :create, Program
  end

  def new
    @title = "New Program"
  end

  def create
    @program = Program.new(params[:program])
    if @program.save
      flash[:success] = "#{@program.name} successfully created"
      redirect_to @program
    else
      @title = "New Program"
      render :new
    end
  end

  def show
    @title = @program.name
    @menu_actions = []
    @menu_actions << {:name => "Edit", :path => edit_program_path(@program)} if can? :edit, @program
    @menu_actions << {:name => "New Week", :path => new_program_week_path(@program)} if can? :create, @program.weeks.new
    @menu_actions << {:name => "New Purchase", :path => new_program_purchase_path(@program)} if can? :crate, @program.purchases.new
  end

  def edit
    @title = "Editing: #{@program.name}"
  end

  def update
    if @program.update_attributes(params[:program])
      flash[:success] = "#{@program.name} updated successfully"
      redirect_to @program
    else
      @title = "Editing: #{@program.name}"
      render :edit
    end
  end

  def destroy
    @program.destroy
    flash[:success] = "Program deleted"
    redirect_to programs_path
  end
    
end
