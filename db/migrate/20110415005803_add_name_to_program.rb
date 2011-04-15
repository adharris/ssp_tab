class AddNameToProgram < ActiveRecord::Migration
  def self.up
    add_column :programs, :name, :string
    add_column :programs, :short_name, :string

    Program.all.each { |p| p.save }
  end

  def self.down
    remove_column :programs, :name
  end
end
