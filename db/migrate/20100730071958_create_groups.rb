class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.integer :run_id

      t.timestamps
    end
    
    add_index :groups, :run_id
  end

  def self.down
    drop_table :groups
  end
end
