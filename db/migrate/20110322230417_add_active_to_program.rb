class AddActiveToProgram < ActiveRecord::Migration
  def self.up
    add_column :programs, :active, :boolean, :default => true 
  end

  def self.down
    remove_column :programs, :active
  end
end
