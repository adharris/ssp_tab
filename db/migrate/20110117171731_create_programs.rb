class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.integer :site_id
      t.date :start_date
      t.date :end_date
      t.integer :program_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
