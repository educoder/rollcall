class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.string :name
      t.integer :app_id

      t.timestamps
    end
    
    add_index :runs, :app_id
  end

  def self.down
    drop_table :runs
  end
end
