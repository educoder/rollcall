class MoveUsersToAccounts < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |u|
      a = Account.create(:login => u.username, :password => u.password)
      u.update_attribute(:account_id => a.id)
    end
  end

  def self.down
    Account.find(:all).each do |a|
      if a.user
        User.create(:username => a.login, :password => a.password)
      end
    end
  end
end
