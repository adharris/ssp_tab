class CreateWeeks < ActiveRecord::Migration
  def self.up
    create_table :weeks do |t|
      t.integer :program_id, :null => false
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.integer :week_type_id, :null => false

      t.timestamps
    end

    add_index :weeks, :program_id
  end

  def self.down
    drop_table :weeks
  end
end
