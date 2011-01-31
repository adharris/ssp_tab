# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110131033555) do

  create_table "food_items", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "brand"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_users", :force => true do |t|
    t.integer  "program_id"
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.integer  "site_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "program_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", :force => true do |t|
    t.integer  "program_id"
    t.integer  "vendor_id"
    t.date     "date"
    t.integer  "purchaser_id"
    t.decimal  "total",        :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", :limit => 255
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "username"
    t.boolean  "admin",                               :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendors", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.string   "name",       :null => false
    t.string   "address",    :null => false
    t.string   "city",       :null => false
    t.string   "state",      :null => false
    t.string   "zip",        :null => false
    t.string   "contact",    :null => false
    t.string   "phone",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "week_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weeks", :force => true do |t|
    t.integer  "program_id",                      :null => false
    t.date     "start_date",                      :null => false
    t.date     "end_date",                        :null => false
    t.integer  "week_type_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scheduled_adults", :default => 0
    t.integer  "scheduled_youth",  :default => 0
    t.integer  "actual_adults"
    t.integer  "actual_youth"
  end

  add_index "weeks", ["program_id"], :name => "index_weeks_on_program_id"

end
