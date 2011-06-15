class CreateInitialSchema < ActiveRecord::Migration
  def self.up
    create_table "accounts", :force => true do |t|
      t.string   "login"
      t.string   "password"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "for_id"
      t.string   "for_type"
    end

    add_index "accounts", ["for_id", "for_type"], :name => "index_accounts_on_for_id_and_for_type"
    add_index "accounts", ["login", "password"], :name => "index_accounts_on_login_and_password"
    add_index "accounts", ["login"], :name => "index_accounts_on_login"

    create_table "curnits", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "path"
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
      t.string   "kind"
    end

    add_index "groups", ["kind"], :name => "index_groups_on_kind"
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
      t.integer  "curnit_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "runs", ["curnit_id"], :name => "index_runs_on_curnit_id"

    create_table "sessions", :force => true do |t|
      t.integer  "account_id"
      t.string   "token"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sessions", ["account_id"], :name => "index_sessions_on_user_id"
    add_index "sessions", ["token", "account_id"], :name => "index_sessions_on_token_and_user_id"
    add_index "sessions", ["token"], :name => "index_sessions_on_token"

    create_table "users", :force => true do |t|
      t.string   "display_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "kind"
    end

    add_index "users", ["kind"], :name => "index_users_on_kind"
  end

  def self.down
  end
end
