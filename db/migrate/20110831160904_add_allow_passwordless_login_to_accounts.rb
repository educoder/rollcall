class AddAllowPasswordlessLoginToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :allow_passwordless_login, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :accounts, :allow_passwordless_login
  end
end
