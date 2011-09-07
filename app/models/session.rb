class Session < ActiveRecord::Base
  attr_accessor :login, :password
  
  belongs_to :account
  
  before_create :associate_with_account_from_login,
                :generate_token!
  validate :validate_credentials 

  def associate_with_account_from_login
    unless self.login.blank?
      self.account = Account.find_by_login(self.login)
    end
  end
  
  def validate_credentials
    account = Account.find_by_login(login)
    
    if account.nil?
      errors[:login] << "is invalid."
    elsif !account.allow_passwordless_login? && (password.blank? || password != account.password)
      errors[:password] << "is invalid."
    end
  end
  
  def generate_token!
    self.token = Session.generate_token
  end
  
  def self.generate_token
    token = rand(36**5).to_s(36)    
    token = ("x" * (5 - token.length) + token) if token.length < 5
    return token
  end
end
