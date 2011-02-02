class SitesController < ApplicationController
  load_and_authorize_resource
  
  def show
    @title = @site.name
  end

  def index
    @active_sites
    @title = "Sites"
  end

  def edit
    @title = "Editing: #{@site.name}"
  end

  def update
    if @site.update_attributes(params[:site])
      flash[:success] = "Site updated successfully"
      redirect_to @site
    else
      @title = "Editing #{@site.name}"
      render :edit
    end
  end

  def new
    @title = "New site"
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      flash[:success] = "Created site #{@site.name}"
      redirect_to @site
    else
      @title = "New Site"
      render :new
    end
  end

  def destroy
    @site.destroy
    flash[:success] = "#{@site.name} deleted"
    redirect_to sites_path
  end
end
