class ProgramTypesController < ApplicationController
  load_and_authorize_resource :program_type

  def prioritize
    authorize! :prioritize, ProgramType
    ProgramType.all.each do |type|
      type.update_attributes(:position => params['program_type'].index(type.id.to_s) + 1)
    end
    render :nothing => true
  end

  def create
    @program_type.position = (ProgramType.all.map &:position).max + 1

    if @program_type.save
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
    @program_type.destroy
    respond_to do |format|
      format.js
    end
  end

end
