class CreateWeekTypes < ActiveRecord::Migration
  def self.up
    create_table :week_types do |t|
      t.string :name, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :week_types
  end
end
