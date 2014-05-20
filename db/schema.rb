# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140520014356) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "monthly_time_records", :id => false, :force => true do |t|
    t.integer "month_number"
    t.integer "user_id"
    t.integer "project_id"
    t.decimal "value",        :precision => 42, :scale => 2
    t.integer "task_type_id"
  end

  create_table "overtime_records", :force => true do |t|
    t.integer  "user_id"
    t.datetime "happened_at"
    t.decimal  "value",         :precision => 20, :scale => 2
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "time_sheet_id"
  end

  add_index "overtime_records", ["time_sheet_id"], :name => "index_overtime_records_on_time_sheet_id"
  add_index "overtime_records", ["user_id"], :name => "index_overtime_records_on_user_id"

  create_table "project_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string   "key"
    t.integer  "client_id"
    t.string   "type"
    t.integer  "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["parent_id"], :name => "index_projects_on_parent_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "task_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "time_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "recorded_on"
    t.decimal  "value",         :precision => 20, :scale => 2
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "task_type_id"
    t.string   "remark"
    t.integer  "time_sheet_id"
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  add_index "time_records", ["project_id"], :name => "index_time_records_on_project_id"
  add_index "time_records", ["task_type_id"], :name => "index_time_records_on_task_type_id"
  add_index "time_records", ["time_sheet_id"], :name => "index_time_records_on_time_sheet_id"
  add_index "time_records", ["user_id"], :name => "index_time_records_on_user_id"

  create_table "time_sheets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.decimal  "recorded_hours",            :precision => 20, :scale => 2, :default => 0.0
    t.decimal  "overtime_hours",            :precision => 20, :scale => 2, :default => 0.0
    t.decimal  "calculated_hours",          :precision => 20, :scale => 2, :default => 0.0
    t.datetime "recorded_on"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.decimal  "calculated_normal_hours",   :precision => 20, :scale => 2
    t.decimal  "calculated_overtime_hours", :precision => 20, :scale => 2
  end

  add_index "time_sheets", ["project_id"], :name => "index_time_sheets_on_project_id"
  add_index "time_sheets", ["user_id"], :name => "index_time_sheets_on_user_id"

  create_table "upload_files", :force => true do |t|
    t.string   "data_file_file_name"
    t.string   "data_file_content_type"
    t.integer  "data_file_file_size"
    t.datetime "data_file_updated_at"
    t.string   "attachment_access_token"
    t.string   "meta_data"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "user_user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_user_groups", ["user_group_id"], :name => "index_user_user_groups_on_user_group_id"
  add_index "user_user_groups", ["user_id"], :name => "index_user_user_groups_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weekly_time_records", :id => false, :force => true do |t|
    t.integer "short_week_number"
    t.integer "week_number"
    t.integer "user_id"
    t.integer "project_id"
    t.decimal "value",             :precision => 42, :scale => 2
    t.integer "task_type_id"
  end

  create_table "yearly_time_records", :id => false, :force => true do |t|
    t.integer "year_number"
    t.integer "project_id"
    t.decimal "value",        :precision => 42, :scale => 2
    t.integer "task_type_id"
    t.integer "user_id",                                     :default => 0, :null => false
  end

end
