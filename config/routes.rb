SspCtab::Application.routes.draw do

  devise_for :users

  resources :users
  resources :sites do
    resources :vendors, :shallow => true
  end
  
  resources :programs do
    resources :weeks, :shallow => true
    resources :purchases, :shallow => true do
      resources :food_item_purchases, :shallow => true
    end
    resources :food_inventories, :shallow => true
    get :autocomplete_user_name
    get :autocomplete_food_item

    get :activation
  end

  resources :food_items
  
  resources :program_types, :only => [:create, :destroy]
  post 'program_types/prioritize' 

  resources :food_item_categories, :only => [:create, :destroy]
  post 'food_item_categories/prioritize'

  resources :program_users, :only => [:create, :destroy]
  root :to => 'pages#home'

  # route for the main index of all vendors
  resources :vendors, :only => [:index]
  resources :purchases, :only => [:index]
  resources :food_inventories, :only => [:index]

  #static routes
  get "pages/home"
  get "options", :controller => 'pages', :action => 'options'

  #reports
  get "reports/list"
  get "reports/inventory/:id", :controller => 'reports', :action => 'inventory'
  get "reports/budget/:id", :controller => 'reports', :action => :budget
  get "reports/consumption/:id", :controller => :reports, :action => :consumption
  get "reports/week/:id", :controller => :reports, :action => :week

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
