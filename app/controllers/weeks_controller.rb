class WeeksController < ApplicationController
  load_and_authorize_resource

  before_filter :set_constants



  def create
    @week.program_id = params[:program_id]
    if @week.save
      flash[:success] = "Week created, inserted as #{@week.name}"
      redirect_to @week.program
    else
      render @week.program, :action => :show
    end
  end

  def destroy
    if @week.destroy
      flash[:success] = "Week deleted"
      redirect_to @week.program
    else
      render @week.program, :action => :show
    end
  end

  def edit
    @title = "Editing: #{@week.program.name} #{@week.name}"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    authorize! :edit_fields, @week if (params[:week].keys & @admin_only_fields).any?
    if @week.update_attributes(params[:week])
      flash[:success] = "#{week.name} updated"
      respond_to do |format|
        format.html {redirect_to @week.program}
        format.js
      end
    else
      render :edit
    end
  end

  def new
    @program = Program.find(params[:program_id])
    @week = @program.weeks.build()
    @title = "New Week for: #{@program.name}"
  end

  protected

  def set_constants
    @admin_only_fields = %w(program_id start_date end_date scheduled_adults scheduled_youth)
  end
end
