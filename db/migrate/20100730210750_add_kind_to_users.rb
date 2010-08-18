class AddKindToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :kind, :string
    add_index :users, :kind
  end

  def self.down
    remove_column :users, :kind
  end
end
