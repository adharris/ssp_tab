require 'spec_helper'

describe SitesController do
  render_views
  include Devise::TestHelpers

  describe "non admin users should have no access to" do
    before(:each) do
      @site = Factory(:site)
      @user = Factory(:user)
      sign_in @user
    end

    it "GET 'show'" do
      get :show, :id => @site
      response.should redirect_to(root_path)
    end

    it "GET 'index'" do
      get :index
      response.should redirect_to(root_path)
    end

    it "GET 'edit'" do
      get :edit, :id => @site
      response.should redirect_to(root_path)
    end

    it "GET 'new'" do
      get :new
      response.should redirect_to(root_path)
    end

    it "POST 'create'" do
      @attr = {:name => "test", :state => "CA", :description => "description"}
      post :create, :site => @attr
      response.should redirect_to(root_path)
    end

    it "PUT 'update'" do
      put :update, :id => @site, :site => {}
      response.should redirect_to(root_path)
    end

    it "DELETE 'destroy'" do
      delete :destroy, :id => @site
      response.should redirect_to(root_path)
    end
  end

  describe "for admin users" do
    before(:each) do
      @user = Factory(:user)
      @user.toggle!(:admin)
      sign_in @user
    end

    describe "GET 'show'" do
      before(:each) do
        @site = Factory(:site)
      end

      it "should be a success" do
        get :show, :id => @site
        response.should be_success
      end

      it "should display the sites name" do
        get :show, :id => @site
        response.should have_selector("h2", :content => @site.name)
      end

      it "should have a link to edit the site" do
        get :show, :id => @site
        response.should have_selector("a", :href => edit_site_path(@site), :content => "Edit site")
      end
    end

    describe "GET 'index'" do

      it "should be a success" do
        get :index
        response.should be_success
      end
      
      it "should have a linke to create a new site" do
        get :index
        response.should have_selector("a", :href => new_site_path(@site), :content => "New site")
      end
    end

    describe "GET 'edit'" do
      before(:each) do
        @site = Factory(:site)
      end

      it "should be a success" do
        get :edit, :id => @site
        response.should be_success
      end
    end

    describe "GET 'new'" do
      
      it "should be a success" do
        get :new
        response.should be_success
      end
    end

    describe "POST 'create'" do
      before(:each) do
        @attr = {:name => "test", :state => "CA", :description => "description"}
      end

      it "should redirect to the site page" do
        post :create, :site => @attr
        response.should redirect_to(site_path(assigns(:site))) 
      end

      it "should create a new site" do
        lambda do
          post :create, :site => @attr
        end.should change(Site, :count).by(1)
      end
    end

    describe "PUT 'update'" do
      before(:each) do
        @site = Factory(:site)
        @attr = {:name => "test", :state => "OR", :description => "description"}
      end

      it "should change the site attributes" do
        put :update, :id => @site, :site => @attr
        @site.reload
        @site.name.should == @attr[:name]
        @site.state.should == @attr[:state]
        @site.description.should == @attr[:description]
      end

      it "should redirect to the site show path" do
        put :update, :id=> @site, :site => @attr
        response.should redirect_to @site
      end
    end

    describe "DELETE 'destroy'" do
      before(:each) do
        @site = Factory(:site)
      end

      it "should redirect to the site index page" do
        delete :destroy, :id => @site
        response.should redirect_to(sites_path)
      end

      it "should delete the site" do
        lambda do
          delete :destroy, :id => @site
        end.should change(Site, :count).by(-1)
      end
    end
  end
end
