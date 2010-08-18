class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :group_id
      t.integer :member_id
      t.string :member_type

      t.timestamps
    end
    
    add_index :group_memberships, [:member_id, :member_type]
  end

  def self.down
    drop_table :group_memberships
  end
end
