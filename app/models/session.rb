class Session < ActiveRecord::Base
  attr_accessor :username, :password
  
  belongs_to :user
  
  before_create :associate_with_user_from_username,
                :generate_token!
  validate :validate_credentials 

  def associate_with_user_from_username
    unless self.username.blank?
      self.user = User.find_by_username(self.username)
    end
  end
  
  def validate_credentials
    puts username
    user = User.find_by_username(username)
    
    if user.nil?
      errors[:username] << "is invalid."
    elsif password.blank? || password != user.password
      errors[:password] << "is invalid."
    end
  end
  
  def generate_token!
    self.token = Session.generate_token
  end
  
  def self.generate_token
    rand(36**36).to_s(36)
  end
end
