class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :login
      t.string :password
      t.string :type

      t.timestamps
    end
    
    add_index :accounts, :login
    add_index :accounts, [:login, :password]
  end

  def self.down
    drop_table :accounts
  end
end
