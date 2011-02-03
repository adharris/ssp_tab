# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.
    #

    primary.item :home, "Home", root_path   
    primary.item :purchases, "Purchases", purchases_path, :if => lambda { can? :index, Purchase }
    primary.item (:food_items, "Food Items", food_items_path, :if => lambda {can? :index, FoodItem }, :highlights_on => /food_item/) do |food_item|
      food_item.item :food_item, @food_item.try(:name), food_item_path(@food_item), :highlights_on => /food_items\/[0-9]+/ unless @food_item.nil? || @food_item.new_record?
      food_item.item :new_food_item, "New Food Item", new_food_item_path if can? :create, FoodItem
    end
    primary.item (:vendors, "Vendors", vendors_path, :if => lambda { can? :index, Vendor }) do |vendor_menu|
      if(can? :manage, Vendor)
        Site.all.each do |site|
          vendor_menu.item("site_vendors_#{site.id}", "#{site.name} vendors", site_vendors_path(site), :if => lambda {can? :see_vendors_for, site}) do |site_vendor_menu|
            site_vendor_menu.item(:vendor, @vendor.try(:name), vendor_path(@vendor), :highlights_on => /vendors\/[0-9]+/) unless @vendor.nil? || @vendor.new_record? || @vendor.site != site
            site_vendor_menu.item( :new_vendor, "New Vendor", new_site_vendor_path(site)) if can? :create, site.vendors.new
          end
        end
      else
        vendor_menu.item :vendor, @vendor.try(:name), vendor_path(@vendor), :highlights_on => /vendors\/[0-9]+/ unless @vendor.nil? || @vendor.new_record?
        vendor_menu.item :new_vendor, "New Vendor", new_site_vendor_path(current_user.current_program.site) if can? :create, Vendor
      end
    end
    primary.item :sites, "Sites", sites_path, :if => lambda { can? :manage, Site }
    primary.item :programs, "Programs", programs_path, :if => lambda { can? :manage, Program }
    primary.item :users, "Users", users_path, :if => lambda { can? :create, User }

    # Add an item which has a sub navigation (same params, but with block)
    # primary.item :key_2, 'name', url, options do |sub_nav|
      # Add an item to the sub navigation (same params again)
      # sub_nav.item :key_2_1, 'name', url, options
    # end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
