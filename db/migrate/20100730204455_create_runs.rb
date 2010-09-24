class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.string :name
      t.integer :curnit_id

      t.timestamps
    end
    
    add_index :runs, :curnit_id
  end

  def self.down
    drop_table :runs
  end
end
