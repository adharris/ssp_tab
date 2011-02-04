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
  
end

