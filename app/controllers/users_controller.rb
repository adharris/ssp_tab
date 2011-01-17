class UsersController < ApplicationController
  load_and_authorize_resource

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "Successfully created user"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def show
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = 'Edit User'
      render 'edit'
    end
  end

end
