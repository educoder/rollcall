class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
    
    add_index :sessions, :token
    add_index :sessions, :user_id
    add_index :sessions, [:token, :user_id]
  end

  def self.down
    drop_table :sessions
  end
end
