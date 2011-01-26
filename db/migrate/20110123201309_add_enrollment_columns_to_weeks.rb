class AddEnrollmentColumnsToWeeks < ActiveRecord::Migration
  def self.up
    add_column :weeks, :scheduled_adults, :integer, :default => 0
    add_column :weeks, :scheduled_youth, :integer, :default => 0
    add_column :weeks, :actual_adults, :integer
    add_column :weeks, :actual_youth, :integer
  end

  def self.down
    remove_column :weeks, :actual_youth
    remove_column :weeks, :actual_adults
    remove_column :weeks, :scheduled_youth
    remove_column :weeks, :scheduled_adults
  end
end
