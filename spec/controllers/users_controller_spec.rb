require 'spec_helper'

describe UsersController do
  render_views
  include Devise::TestHelpers

  describe "Get 'new'" do

    describe 'as an unauthenticated user' do

      it "should restrict access to the user create page" do
        get :new
        response.should_not be_success
      end
    end

    describe 'as an authenticated' do

      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      describe 'user' do

        it "should restrict access to create page" do
          get :new
          response.should redirect_to root_path
        end
      end

      describe 'admin' do

        before(:each) do
          @user.toggle!(:admin)
        end

        it "should allow access to the create user page" do
          get :new
          response.should be_success
        end
      end
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @valid_attr = {:first_name            => "New", 
                     :last_name             => "User", 
                     :username              => "newuser",
                     :email                 => "newuser@example.com",
                     :password              => "foobar",
                     :password_confirmation => "foobar"}
    end

    it "should fail for unauthorized users" do 
      post :create, :user => @valid_attr
      response.should redirect_to root_path
    end

    it "should fail for authorized users" do
      sign_in Factory(:user)
      post :create, :user => @valid_attr
    end

    describe "for admin users" do

      before(:each) do
        user = Factory(:user)
        user.toggle!(:admin)
        sign_in user
      end
    
      describe "with valid attributes" do

        it "should succeed for admin users" do
          lambda do
            post :create, :user => @valid_attr
          end.should change(User, :count).by(1)
        end

        it "should redirect to the user index" do
          post :create, :user=> @valid_attr
          response.should redirect_to root_path
        end
      end

      describe "with invalid attributes" do
        
        before(:each) do
          @invalid_attr = {:first_name            => "", 
                           :last_name             => "", 
                           :username              => "",
                           :email                 => "",
                           :password              => "",
                           :password_confirmation => ""}
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @invalid_attr
          end.should_not change(User, :count)
        end

        it "should render the new page" do
          post :create, :user => @invalid_attr
          response.should render_template('new')
        end                               
      end
    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      @another_user  = Factory(:user, :email => Factory.next(:email), :username => Factory.next(:username)) 
    end

    describe "for unauthorized users" do

      it "should restrict access" do
        get :show, :id => @user
        response.should redirect_to(root_path)
      end

    end

    describe "for authenicated users" do
      
      before(:each) do
        sign_in(@user)
      end

      it "should allow access to the user's own profile" do
        get :show, :id => @user
        response.should be_success
      end

      it "should have a link to the users edit page" do
        get :show, :id => @user
        response.should have_selector("a", :href => edit_user_path(@user), :content=> "Update Account")
      end

      it "should not allow access to other users' pages" do
        get :show, :id => @another_user
        response.should redirect_to(root_path)
      end
    end
    
    describe "for admin users" do

      before(:each) do
        sign_in(@user)
        @user.toggle!(:admin)
      end

      it "should allow access to other user's page" do
        get :show, :id => @another_user
        response.should be_success
      end

      it "should not have a link to another user's edit page" do
        get :show, :id => @another_user
        response.should_not have_selector("a", :href => edit_user_path(@another_user), :content=>"Update Account")
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for unauthenticated users" do

      it "should not allow access" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

    end

    describe "for authenticated" do
      before(:each) do
        sign_in @user
      end

      describe "normal users" do

        it "should allow access to the users own edit page" do
          get :edit, :id => @user
          response.should be_success
        end

        it "should not allow access to another uses' edit page" do
          another_user  = Factory(:user, :email => Factory.next(:email), :username => Factory.next(:username)) 
          get :edit, :id => another_user
          response.should redirect_to(root_path)
        end
      end

      describe "admin users" do
        before(:each) do
          @user.toggle!(:admin)
        end

        it "should not allow access to other users' edit page" do
          another_user  = Factory(:user, :email => Factory.next(:email), :username => Factory.next(:username)) 
          get :edit, :id => another_user
          response.should redirect_to(root_path)
        end
      end
    end
  end
   
end
