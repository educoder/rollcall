require 'digest/sha1'

class Account < ActiveRecord::Base  
  has_many :sessions,
    :dependent => :destroy
  belongs_to :for, 
    :polymorphic => true
  
  before_validation :assign_random_password,
    :if => proc{ allow_passwordless_login? && password.blank? && !login.blank? }
    # if account allows for passwordless login and the password is blank (but don't do it if we have no login for some reason)
    
  validates_uniqueness_of :login
  
  validate :cannot_change_login, :on => :update
  
  def encrypted_password
    if password.blank?
      nil
    else
      Digest::SHA1.hexdigest(password)
    end
  end
  
  def assign_random_password
    self.password = Account.random_password
  end
  
  def self.random_password
    rand(10e30).to_s(32)
  end
  
  def to_s
    login
  end
  
  protected
  def cannot_change_login
    if changed.include? 'login'
      errors.add(:login, "cannot be changed once the account has been created.")
    end
  end
end
