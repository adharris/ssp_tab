class UsersController < ApplicationController
  load_and_authorize_resource

  def new
    @user = User.new
  end

  def index
    @title = "Users"
    @admins = User.admin
    @all_staff = params[:all_staff] || false
    @staff = @all_staff ? User.not_admin : User.current_staff
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
    @title = "#{@user.first_name} #{@user.last_name}"
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

  def destroy
    full_name = @user.full_name
    if @user.destroy
      flash[:sucess] = "#{full_name} deleted successfully"
      redirect_to users_path( :all_staff => params[:all_staff])
    else
      @title = "Users"
      render :index
    end
  end

end
