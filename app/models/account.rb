require 'digest/sha1'

class Account < ActiveRecord::Base  
  has_many :sessions,
    :dependent => :destroy
    
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
end
