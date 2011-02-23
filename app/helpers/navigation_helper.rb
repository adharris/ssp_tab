module NavigationHelper

  def purchase_menu(menu_item, program)
    menu_item.item(:purchase_index,
                   "All Purchases",
                   program_purchases_path(program),
                   :if => lambda {can? :see_purchases_for, program })
    menu_item.item(:purchase_menu,
                   "#{@purchase.try(:vendor).try(:name)} #{@purchase.try(:date)}",
                   url_for(@purchase),
                   :unless => lambda { @purchase.nil? || @purchase.new_record? || @purchase.program != program})
    menu_item.item(:new_purchase_menu,
                   "New Purchase",
                   new_program_purchase_path(program),
                   :if => lambda { can? :create, Purchase})
  end
  
  def vendor_menu(menu_item, site)
    menu_item.item(:vendor_index,
                   "All Vendors",
                   site_vendors_path(site),
                   :if => lambda { can? :see_vendors_for, site })
    menu_item.item(:vendor,
                   @vendor.try(:name),
                   url_for(@vendor),
                   :highlights_on => /vendors\/[0-9]+/, 
                   :unless => lambda { @vendor.nil? || @vendor.new_record? || @vendor.site != site})
    menu_item.item(:new_vendor,
                   "New Vendor", 
                   new_site_vendor_path(site), 
                   :if => lambda { can? :create, site.vendors.new })
  end

  def food_inventory_menu(menu_item, program)
    menu_item.item(:food_inventory_index,
                   "All Food Inventories",
                   program_food_inventories_path(program),
                   :if => lambda {can? :see_food_inventories_for, program })
    menu_item.item(:food_inventory_menu,
                   @food_inventory.try(:date),
                   url_for(@food_inventory),
                   :unless => lambda { @food_inventory.nil? || @food_inventory.new_record? || @food_inventory.program != program})
    menu_item.item(:new_food_inventory_menu,
                   "New Food Inventory",
                   new_program_food_inventory_path(program),
                   :if => lambda { can? :create, FoodInventory})
  end

end

