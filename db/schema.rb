# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100730211907) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "member_id"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["member_id", "member_type"], :name => "index_group_memberships_on_member_id_and_member_type"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["run_id"], :name => "index_groups_on_run_id"

  create_table "metadata", :force => true do |t|
    t.integer  "about_id"
    t.string   "about_type"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadata", ["about_id", "about_type"], :name => "index_metadata_on_about_id_and_about_type"
  add_index "metadata", ["key"], :name => "index_metadata_on_key"

  create_table "runs", :force => true do |t|
    t.string   "name"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "runs", ["app_id"], :name => "index_runs_on_app_id"

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["token", "user_id"], :name => "index_sessions_on_token_and_user_id"
  add_index "sessions", ["token"], :name => "index_sessions_on_token"
  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  add_index "users", ["kind"], :name => "index_users_on_kind"
  add_index "users", ["username", "password"], :name => "index_users_on_username_and_password"
  add_index "users", ["username"], :name => "index_users_on_username"

end
