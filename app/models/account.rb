require 'digest/sha1'

class Account < ActiveRecord::Base  
  has_many :sessions,
    :dependent => :destroy
  belongs_to :for, 
    :polymorphic => true
  
  before_validation :assign_random_password,
    :if => proc{ password.blank? && !login.blank? }
  
    
  # can't change login after creation because this acts as a
  # link to corresponding accounts in external services (XMPP, etc).
  attr_readonly :login
  
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
end
