class ProgramUsersController < ApplicationController
  load_and_authorize_resource

  def destroy
    @program_user.destroy
    flash[:success] = "User removed as staff"
    redirect_to @program_user.program
  end

  def create
    @program_user = ProgramUser.create(params[:program_user])
    if(@program_user.save)
      flash[:success] = "#{@program_user.user.name} added as #{@program_user.job.name} to #{@program_user.program.name}"
      redirect_to @program_user.program
    else
      flash[:error] = "Could not find user"
      @program = @program_user.program
      render "programs/show"
    end
  end

end
