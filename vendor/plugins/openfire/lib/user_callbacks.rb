require 'user'

User.class_eval do
  after_save :create_or_update_account_in_openfire
  after_destroy :delete_account_in_openfire
  
  def create_or_update_account_in_openfire
    debugger
    u = Openfire::User.find_by_username(self.username)
    
    if u.nil? || new_record?
      u = Openfire::User.new(:username => self.username)
      u.creationDate = Time.now
    end
    
    u.plainPassword = self.password
    u.name = self.display_name
    u.modificationDate = Time.now
    
    u.save
  end
  
  def delet_account_in_openfire
    u = Openfire::User.find_by_username(self.username)
    
    if u
      u.destroy
    end
  end
end