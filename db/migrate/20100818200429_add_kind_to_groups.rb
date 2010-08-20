class AddKindToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :kind, :string
    add_index :groups, :kind
  end

  def self.down
    remove_column :groups, :kind
  end
end
