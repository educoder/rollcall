class RelateUsersAndGroupsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_column :groups, :account_id, :integer
    
    rename_column :sessions, :user_id, :account_id
    
    add_index :users, :account_id
    add_index :groups, :account_id
    
    remove_column :users, :username
    remove_column :users, :password
  end

  def self.down
    add_column :users, :username, :string
    add_column :users, :password, :string
    
    add_index :users, :username
    add_index :users, [:username, :password]
    
    remove_column :users, :account_id
    remove_column :groups, :account_id
    
    rename_column :sessions, :account_id, :user_id
  end
end
