class CreateMetadata < ActiveRecord::Migration
  def self.up
    create_table :metadata do |t|
      t.integer :about_id
      t.string :about_type
      t.string :key
      t.string :value

      t.timestamps
    end
    
    add_index :metadata, [:about_id, :about_type]
    add_index :metadata, :key
  end

  def self.down
    drop_table :metadata
  end
end
